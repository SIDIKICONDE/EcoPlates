import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Badge pour indiquer qu'un restaurant est populaire
class PopularityBadge extends StatelessWidget {
  const PopularityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding =
        ResponsiveUtils.getHorizontalSpacing(context) * 0.5;
    final verticalPadding = ResponsiveUtils.getVerticalSpacing(context) * 0.25;
    final iconSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );
    final fontSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: 10.0,
      tablet: 11.0,
      desktop: 12.0,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.warning,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context) * 0.75,
        ),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.shadowLight,
            blurRadius: 4.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            size: iconSize,
            color: DeepColorTokens.neutral0,
          ),
          SizedBox(width: horizontalPadding * 0.33),
          Text(
            'POPULAIRE',
            style: TextStyle(
              color: DeepColorTokens.neutral0,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
