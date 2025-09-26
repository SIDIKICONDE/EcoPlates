import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/image_cache_service.dart';

/// Provider pour la stratégie de préchargement actuelle
final preloadStrategyProvider =
    NotifierProvider<PreloadStrategyNotifier, PreloadStrategy>(
      PreloadStrategyNotifier.new,
    );

class PreloadStrategyNotifier extends Notifier<PreloadStrategy> {
  @override
  PreloadStrategy build() {
    // Écouter la connectivité pour adapter la stratégie
    ref.listen(connectivityProvider, (previous, connectivityAsync) {
      connectivityAsync.whenData((connectivityList) {
        // Prendre le premier résultat de la liste
        final connectivity = connectivityList.isNotEmpty
            ? connectivityList.first
            : ConnectivityResult.none;

        switch (connectivity) {
          case ConnectivityResult.wifi:
            state = PreloadStrategy.aggressive;
          case ConnectivityResult.mobile:
            state = PreloadStrategy.moderate;
          case ConnectivityResult.none:
            state = PreloadStrategy.disabled;
          case ConnectivityResult.bluetooth:
          case ConnectivityResult.ethernet:
          case ConnectivityResult.vpn:
          case ConnectivityResult.other:
            state = PreloadStrategy.conservative;
        }
      });
    });

    return PreloadStrategy.moderate; // Par défaut
  }

  void updateStrategy(PreloadStrategy strategy) {
    state = strategy;
  }
}

/// Provider pour surveiller la connectivité
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Provider pour le manager de préchargement
final imagePreloadManagerProvider = Provider<ImagePreloadManager>((ref) {
  final cacheService = ref.watch(imageCacheServiceProvider);
  final strategy = ref.watch(preloadStrategyProvider);

  return ImagePreloadManager(cacheService: cacheService, strategy: strategy);
});

/// Stratégies de préchargement
enum PreloadStrategy {
  /// Précharge aggressivement (WiFi)
  aggressive(
    visibleRange: 5,
    maxConcurrent: 5,
    preloadDelay: Duration(milliseconds: 100),
    sizes: [ImageSize.thumbnail, ImageSize.small, ImageSize.medium],
  ),

  /// Précharge modérément (4G/5G)
  moderate(
    visibleRange: 3,
    maxConcurrent: 3,
    preloadDelay: Duration(milliseconds: 300),
    sizes: [ImageSize.thumbnail, ImageSize.small],
  ),

  /// Précharge conservateur (3G/données limitées)
  conservative(
    visibleRange: 1,
    maxConcurrent: 1,
    preloadDelay: Duration(milliseconds: 500),
    sizes: [ImageSize.thumbnail],
  ),

  /// Pas de préchargement (hors ligne)
  disabled(
    visibleRange: 0,
    maxConcurrent: 0,
    preloadDelay: Duration(seconds: 1),
    sizes: [],
  );

  const PreloadStrategy({
    required this.visibleRange,
    required this.maxConcurrent,
    required this.preloadDelay,
    required this.sizes,
  });

  final int visibleRange;
  final int maxConcurrent;
  final Duration preloadDelay;
  final List<ImageSize> sizes;
}

/// Gestionnaire de préchargement intelligent
class ImagePreloadManager {
  ImagePreloadManager({required this.cacheService, required this.strategy});

  final ImageCacheService cacheService;
  final PreloadStrategy strategy;

  // Cache des URLs en cours de préchargement
  final Set<String> _preloadingUrls = {};

  // File d'attente de préchargement avec priorités
  final Map<String, PreloadRequest> _preloadQueue = {};

  /// Précharge les images pour une liste scrollable
  Future<void> preloadForList({
    required List<String> imageUrls,
    required int visibleIndex,
    ImageSize? overrideSize,
    Priority priority = Priority.normal,
  }) async {
    if (strategy == PreloadStrategy.disabled) return;

    // Extraire les valeurs de stratégie pour éviter la duplication
    final visibleRange = strategy.visibleRange;
    final sizes = strategy.sizes;

    // Calculer la plage à précharger
    final startIndex = (visibleIndex - visibleRange).clamp(
      0,
      imageUrls.length - 1,
    );
    final endIndex = (visibleIndex + visibleRange).clamp(
      0,
      imageUrls.length - 1,
    );

    // Ajouter les requêtes à la file
    for (var i = startIndex; i <= endIndex; i++) {
      final url = imageUrls[i];
      final distance = (i - visibleIndex).abs();

      // Priorité basée sur la distance
      final adjustedPriority = _calculatePriority(distance, priority);

      _addToQueue(
        PreloadRequest(
          url: url,
          sizes: overrideSize != null ? [overrideSize] : sizes,
          priority: adjustedPriority,
          timestamp: DateTime.now(),
        ),
      );
    }

    // Traiter la file
    await _processQueue();
  }

  /// Précharge les images pour une grille
  Future<void> preloadForGrid({
    required List<String> imageUrls,
    required int visibleStartIndex,
    required int visibleEndIndex,
    required int crossAxisCount,
    ImageSize size = ImageSize.small,
    Priority priority = Priority.normal,
  }) async {
    if (strategy == PreloadStrategy.disabled) return;

    // Calculer les lignes visibles
    final startRow = visibleStartIndex ~/ crossAxisCount;
    final endRow = visibleEndIndex ~/ crossAxisCount;

    // Étendre la plage selon la stratégie
    final preloadStartRow = (startRow - strategy.visibleRange).clamp(0, 999);
    final preloadEndRow = endRow + strategy.visibleRange;

    // Précharger les images de la plage étendue
    for (var row = preloadStartRow; row <= preloadEndRow; row++) {
      for (var col = 0; col < crossAxisCount; col++) {
        final index = row * crossAxisCount + col;
        if (index < imageUrls.length) {
          final distance = _calculateGridDistance(
            index,
            visibleStartIndex,
            visibleEndIndex,
            crossAxisCount,
          );

          _addToQueue(
            PreloadRequest(
              url: imageUrls[index],
              sizes: [size],
              priority: _calculatePriority(distance, priority),
              timestamp: DateTime.now(),
            ),
          );
        }
      }
    }

    await _processQueue();
  }

  /// Précharge une image spécifique immédiatement
  Future<void> preloadNow(
    String imageUrl, {
    ImageSize size = ImageSize.medium,
    Priority priority = Priority.high,
  }) async {
    if (_preloadingUrls.contains(imageUrl)) return;

    _preloadingUrls.add(imageUrl);
    try {
      await cacheService.precacheImage(
        imageUrl,
        size: size,
        priority: priority,
      );
    } finally {
      _preloadingUrls.remove(imageUrl);
    }
  }

  /// Ajoute une requête à la file
  void _addToQueue(PreloadRequest request) {
    // Ne pas ajouter si déjà en cours
    if (_preloadingUrls.contains(request.url)) return;

    // Ajouter ou mettre à jour la priorité
    final existing = _preloadQueue[request.url];
    if (existing == null || request.priority.index > existing.priority.index) {
      _preloadQueue[request.url] = request;
    }
  }

  /// Traite la file de préchargement
  Future<void> _processQueue() async {
    if (_preloadQueue.isEmpty) return;

    // Extraire les valeurs de stratégie pour éviter la duplication
    final maxConcurrent = strategy.maxConcurrent;
    final preloadDelay = strategy.preloadDelay;

    // Trier par priorité et timestamp
    final sortedRequests = _preloadQueue.values.toList()
      ..sort((a, b) {
        final priorityCompare = b.priority.index.compareTo(a.priority.index);
        if (priorityCompare != 0) return priorityCompare;
        return a.timestamp.compareTo(b.timestamp);
      });

    // Traiter par batch selon la stratégie
    final batches = <List<PreloadRequest>>[];
    for (var i = 0; i < sortedRequests.length; i += maxConcurrent) {
      batches.add(sortedRequests.skip(i).take(maxConcurrent).toList());
    }

    // Exécuter les batches avec délai
    for (final batch in batches) {
      await Future.wait(batch.map(_executePreload));

      // Délai entre les batches pour ne pas surcharger
      if (batches.last != batch) {
        await Future<void>.delayed(preloadDelay);
      }
    }

    // Nettoyer la file
    _preloadQueue.clear();
  }

  /// Exécute une requête de préchargement
  Future<void> _executePreload(PreloadRequest request) async {
    _preloadingUrls.add(request.url);
    _preloadQueue.remove(request.url);

    try {
      // Précharger toutes les tailles demandées
      for (final size in request.sizes) {
        await cacheService.precacheImage(
          request.url,
          size: size,
          priority: request.priority,
        );
      }
    } on Exception catch (e) {
      debugPrint('Erreur préchargement ${request.url}: $e');
    } finally {
      _preloadingUrls.remove(request.url);
    }
  }

  /// Calcule la priorité basée sur la distance
  Priority _calculatePriority(int distance, Priority basePriority) {
    if (distance == 0) return Priority.high;
    if (distance <= 1 && basePriority != Priority.low) return Priority.high;
    if (distance <= 2) return basePriority;
    return Priority.low;
  }

  /// Calcule la distance dans une grille
  int _calculateGridDistance(
    int index,
    int visibleStart,
    int visibleEnd,
    int crossAxisCount,
  ) {
    if (index >= visibleStart && index <= visibleEnd) return 0;

    final indexRow = index ~/ crossAxisCount;
    final startRow = visibleStart ~/ crossAxisCount;
    final endRow = visibleEnd ~/ crossAxisCount;

    if (indexRow < startRow) return startRow - indexRow;
    return indexRow - endRow;
  }

  /// Nettoie les ressources
  void dispose() {
    _preloadQueue.clear();
    _preloadingUrls.clear();
  }
}

/// Requête de préchargement
class PreloadRequest {
  const PreloadRequest({
    required this.url,
    required this.sizes,
    required this.priority,
    required this.timestamp,
  });

  final String url;
  final List<ImageSize> sizes;
  final Priority priority;
  final DateTime timestamp;
}

/// Mixin pour widgets avec préchargement automatique
mixin AutoPreloadImages<T extends StatefulWidget> on State<T> {
  Timer? _preloadTimer;
  int _lastVisibleIndex = 0;

  /// Démarre le préchargement automatique
  void startAutoPreload({
    required List<String> imageUrls,
    required WidgetRef ref,
    ImageSize size = ImageSize.small,
    Duration debounce = const Duration(milliseconds: 300),
  }) {
    _preloadTimer?.cancel();
    _preloadTimer = Timer(debounce, () {
      unawaited(
        ref
            .read(imagePreloadManagerProvider)
            .preloadForList(
              imageUrls: imageUrls,
              visibleIndex: _lastVisibleIndex,
              overrideSize: size,
            ),
      );
    });
  }

  /// Met à jour l'index visible
  set visibleIndex(int index) {
    _lastVisibleIndex = index;
  }

  @override
  void dispose() {
    _preloadTimer?.cancel();
    super.dispose();
  }
}
