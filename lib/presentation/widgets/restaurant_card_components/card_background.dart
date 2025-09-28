import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/services/image_cache_service.dart';
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
                        strokeWidth: EcoPlatesDesignTokens
                            .layout
                            .loadingIndicatorStrokeWidth,
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
              colors: [
                EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
              ],
              stops: EcoPlatesDesignTokens.layout.analyticsGradientStops,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallback(BuildContext context) {
    final color = CategoryHelper.getCategoryColor(category);
    final icon = CategoryHelper.getCategoryIcon(category);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withValues(alpha: EcoPlatesDesignTokens.opacity.almostOpaque),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        icon,
        size: EcoPlatesDesignTokens.size.modalIcon(context),
        color: Colors.white.withValues(
          alpha: EcoPlatesDesignTokens.opacity.subtle,
        ),
      ),
    );
  }
}
