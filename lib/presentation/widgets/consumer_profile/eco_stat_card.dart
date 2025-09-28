import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/spacing_tokens.dart';

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
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(
        context.responsiveValue(
          mobile: EcoSpacing.md,
          tablet: EcoSpacing.lg,
          desktop: EcoSpacing.xl,
        ),
      ),
      decoration: BoxDecoration(
        color: colors.surface.withValues(
          alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
        ),
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            mobile: EcoPlatesDesignTokens.radius.sm,
            tablet: EcoPlatesDesignTokens.radius.md,
            desktop: EcoPlatesDesignTokens.radius.lg,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            blurRadius: DesignConstants.four,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
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
                size: context.responsiveValue(
                  mobile: context.scaleIconStandard * 0.9,
                  tablet: context.scaleIconStandard,
                  desktop: context.scaleIconStandard * 1.1,
                ),
              ),
              const Spacer(),
              Container(
                width: DesignConstants.four,
                height: DesignConstants.four,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: 8,
              tablet: 12,
              desktop: 16,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: DesignConstants.two,
              tablet: DesignConstants.four,
              desktop: DesignConstants.six,
            ),
          ),
          Text(
            title,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: DesignConstants.one,
              tablet: DesignConstants.two,
              desktop: DesignConstants.three,
            ),
          ),
          Text(
            subtitle,
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
