import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';

/// Widget pour afficher un tag avec icône
class RestaurantTag extends StatelessWidget {
  const RestaurantTag({required this.tag, super.key});
  final String tag;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getTagStyle(tag);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXXS_XS_SM_MD,
        vertical: context.scaleXXS_XS_SM_MD / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: EcoPlatesDesignTokens.opacity.subtle),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
        border: Border.all(
          color: color.withValues(
            alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: EcoPlatesDesignTokens.size.indicator(context),
            color: EcoPlatesDesignTokens.colors.textPrimary,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
          Text(
            tag,
            style: TextStyle(
              color: EcoPlatesDesignTokens.colors.textPrimary,
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
              fontWeight: EcoPlatesDesignTokens.typography.bold,
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _getTagStyle(String tag) {
    switch (tag.toLowerCase()) {
      case 'végétarien':
      case 'vegan':
      case 'végé':
        return (Icons.eco, Colors.green);
      case 'bio':
        return (Icons.grass, Colors.lightGreen);
      case 'halal':
        return (Icons.verified, Colors.teal);
      case 'sans gluten':
        return (Icons.grain_outlined, Colors.orange);
      default:
        return (Icons.label, Colors.blue);
    }
  }
}
