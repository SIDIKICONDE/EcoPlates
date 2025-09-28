import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/analytics_stats.dart';
import '../../providers/analytics_provider.dart';

/// Widget pour la sélection de la période d'analyse
///
/// Affiche une rangée de ChoiceChip permettant de filtrer les données
/// par période : 24h, 7j, 30j, 1an
class AnalyticsPeriodFilterChips extends ConsumerWidget {
  const AnalyticsPeriodFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(analyticsPeriodProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre amélioré avec icône
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.sm,
                ),
              ),
              child: Icon(
                Icons.calendar_view_day,
                size: context.scaleIconStandard,
                color: theme.colorScheme.tertiary,
              ),
            ),
            SizedBox(width: context.scaleSM_MD_LG_XL),
            Text(
              "Période d'analyse",
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: DesignConstants.zeroPointFive / 2.5,
              ),
            ),
          ],
        ),

        SizedBox(height: context.scaleMD_LG_XL_XXL),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AnalyticsPeriod.values.map((period) {
              final isSelected = period == selectedPeriod;

              return Padding(
                padding: EdgeInsets.only(right: context.scaleMD_LG_XL_XXL),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPeriodIcon(period),
                        size: EcoPlatesDesignTokens.size.icon(context) * 0.875,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: context.scaleXXS_XS_SM_MD),
                      Text(period.shortLabel),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(analyticsPeriodProvider.notifier).update(period);
                    }
                  },
                  selectedColor: _getPeriodColor(period, theme),
                  backgroundColor: theme.colorScheme.surface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? _getPeriodColor(period, theme)
                        : theme.colorScheme.outline.withValues(
                            alpha: EcoPlatesDesignTokens.opacity.disabled,
                          ),
                    width: isSelected ? 2 : 1,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  ),
                  showCheckmark: false,
                  pressElevation: EcoPlatesDesignTokens.elevation.button(
                    context,
                  ),
                  elevation: isSelected
                      ? EcoPlatesDesignTokens.elevation.card
                      : 0,
                  shadowColor: isSelected
                      ? _getPeriodColor(period, theme).withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        )
                      : theme.colorScheme.shadow.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                        ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  padding: EcoPlatesDesignTokens.spacing.contentPadding(
                    context,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: context.scaleXXS_XS_SM_MD),

        // Sous-titre avec description de la période sélectionnée
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleMD_LG_XL_XXL,
            vertical: context.scaleXXS_XS_SM_MD,
          ),
          decoration: BoxDecoration(
            color: _getPeriodColor(
              selectedPeriod,
              theme,
            ).withValues(alpha: EcoPlatesDesignTokens.opacity.verySubtle),
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.md,
            ),
            border: Border.all(
              color: _getPeriodColor(
                selectedPeriod,
                theme,
              ).withValues(alpha: EcoPlatesDesignTokens.opacity.verySubtle),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getPeriodIcon(selectedPeriod),
                size: EcoPlatesDesignTokens.size.icon(context) * 0.875,
                color: _getPeriodColor(selectedPeriod, theme),
              ),
              SizedBox(width: context.scaleSM_MD_LG_XL),
              Text(
                _getPeriodDescription(selectedPeriod),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
                  ),
                  fontSize:
                      EcoPlatesDesignTokens.typography.hint(context) * 0.916,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getPeriodIcon(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.day:
        return Icons.today;
      case AnalyticsPeriod.week:
        return Icons.calendar_view_week;
      case AnalyticsPeriod.month:
        return Icons.calendar_month;
      case AnalyticsPeriod.year:
        return Icons.calendar_today;
    }
  }

  Color _getPeriodColor(AnalyticsPeriod period, ThemeData theme) {
    switch (period) {
      case AnalyticsPeriod.day:
        return const Color(0xFF4CAF50); // Vert
      case AnalyticsPeriod.week:
        return const Color(0xFF2196F3); // Bleu
      case AnalyticsPeriod.month:
        return const Color(0xFFFF9800); // Orange
      case AnalyticsPeriod.year:
        return const Color(0xFF9C27B0); // Violet
    }
  }

  String _getPeriodDescription(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.day:
        return 'Données horaires des dernières 24 heures';
      case AnalyticsPeriod.week:
        return 'Données journalières des 7 derniers jours';
      case AnalyticsPeriod.month:
        return 'Données hebdomadaires des 30 derniers jours';
      case AnalyticsPeriod.year:
        return 'Données mensuelles de cette année';
    }
  }
}
