import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget pour afficher un tag avec icône
class RestaurantTag extends StatelessWidget {
  const RestaurantTag({required this.tag, super.key});
  final String tag;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getTagStyle(tag);

    final horizontalPadding =
        ResponsiveUtils.getHorizontalSpacing(context) * 0.33;
    final verticalPadding = ResponsiveUtils.getVerticalSpacing(context) * 0.17;
    final iconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 10.0,
      tablet: 12.0,
      desktop: 14.0,
    );
    final fontSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 10.0,
      tablet: 11.0,
      desktop: 12.0,
    );
    final spacing = ResponsiveUtils.getHorizontalSpacing(context) * 0.17;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        border: Border.all(
          color: color.withValues(alpha: 0.16),
        ),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context) * 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: color,
          ),
          SizedBox(width: spacing),
          Text(
            tag,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
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
        return (Icons.eco, DeepColorTokens.success);
      case 'bio':
        return (Icons.grass, DeepColorTokens.success);
      case 'halal':
        return (Icons.verified, DeepColorTokens.info);
      case 'sans gluten':
        return (Icons.grain_outlined, DeepColorTokens.warning);
      default:
        return (Icons.label, DeepColorTokens.primary);
    }
  }
}
