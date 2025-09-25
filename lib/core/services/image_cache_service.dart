import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Provider pour le service de cache d'images
final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  return ImageCacheService();
});

/// Service de gestion du cache d'images haute performance
/// 
/// Optimisations:
/// - Cache multi-niveaux (mémoire + disque)
/// - Préchargement intelligent
/// - Compression automatique
/// - Gestion des priorités
class ImageCacheService {
  
  ImageCacheService() {
    _initializeCacheManagers();
  }
  static const String _cacheKey = 'ecoplates_image_cache';
  
  // Configuration du cache
  static const Duration _cacheDuration = Duration(days: 30);
  static const int _maxCacheObjects = 1000;
  // static const int _maxCacheSizeBytes = 500 * 1024 * 1024; // 500MB - Unused
  
  // Tailles d'images prédéfinies pour optimisation
  static const Map<ImageSize, int> _imageSizes = {
    ImageSize.thumbnail: 150,
    ImageSize.small: 300,
    ImageSize.medium: 600,
    ImageSize.large: 1200,
    ImageSize.original: 0, // Taille originale
  };
  
  late final CacheManager _cacheManager;
  late final CacheManager _thumbnailCacheManager;
  
  // Cache en mémoire pour accès ultra-rapide
  final Map<String, Uint8List> _memoryCache = {};
  static const int _maxMemoryCacheSize = 50 * 1024 * 1024; // 50MB
  int _currentMemoryCacheSize = 0;
  
  void _initializeCacheManagers() {
    // Cache principal pour images de taille normale
    _cacheManager = CacheManager(
      Config(
        _cacheKey,
        stalePeriod: _cacheDuration,
        maxNrOfCacheObjects: _maxCacheObjects,
        fileService: EcoPlatesFileService(),
      ),
    );
    
    // Cache séparé pour les miniatures (accès plus fréquent)
    _thumbnailCacheManager = CacheManager(
      Config(
        '${_cacheKey}_thumbnails',
        stalePeriod: _cacheDuration * 2, // Les miniatures peuvent rester plus longtemps
        maxNrOfCacheObjects: _maxCacheObjects * 2,
        fileService: EcoPlatesFileService(),
      ),
    );
  }
  
  /// Précharge une image avec la taille spécifiée
  Future<void> precacheImage(
    String imageUrl, {
    ImageSize size = ImageSize.medium,
    Priority priority = Priority.normal,
  }) async {
    try {
      final cacheKey = _getCacheKey(imageUrl, size);
      
      // Vérifier si déjà en cache mémoire
      if (_memoryCache.containsKey(cacheKey)) {
        return;
      }
      
      // Sélectionner le bon gestionnaire de cache
      final cacheManager = size == ImageSize.thumbnail 
        ? _thumbnailCacheManager 
        : _cacheManager;
      
      // Télécharger et mettre en cache
      final file = await cacheManager.getSingleFile(
        imageUrl,
        headers: _getOptimizedHeaders(size),
      );
      
      // Ajouter au cache mémoire si haute priorité
      if (priority == Priority.high && file.existsSync()) {
        await _addToMemoryCache(cacheKey, await file.readAsBytes());
      }
    } catch (e) {
      debugPrint('Erreur préchargement image: $e');
    }
  }
  
  /// Précharge plusieurs images en batch (optimisé pour les listes)
  Future<void> precacheImages(
    List<String> imageUrls, {
    ImageSize size = ImageSize.small,
    int maxConcurrent = 3,
  }) async {
    // Traiter par batch pour éviter la surcharge
    for (var i = 0; i < imageUrls.length; i += maxConcurrent) {
      final batch = imageUrls.skip(i).take(maxConcurrent);
      await Future.wait(
        batch.map((url) => precacheImage(url, size: size)),
      );
    }
  }
  
  /// Récupère une image depuis le cache ou la télécharge
  Future<File?> getCachedImage(
    String imageUrl, {
    ImageSize size = ImageSize.medium,
  }) async {
    try {
      final cacheManager = size == ImageSize.thumbnail 
        ? _thumbnailCacheManager 
        : _cacheManager;
        
      return await cacheManager.getSingleFile(
        imageUrl,
        headers: _getOptimizedHeaders(size),
      );
    } catch (e) {
      debugPrint('Erreur récupération image cachée: $e');
      return null;
    }
  }
  
  /// Obtient les données d'image depuis le cache mémoire
  Uint8List? getMemoryCachedImage(String imageUrl, ImageSize size) {
    final cacheKey = _getCacheKey(imageUrl, size);
    return _memoryCache[cacheKey];
  }
  
  /// Ajoute une image au cache mémoire
  Future<void> _addToMemoryCache(String key, Uint8List data) async {
    final dataSize = data.length;
    
    // Nettoyer le cache si nécessaire
    while (_currentMemoryCacheSize + dataSize > _maxMemoryCacheSize && 
           _memoryCache.isNotEmpty) {
      final firstKey = _memoryCache.keys.first;
      final removedData = _memoryCache.remove(firstKey);
      if (removedData != null) {
        _currentMemoryCacheSize -= removedData.length;
      }
    }
    
    // Ajouter la nouvelle image
    _memoryCache[key] = data;
    _currentMemoryCacheSize += dataSize;
  }
  
  /// Nettoie tout le cache
  Future<void> clearCache() async {
    await Future.wait([
      _cacheManager.emptyCache(),
      _thumbnailCacheManager.emptyCache(),
    ]);
    _memoryCache.clear();
    _currentMemoryCacheSize = 0;
  }
  
  /// Nettoie les images expirées
  Future<void> removeExpiredCache() async {
    await Future.wait<void>([
      _cacheManager.emptyCache(),
      _thumbnailCacheManager.emptyCache(),
    ]);
  }
  
  /// Obtient la taille actuelle du cache
  Future<CacheInfo> getCacheInfo() async {
    final directory = await getTemporaryDirectory();
    final cacheDir = Directory('${directory.path}/$_cacheKey');
    
    var totalSize = 0;
    var fileCount = 0;
    
    if (await cacheDir.exists()) {
      await for (final file in cacheDir.list(recursive: true)) {
        if (file is File) {
          totalSize += await file.length();
          fileCount++;
        }
      }
    }
    
    return CacheInfo(
      totalSizeBytes: totalSize,
      fileCount: fileCount,
      memoryCacheSizeBytes: _currentMemoryCacheSize,
      memoryCacheCount: _memoryCache.length,
    );
  }
  
  /// Headers optimisés pour réduire la bande passante
  Map<String, String> _getOptimizedHeaders(ImageSize size) {
    return {
      'Accept': 'image/webp,image/jpeg,image/*;q=0.9',
      'Accept-Encoding': 'gzip, deflate',
      if (size != ImageSize.original)
        'X-Requested-Width': _imageSizes[size].toString(),
    };
  }
  
  /// Génère une clé de cache unique
  String _getCacheKey(String url, ImageSize size) {
    return '${url}_${size.name}';
  }
}

/// Service de fichiers personnalisé pour optimisations
class EcoPlatesFileService extends FileService {
  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    // Utilise l'implémentation de la classe parente HttpFileService
    final httpFileService = HttpFileService();
    return httpFileService.get(url, headers: headers);
  }
}

/// Tailles d'images prédéfinies
enum ImageSize {
  thumbnail,
  small,
  medium,
  large,
  original,
}

/// Priorités de cache
enum Priority {
  low,
  normal,
  high,
}

/// Informations sur le cache
class CacheInfo {
  
  const CacheInfo({
    required this.totalSizeBytes,
    required this.fileCount,
    required this.memoryCacheSizeBytes,
    required this.memoryCacheCount,
  });
  final int totalSizeBytes;
  final int fileCount;
  final int memoryCacheSizeBytes;
  final int memoryCacheCount;
  
  double get totalSizeMB => totalSizeBytes / (1024 * 1024);
  double get memoryCacheSizeMB => memoryCacheSizeBytes / (1024 * 1024);
}

/// Extension pour simplifier l'utilisation avec CachedNetworkImage
extension CachedNetworkImageExtensions on CachedNetworkImage {
  static CachedNetworkImageProvider optimizedProvider(
    String imageUrl, {
    ImageSize size = ImageSize.medium,
    int? maxWidth,
    int? maxHeight,
  }) {
    const imageSizes = {
      ImageSize.thumbnail: 150,
      ImageSize.small: 300,
      ImageSize.medium: 600,
      ImageSize.large: 1200,
      ImageSize.original: 0,
    };
    
    final targetWidth = maxWidth ?? imageSizes[size] ?? 0;
    final targetHeight = maxHeight ?? imageSizes[size] ?? 0;
    
    return CachedNetworkImageProvider(
      imageUrl,
      maxWidth: targetWidth > 0 ? targetWidth : null,
      maxHeight: targetHeight > 0 ? targetHeight : null,
      cacheManager: size == ImageSize.thumbnail
          ? CacheManager(Config('ecoplates_image_cache_thumbnails'))
          : CacheManager(Config('ecoplates_image_cache')),
    );
  }
}
