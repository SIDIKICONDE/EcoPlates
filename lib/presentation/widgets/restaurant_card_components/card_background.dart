import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/services/image_cache_service.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../core/widgets/eco_cached_image.dart';
import 'category_helper.dart';

/// Widget pour l'image de fond avec placeholder et gradient overlay
class CardBackground extends StatelessWidget {
  const CardBackground({
    required this.category,
    required this.isDarkMode,
    super.key,
    this.imageUrl,
  });
  final String? imageUrl;
  final String category;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image de fond
        SizedBox.expand(
          child: imageUrl != null
              ? EcoCachedImage(
                  imageUrl: imageUrl!,
                  size: ImageSize.large,
                  placeholder: ColoredBox(
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Theme.of(context).colorScheme.surfaceContainerLowest,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: ResponsiveUtils.responsiveValue(
                          context,
                          mobile: 2.5,
                          tablet: 3.0,
                          desktop: 3.5,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: _buildFallback(context),
                )
              : _buildFallback(context),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                DeepColorTokens.overlayMedium,
                DeepColorTokens.overlayLight,
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                DeepColorTokens.overlayMedium,
              ],
              stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallback(BuildContext context) {
    final color = CategoryHelper.getCategoryColor(category);
    final icon = CategoryHelper.getCategoryIcon(category);

    // Tailles responsives
    final iconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 40.0,
      tablet: 48.0,
      desktop: 56.0,
    );
    final fontSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 14.0,
      tablet: 16.0,
      desktop: 18.0,
    );
    final spacing = ResponsiveUtils.getVerticalSpacing(context) * 0.33;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: DeepColorTokens.neutral0.withValues(alpha: 0.8),
            ),
            SizedBox(height: spacing),
            Text(
              category,
              style: TextStyle(
                color: DeepColorTokens.neutral0,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
