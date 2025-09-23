import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'category_helper.dart';

/// Widget pour l'image de fond avec placeholder et gradient overlay
class CardBackground extends StatelessWidget {
  final String? imageUrl;
  final String category;
  final bool isDarkMode;
  
  const CardBackground({
    super.key,
    this.imageUrl,
    required this.category,
    required this.isDarkMode,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image de fond
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => _buildFallback(),
                )
              : _buildFallback(),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.65),
                Colors.black.withValues(alpha: 0.25),
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
              stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFallback() {
    final color = CategoryHelper.getCategoryColor(category);
    final icon = CategoryHelper.getCategoryIcon(category);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        icon,
        size: 60,
        color: Colors.white.withValues(alpha: 0.3),
      ),
    );
  }
}