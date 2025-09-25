import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/image_cache_service.dart';

/// Provider pour la configuration du cache
final cacheConfigProvider = Provider<CacheConfig>((ref) {
  return CacheConfig();
});

/// Configuration globale du système de cache
class CacheConfig {
  /// Initialise le cache au démarrage de l'application
  static Future<void> initialize() async {
    // Configuration du cache d'images Flutter
    PaintingBinding.instance.imageCache.maximumSize = 200; // Nombre max d'images
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024; // 100 MB
    
    // Configuration de CachedNetworkImage
    CachedNetworkImage.logLevel = CacheManagerLogLevel.none;
    
    // Nettoyer le cache expiré au démarrage
    await _cleanExpiredCache();
  }
  
  /// Nettoie le cache expiré
  static Future<void> _cleanExpiredCache() async {
    try {
      final defaultCacheManager = CacheManager(Config('ecoplates_image_cache'));
      final thumbnailCacheManager = CacheManager(Config('ecoplates_image_cache_thumbnails'));
      
      await Future.wait<void>([
        defaultCacheManager.emptyCache(),
        thumbnailCacheManager.emptyCache(),
      ]);
    } catch (e) {
      debugPrint('Erreur nettoyage cache: $e');
    }
  }
  
  /// Configure les paramètres de performance
  static void configurePerformance() {
    // Optimisations spécifiques pour les images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Réduire la qualité pour les appareils bas de gamme
      if (_isLowEndDevice()) {
        PaintingBinding.instance.imageCache.maximumSize = 100;
        PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;
      }
    });
  }
  
  /// Détecte si l'appareil est bas de gamme
  static bool _isLowEndDevice() {
    // Détection basique basée sur la RAM disponible
    // En production, utiliser device_info_plus pour une détection plus précise
    final binding = WidgetsBinding.instance;
    final views = binding.platformDispatcher.views;
    if (views.isEmpty) return false;
    
    final view = views.first;
    final devicePixelRatio = view.devicePixelRatio;
    final size = view.physicalSize;
    
    // Appareil avec faible résolution ou ratio de pixels
    return size.width / devicePixelRatio < 360 || 
            size.height / devicePixelRatio < 640;
  }
  
  /// Optimise le cache pour le mode sombre
  static void optimizeForDarkMode({required bool isDarkMode}) {
    // En mode sombre, on peut réduire lègrement la qualité
    // car les imperfections sont moins visibles
    if (isDarkMode) {
      PaintingBinding.instance.imageCache.maximumSizeBytes = 
          (PaintingBinding.instance.imageCache.maximumSizeBytes * 0.9).round();
    }
  }
}

/// Extension pour optimiser les images selon le contexte
extension ImageOptimizationContext on BuildContext {
  /// Détermine la taille d'image optimale selon l'écran
  ImageSize getOptimalImageSize({
    double? targetWidth,
    double? targetHeight,
  }) {
    final mediaQuery = MediaQuery.of(this);
    final screenWidth = mediaQuery.size.width;
    final pixelRatio = mediaQuery.devicePixelRatio;
    
    // Calculer la taille physique nécessaire
    final physicalWidth = (targetWidth ?? screenWidth) * pixelRatio;
    
    if (physicalWidth <= 150 * pixelRatio) {
      return ImageSize.thumbnail;
    } else if (physicalWidth <= 300 * pixelRatio) {
      return ImageSize.small;
    } else if (physicalWidth <= 600 * pixelRatio) {
      return ImageSize.medium;
    } else {
      return ImageSize.large;
    }
  }
  
  /// Vérifie si on doit utiliser des images de qualité réduite
  bool shouldReduceImageQuality() {
    final mediaQuery = MediaQuery.of(this);
    // Réduire la qualité sur les très petits écrans
    return mediaQuery.size.width < 360;
  }
}

/// Mixin pour widgets nécessitant une optimisation d'image
mixin ImageOptimizationMixin<T extends StatefulWidget> on State<T> {
  late ImageSize _optimalSize;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateOptimalSize();
  }
  
  void _updateOptimalSize() {
    _optimalSize = context.getOptimalImageSize();
  }
  
  ImageSize get optimalImageSize => _optimalSize;
}
