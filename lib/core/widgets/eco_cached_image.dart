import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../services/image_cache_service.dart';

/// Widget d'image optimisé avec cache haute performance
/// 
/// Features:
/// - Cache multi-niveaux automatique
/// - Placeholders animés
/// - Gestion d'erreurs élégante
/// - Optimisation de taille automatique
/// - Support du mode hors-ligne
class EcoCachedImage extends ConsumerStatefulWidget {

  const EcoCachedImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.size = ImageSize.medium,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.showLoading = true,
    this.borderRadius,
    this.backgroundColor,
    this.shadows,
    this.enableMemoryCache = true,
    this.onTap,
    this.heroTag,
    this.priority = Priority.normal,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageSize size;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final bool showLoading;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;
  final bool enableMemoryCache;
  final VoidCallback? onTap;
  final String? heroTag;
  final Priority priority;

  @override
  ConsumerState<EcoCachedImage> createState() => _EcoCachedImageState();
}

class _EcoCachedImageState extends ConsumerState<EcoCachedImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.fadeInDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final cacheService = ref.watch(imageCacheServiceProvider);
    // final theme = Theme.of(context);

    // Déterminer les dimensions optimales
    final targetWidth = _getOptimalSize(widget.width, widget.size);
    final targetHeight = _getOptimalSize(widget.height, widget.size);

    Widget imageWidget = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      memCacheWidth: targetWidth?.toInt(),
      memCacheHeight: targetHeight?.toInt(),
      fadeInDuration: widget.fadeInDuration,
      fadeOutDuration: const Duration(milliseconds: 150),
      cacheManager: widget.size == ImageSize.thumbnail
          ? CacheManager(Config(
              'ecoplates_image_cache_thumbnails',
              stalePeriod: const Duration(days: 30),
              maxNrOfCacheObjects: 2000,
            ))
          : CacheManager(Config(
              'ecoplates_image_cache',
              stalePeriod: const Duration(days: 30),
              maxNrOfCacheObjects: 1000,
            )),
      placeholder: widget.showLoading
          ? (context, url) =>
              widget.placeholder ?? _buildDefaultPlaceholder(context)
          : null,
      errorWidget: (context, url, error) =>
          widget.errorWidget ?? _buildDefaultErrorWidget(context, error),
      imageBuilder: (context, imageProvider) {
        unawaited(_controller.forward());
        return FadeTransition(
          opacity: _animation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: widget.backgroundColor,
              boxShadow: widget.shadows,
              image: DecorationImage(
                image: imageProvider,
                fit: widget.fit,
              ),
            ),
          ),
        );
      },
    );

    // Wrapper avec Hero animation si nécessaire
    if (widget.heroTag != null) {
      imageWidget = Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    // Ajouter interaction si onTap défini
    if (widget.onTap != null) {
      imageWidget = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: widget.borderRadius,
          child: imageWidget,
        ),
      );
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: imageWidget,
    );
  }

  /// Calcule la taille optimale basée sur la taille demandée et le preset
  double? _getOptimalSize(double? requestedSize, ImageSize preset) {
    if (requestedSize != null) return requestedSize;
    
    switch (preset) {
      case ImageSize.thumbnail:
        return 150;
      case ImageSize.small:
        return 300;
      case ImageSize.medium:
        return 600;
      case ImageSize.large:
        return 1200;
      case ImageSize.original:
        return null;
    }
  }

  /// Placeholder par défaut avec effet shimmer
  Widget _buildDefaultPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }

  /// Widget d'erreur par défaut
  Widget _buildDefaultErrorWidget(BuildContext context, dynamic error) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: widget.borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: widget.height != null ? widget.height! * 0.3 : 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          if (widget.height == null || widget.height! > 100)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Image non disponible',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget optimisé pour les avatars circulaires
class EcoCachedAvatar extends StatelessWidget {
  const EcoCachedAvatar({
    required this.imageUrl,
    super.key,
    this.radius = 20,
    this.placeholder,
    this.errorWidget,
    this.priority = Priority.normal,
  });
  
  final String imageUrl;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Priority priority;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: EcoCachedImage(
        imageUrl: imageUrl,
        width: radius * 2,
        height: radius * 2,
        size: ImageSize.thumbnail,
        placeholder: placeholder,
        errorWidget: errorWidget,
        priority: priority,
      ),
    );
  }
}

/// Widget pour images de fond (parallax, hero, etc.)
class EcoCachedBackgroundImage extends StatelessWidget {
  const EcoCachedBackgroundImage({
    required this.imageUrl,
    required this.child,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.opacity = 1.0,
    this.overlayColor,
    this.blendMode,
  });
  
  final String imageUrl;
  final Widget child;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final double opacity;
  final Color? overlayColor;
  final BlendMode? blendMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: EcoCachedImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            size: ImageSize.large,
          ),
        ),
        if (overlayColor != null)
          Positioned.fill(
            child: ColoredBox(
              color: overlayColor!.withValues(alpha: opacity),
              child: blendMode != null
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        overlayColor!,
                        blendMode!,
                      ),
                      child: Container(),
                    )
                  : null,
            ),
          ),
        child,
      ],
    );
  }
}

/// Mixin pour préchargement d'images dans les listes
mixin ImagePreloadMixin<T extends StatefulWidget> on State<T> {
  final Set<String> _preloadedUrls = {};

  /// Précharge les images visibles et proches
  Future<void> preloadVisibleImages(
    List<String> imageUrls,
    WidgetRef ref, {
    int visibleRange = 3,
    ImageSize size = ImageSize.small,
  }) async {
    final cacheService = ref.read(imageCacheServiceProvider);
    
    // Déterminer les indices à précharger
    final currentIndex = _getCurrentVisibleIndex();
    final startIndex = (currentIndex - visibleRange).clamp(0, imageUrls.length);
    final endIndex = (currentIndex + visibleRange).clamp(0, imageUrls.length);
    
    // Précharger uniquement les nouvelles images
    final urlsToPreload = <String>[];
    for (var i = startIndex; i < endIndex; i++) {
      final url = imageUrls[i];
      if (!_preloadedUrls.contains(url)) {
        urlsToPreload.add(url);
        _preloadedUrls.add(url);
      }
    }
    
    if (urlsToPreload.isNotEmpty) {
      await cacheService.precacheImages(
        urlsToPreload,
        size: size,
        maxConcurrent: 2,
      );
    }
  }

  /// Override cette méthode pour retourner l'index visible actuel
  int _getCurrentVisibleIndex() => 0;
  
  @override
  void dispose() {
    _preloadedUrls.clear();
    super.dispose();
  }
}
