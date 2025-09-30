import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget représentant une carte de statistique écologique
class EcoStatCard extends StatelessWidget {
  const EcoStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.surfaceElevated.withValues(
          alpha: 0.8,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: 0.01,
            ),
            blurRadius: 4.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 21.6,
              ),
              const Spacer(),
              Container(
                width: 4.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: DeepColorTokens.neutral900,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: textTheme.bodySmall?.copyWith(
                    color: DeepColorTokens.neutral700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            title,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 1.0,
          ),
          Text(
            subtitle,
            style: textTheme.labelSmall?.copyWith(
              color: DeepColorTokens.neutral700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
