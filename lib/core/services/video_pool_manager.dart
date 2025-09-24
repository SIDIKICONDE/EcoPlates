import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
/// Gestionnaire optimisé des vidéos avec pool de contrôleurs
/// 
/// Permet de réutiliser les contrôleurs vidéo et d'optimiser
/// les performances selon les directives EcoPlates
class VideoPoolManager {
  factory VideoPoolManager() => _instance;
  VideoPoolManager._internal();
  static final VideoPoolManager _instance = VideoPoolManager._internal();

  final Map<String, VideoPlayerController> _controllers = {};
  final Map<String, DateTime> _lastUsed = {};
  
  static const int _maxPoolSize = 5;
  static const Duration _cacheTimeout = Duration(minutes: 5);

  /// Obtient un contrôleur pour une URL donnée
  VideoPlayerController? getController(String videoUrl) {
    // Nettoie les contrôleurs expirés
    _cleanupExpiredControllers();
    
    if (_controllers.containsKey(videoUrl)) {
      _lastUsed[videoUrl] = DateTime.now();
      return _controllers[videoUrl];
    }
    
    return null;
  }

  /// Crée un nouveau contrôleur pour une URL
  Future<VideoPlayerController> createController(String videoUrl) async {
    // Limite la taille du pool
    if (_controllers.length >= _maxPoolSize) {
      _removeOldestController();
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _controllers[videoUrl] = controller;
    _lastUsed[videoUrl] = DateTime.now();
    
    await controller.initialize();
    return controller;
  }

  /// Supprime tous les contrôleurs
  void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _lastUsed.clear();
  }

  /// Nettoie les contrôleurs expirés
  void _cleanupExpiredControllers() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    for (final entry in _lastUsed.entries) {
      if (now.difference(entry.value) > _cacheTimeout) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
      _lastUsed.remove(key);
    }
  }

  /// Retourne un contrôleur au pool (pour réutilisation)
  void returnController(String videoUrl, VideoPlayerController controller) {
    if (_controllers.length < _maxPoolSize) {
      _controllers[videoUrl] = controller;
      _lastUsed[videoUrl] = DateTime.now();
    } else {
      // Pool plein, dispose le contrôleur
      controller.dispose();
    }
  }

  /// Supprime le contrôleur le plus ancien
  void _removeOldestController() {
    if (_lastUsed.isEmpty) return;

    final oldestKey = _lastUsed.entries
        .reduce((a, b) => a.value.isBefore(b.value) ? a : b)
        .key;

    _controllers[oldestKey]?.dispose();
    _controllers.remove(oldestKey);
    _lastUsed.remove(oldestKey);
  }
}

/// Widget optimisé pour lire des vidéos avec gestion de pool
class OptimizedVideoPlayer extends StatefulWidget {
  const OptimizedVideoPlayer({
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.play,
    required this.builder,
    super.key,
  });

  final String videoUrl;
  final String thumbnailUrl;
  final bool play;
  final Widget Function(BuildContext context, VideoPlayerController? controller) builder;

  @override
  State<OptimizedVideoPlayer> createState() => _OptimizedVideoPlayerState();
}

class _OptimizedVideoPlayerState extends State<OptimizedVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    if (widget.play) {
      unawaited(_initializeController());
    }
  }

  @override
  void didUpdateWidget(OptimizedVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.play != oldWidget.play) {
      if (widget.play) {
        unawaited(_initializeController());
      } else {
        _pauseController();
      }
    }
  }

  Future<void> _initializeController() async {
    if (_isInitializing || !mounted) return;
    _isInitializing = true;

    try {
      // Utilise le provider Riverpod pour une gestion centralisée
      final poolManager = VideoPoolManager(); // Singleton géré par Riverpod

      // Essaie d'obtenir un contrôleur existant du pool ou en crée un nouveau
      _controller = poolManager.getController(widget.videoUrl) ??
          await poolManager.createController(widget.videoUrl);

      if (_controller != null && mounted) {
        _controller!.setLooping(true);
        _controller!.setVolume(0); // Muet par défaut
        await _controller!.play();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint("Erreur lors de l'initialisation de la vidéo: $e");
      // Nettoie en cas d'erreur selon les directives EcoPlates
      _controller?.dispose();
      _controller = null;
      if (mounted) {
        setState(() {});
      }
    } finally {
      _isInitializing = false;
    }
  }

  void _pauseController() {
    _controller?.pause();
  }

  @override
  void dispose() {
    // Retourner le contrôleur au pool au lieu de le disposer
    if (_controller != null) {
      VideoPoolManager().returnController(widget.videoUrl, _controller!);
      _controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller);
  }
}

// Provider Riverpod pour le VideoPoolManager (selon directives EcoPlates)
final videoPoolManagerProvider = Provider<VideoPoolManager>((ref) {
  return VideoPoolManager();
});

// Hook pour accéder au provider depuis les widgets
VideoPoolManager useVideoPoolManager(WidgetRef ref) {
  return ref.watch(videoPoolManagerProvider);
}
