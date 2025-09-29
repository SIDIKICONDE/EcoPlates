import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../core/services/image_cache_service.dart';
import '../../../core/services/video_pool_manager.dart';
import '../../../core/utils/animation_manager.dart';
import '../../../core/widgets/eco_cached_image.dart';
import '../../../domain/entities/video_preview.dart';
import 'constants.dart';

/// Carte vidéo compacte inspirée Apple TV+
class VideoCard extends StatefulWidget {
  const VideoCard({
    required this.video,
    super.key,
    this.width,
    this.height,
    this.onTap,
    this.autoplay = false, // compatibilité
    this.muted = true,
    this.showInfo = true,
    this.play = false, // contrôle externe prioritaire
  });

  final VideoPreview video;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool autoplay;
  final bool muted;
  final bool showInfo;
  final bool play;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  final AnimationManager _animationManager = AnimationManager();

  static const double _defaultWidth = VideoCardConstants.defaultWidth;
  static const double _defaultHeight = VideoCardConstants.defaultHeight;
  static const double _borderRadius = VideoCardConstants.borderRadius;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: VideoCardConstants.animationDurationFast,
      ),
      vsync: this,
    );
    unawaited(
      _animationManager.registerAnimation(
        id: 'video_card_${widget.video.id}',
        controller: _animationController,
        priority: true,
      ),
    );
    _scaleAnimation =
        Tween<double>(
          begin: VideoCardConstants.normalScale,
          end: VideoCardConstants.pressedScale,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    unawaited(
      _animationManager.cancelAnimation('video_card_${widget.video.id}'),
    );
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails _) async {
    await HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
    unawaited(_animationController.forward());
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    unawaited(_animationController.reverse());
    _handleTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    unawaited(_animationController.reverse());
  }

  void _handleTap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardWidth = widget.width ?? _defaultWidth;
    final cardHeight = widget.height ?? _defaultHeight;

    return Semantics(
      button: true,
      label: widget.video.semanticLabel,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (_, _) => Transform.scale(
            scale: _scaleAnimation.value,
            filterQuality: FilterQuality.high,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                // Ombre nette sans flou
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_borderRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildMediaContent(isDark),
                    _buildGradientOverlay(),
                    if (widget.showInfo) _buildInfoOverlay(theme),
                    // _buildDurationBadge(), // Masqué selon demande utilisateur
                    // if (!_showVideo) _buildVideoIndicator(), // Masqué selon demande utilisateur
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(bool isDark) {
    // Choisit l'alignement selon le point focal fourni par le domaine
    final alignment = switch (widget.video.focalPoint) {
      VideoFocalPoint.top => Alignment.topCenter,
      VideoFocalPoint.bottom => Alignment.bottomCenter,
      VideoFocalPoint.center => Alignment.center,
    };

    // Utiliser le gestionnaire optimisé pour les vidéos
    return OptimizedVideoPlayer(
      videoUrl: widget.video.videoUrl,
      thumbnailUrl: widget.video.thumbnailUrl,
      play:
          widget.play && !_isPressed, // Jouer seulement si actif et non pressé
      builder: (context, controller) {
        if (controller != null && controller.value.isInitialized) {
          return SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: alignment,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          );
        }

        // Afficher le thumbnail si disponible, sinon placeholder
        if (!widget.play && widget.video.thumbnailUrl.isNotEmpty) {
          return Stack(
            fit: StackFit.expand,
            children: [
              EcoCachedImage(
                imageUrl: widget.video.thumbnailUrl,
                size: ImageSize.small,
                // On reproduit le placeholder gradient
                placeholder: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        if (isDark) Colors.grey[900]! else Colors.grey[300]!,
                        if (isDark) Colors.grey[800]! else Colors.grey[200]!,
                      ],
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white30,
                    ),
                  ),
                ),
                errorWidget: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        if (isDark) Colors.grey[900]! else Colors.grey[300]!,
                        if (isDark) Colors.grey[800]! else Colors.grey[200]!,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.broken_image,
                      color: isDark ? Colors.white30 : Colors.black26,
                      size: 16.0 * 3,
                    ),
                  ),
                ),
              ),
              // Icône play overlay sur le thumbnail (taille adaptée)
              Center(
                child: Container(
                  width: (widget.height ?? _defaultHeight) <= 150 ? 40.0 : 60.0,
                  height: (widget.height ?? _defaultHeight) <= 150
                      ? 40.0
                      : 60.0,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: (widget.height ?? _defaultHeight) <= 150
                        ? 20.0
                        : 30.0,
                  ),
                ),
              ),
            ],
          );
        }

        // Placeholder si pas de thumbnail ou en chargement vidéo
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                if (isDark) Colors.grey[900]! else Colors.grey[300]!,
                if (isDark) Colors.grey[800]! else Colors.grey[200]!,
              ],
            ),
          ),
          child: Center(
            child: widget.play
                ? CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white30,
                  )
                : Icon(
                    Icons.play_circle_outline,
                    color: isDark ? Colors.white30 : Colors.black26,
                    size: 16.0 * 3,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() => AnimatedContainer(
    duration: const Duration(
      milliseconds: VideoCardConstants.animationDurationNormal,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(
            alpha: _isPressed
                ? VideoCardConstants.pressedGradientEndOpacity
                : VideoCardConstants.gradientEndOpacity,
          ),
        ],
        stops: const [
          VideoCardConstants.gradientStartStop,
          VideoCardConstants.gradientEndStop,
        ],
      ),
    ),
  );

  Widget _buildInfoOverlay(ThemeData theme) {
    final isCompact =
        (widget.height ?? _defaultHeight) <=
        150; // Mode compact si hauteur <= 150

    if (isCompact) {
      // Mode compact : seulement le nom de l'enseigne
      return Positioned(
        left: VideoCardConstants.contentPadding,
        right: VideoCardConstants.contentPadding,
        bottom: VideoCardConstants.contentPadding,
        child: Text(
          widget.video.merchantName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0.0, 1.0),
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // Mode normal : titre et nom du marchand
    return Positioned(
      left: VideoCardConstants.contentPadding,
      right: VideoCardConstants.contentPadding,
      bottom: VideoCardConstants.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.video.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.0),
          Text(
            widget.video.merchantName,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
