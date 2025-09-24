import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../core/utils/animation_manager.dart';
import '../../../core/services/video_pool_manager.dart';
import '../../../domain/entities/video_preview.dart';
import 'constants.dart';

/// Carte vidéo compacte inspirée Apple TV+
class VideoCard extends StatefulWidget {
  const VideoCard({
    super.key,
    required this.video,
    this.width,
    this.height,
    this.onTap,
    this.autoplay = false, // compatibilité
    this.muted = true,
    this.showInfo = true,
    this.play = false, // contrôle externe prioritaire
  });

  final VideoPreview video;
  final double? width, height;
  final VoidCallback? onTap;
  final bool autoplay, muted, showInfo;
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
    _animationController = AnimationController(duration: const Duration(milliseconds: VideoCardConstants.animationDurationFast), vsync: this);
    _animationManager.registerAnimation(id: 'video_card_${widget.video.id}', controller: _animationController, priority: true);
    _scaleAnimation = Tween<double>(begin: VideoCardConstants.normalScale, end: VideoCardConstants.pressedScale).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }



  @override
  void dispose() {
    _animationManager.cancelAnimation('video_card_${widget.video.id}');
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) { HapticFeedback.lightImpact(); setState(() => _isPressed = true); _animationController.forward(); }
  void _onTapUp(TapUpDetails _) { setState(() => _isPressed = false); _animationController.reverse(); _handleTap(); }
  void _onTapCancel() { setState(() => _isPressed = false); _animationController.reverse(); }

  void _handleTap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context), isDark = theme.brightness == Brightness.dark;
    final cardWidth = widget.width ?? _defaultWidth, cardHeight = widget.height ?? _defaultHeight;

    return Semantics(
      button: true,
      label: widget.video.semanticLabel,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (_, __) => Transform.scale(
            scale: _scaleAnimation.value,
            filterQuality: FilterQuality.high,
            child: Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                // Ombre nette sans flou
                boxShadow: [BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? VideoCardConstants.shadowDarkOpacity : VideoCardConstants.shadowLightOpacity),
                  blurRadius: 0, // Pas de flou
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                )],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_borderRadius),
                child: Stack(fit: StackFit.expand, children: [
                  _buildMediaContent(isDark),
                  _buildGradientOverlay(),
                  if (widget.showInfo) _buildInfoOverlay(theme),
                  // _buildDurationBadge(), // Masqué selon demande utilisateur
                  // if (!_showVideo) _buildVideoIndicator(), // Masqué selon demande utilisateur
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(bool isDark) {
    // Choisit l'alignement selon le point focal fourni par le domaine
    final Alignment alignment = switch (widget.video.focalPoint) {
      VideoFocalPoint.top => Alignment.topCenter,
      VideoFocalPoint.bottom => Alignment.bottomCenter,
      VideoFocalPoint.center => Alignment.center,
    };

    // Utiliser le gestionnaire optimisé pour les vidéos
    return OptimizedVideoPlayer(
      videoUrl: widget.video.videoUrl,
      thumbnailUrl: widget.video.thumbnailUrl,
      play: widget.play && !_isPressed, // Jouer seulement si actif et non pressé
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
        
        // Placeholder pendant le chargement
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isDark ? Colors.grey[900]! : Colors.grey[300]!,
                isDark ? Colors.grey[800]! : Colors.grey[200]!,
              ],
            ),
          ),
          child: Center(
            child: widget.play 
              ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white30)
              : Icon(
                  Icons.play_circle_outline,
                  color: isDark ? Colors.white30 : Colors.black26,
                  size: 48,
                ),
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() => AnimatedContainer(
    duration: const Duration(milliseconds: VideoCardConstants.animationDurationNormal),
    decoration: BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black.withValues(alpha: _isPressed ? VideoCardConstants.pressedGradientEndOpacity : VideoCardConstants.gradientEndOpacity)],
      stops: const [VideoCardConstants.gradientStartStop, VideoCardConstants.gradientEndStop],
    )),
  );

  Widget _buildInfoOverlay(ThemeData theme) => Positioned(
    left: VideoCardConstants.contentPadding, right: VideoCardConstants.contentPadding, bottom: VideoCardConstants.contentPadding,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(widget.video.title, style: theme.textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, height: VideoCardConstants.titleLineHeight), maxLines: 2, overflow: TextOverflow.ellipsis),
      const SizedBox(height: VideoCardConstants.textIconSpacing),
      Text(widget.video.merchantName, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70, fontSize: VideoCardConstants.merchantNameFontSize), maxLines: 1, overflow: TextOverflow.ellipsis),
    ]),
  );

}