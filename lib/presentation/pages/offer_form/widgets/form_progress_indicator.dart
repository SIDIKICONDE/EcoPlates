import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';

/// Indicateur de progression du formulaire
class FormProgressIndicator extends StatelessWidget {
  const FormProgressIndicator({
    required this.progress,
    required this.steps,
    super.key,
  });

  final double progress;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
      margin: EdgeInsets.only(
        bottom: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(
          alpha: EcoPlatesDesignTokens.opacity.hover,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: EcoPlatesDesignTokens.opacity.subtle,
          ),
        ),
      ),
      child: Column(
        children: [
          // Barre de progression
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(
                width: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                  fontSize: EcoPlatesDesignTokens.typography.text(context),
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.smallGap(context)),
          // Étapes
          Row(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = index < (progress * steps.length);
              final isCurrent = index == (progress * steps.length).floor();

              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: EcoPlatesDesignTokens.spacing.microGap(context),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: EcoPlatesDesignTokens.size.indicator(context),
                        height: EcoPlatesDesignTokens.size.indicator(context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? colorScheme.primary
                              : isCurrent
                              ? colorScheme.primary.withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .opacity
                                      .semiTransparent,
                                )
                              : colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      SizedBox(
                        height: EcoPlatesDesignTokens.spacing.microGap(context),
                      ),
                      Text(
                        step,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
                          color: isCompleted || isCurrent
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isCurrent
                              ? EcoPlatesDesignTokens.typography.semiBold
                              : EcoPlatesDesignTokens.typography.regular,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
