import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/video_preview.dart';
import 'constants.dart';
import 'video_card.dart';

/// Widget pour liste horizontale vidéos style Apple TV+
class VideoSlider extends StatefulWidget {
  const VideoSlider({
    required this.videos,
    super.key,
    this.title,
    this.height = VideoSliderConstants.defaultHeight,
    this.onVideoTap,
    this.onSeeAllTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: VideoSliderConstants.defaultHorizontalPadding,
    ),
  });

  final List<VideoPreview> videos;
  final String? title;
  final double height;
  final void Function(VideoPreview)? onVideoTap;
  final VoidCallback? onSeeAllTap;
  final EdgeInsets padding;

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_onScroll);
  AnimationController? _animationController;
  double _scrollOffset = 0;
  double _viewportWidth = 0;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: VideoSliderConstants.sliderAnimationDuration,
      ),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() => _scrollOffset = _scrollController.offset);
    _recomputeActiveIndex();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          _buildHeader(theme),
          SizedBox(height: context.scaleXS_SM_MD_LG),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            _viewportWidth = constraints.maxWidth;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _recomputeActiveIndex(),
            );
            return SizedBox(
              height: widget.height,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: widget.padding,
                itemCount: widget.videos.length,
                itemBuilder: (_, index) =>
                    _buildVideoItem(constraints.maxWidth, index),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) => Padding(
    padding: widget.padding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title!,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: VideoSliderConstants.letterSpacing,
          ),
        ),
        if (widget.onSeeAllTap != null)
          TextButton(
            onPressed: widget.onSeeAllTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleSM_MD_LG_XL,
                vertical: context.scaleXXS_XS_SM_MD,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.lg,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tout voir',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: EcoPlatesDesignTokens.size.icon(context),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
      ],
    ),
  );

  Widget _buildVideoItem(double screenWidth, int index) {
    final video = widget.videos[index];
    final isFirst = index == 0;
    final isLast = index == widget.videos.length - 1;
    final itemOffset = (index * VideoSliderConstants.itemWidth) - _scrollOffset;

    return Container(
      width: VideoSliderConstants.itemWidth,
      margin: EdgeInsets.only(
        left: isFirst ? 0 : VideoSliderConstants.itemMargin,
        right: isLast ? 0 : VideoSliderConstants.itemMargin,
      ),
      child: Transform.translate(
        offset: Offset(itemOffset * VideoSliderConstants.parallaxFactor, 0),
        filterQuality: FilterQuality.high,
        child: VideoCard(
          video: video,
          width: VideoCardConstants.defaultWidth,
          height: widget.height,
          onTap: () => widget.onVideoTap?.call(video),
        ),
      ),
    );
  }

  void _recomputeActiveIndex() {
    if (!mounted) return;
    final centerX = _scrollOffset + (_viewportWidth / 2) - widget.padding.left;
    var idx = (centerX / VideoSliderConstants.itemWidth).round();
    if (idx < 0) idx = 0;
    if (idx >= widget.videos.length) idx = widget.videos.length - 1;
    if (idx != _activeIndex) {
      setState(() => _activeIndex = idx);
    }
  }
}

/// Widget grille vidéos
class VideoGrid extends StatelessWidget {
  const VideoGrid({
    required this.videos,
    super.key,
    this.onVideoTap,
    this.scrollController,
    this.shrinkWrap = false,
  });

  final List<VideoPreview> videos;
  final void Function(VideoPreview)? onVideoTap;
  final ScrollController? scrollController;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount =
          constraints.maxWidth > VideoGridConstants.responsiveBreakpoint
          ? VideoGridConstants.desktopCrossAxisCount
          : VideoGridConstants.mobileCrossAxisCount;
      return GridView.builder(
        controller: scrollController,
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio:
              VideoCardConstants.defaultWidth /
              VideoCardConstants.defaultHeight,
          crossAxisSpacing: context.scaleXXS_XS_SM_MD,
          mainAxisSpacing: context.scaleXXS_XS_SM_MD,
        ),
        itemCount: videos.length,
        itemBuilder: (_, index) => VideoCard(
          video: videos[index],
          onTap: () => onVideoTap?.call(videos[index]),
        ),
      );
    },
  );
}
