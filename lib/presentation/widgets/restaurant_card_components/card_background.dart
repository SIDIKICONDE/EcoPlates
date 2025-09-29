import 'package:flutter/material.dart';

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
                        strokeWidth: 3.0,
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
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.2),
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.4),
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8.0),
            Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
