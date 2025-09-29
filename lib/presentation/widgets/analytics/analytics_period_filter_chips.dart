import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(
                  alpha: 0.1,
                ),
              ),
              child: Icon(
                Icons.calendar_view_day,
                size: 20.0,
                color: theme.colorScheme.tertiary,
              ),
            ),
            SizedBox(width: 12.0),
            Text(
              "Période d'analyse",
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),

        SizedBox(height: 16.0),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AnalyticsPeriod.values.map((period) {
              final isSelected = period == selectedPeriod;

              return Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPeriodIcon(period),
                        size: 16.0 * 0.875,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4.0),
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
                    alpha: 0.1,
                  ),
                  showCheckmark: false,
                  pressElevation: 16.0,
                  elevation: isSelected ? 8.0 : 0.0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  padding: EdgeInsets.all(16.0),
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 4.0),

        // Sous-titre avec description de la période sélectionnée
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            color: _getPeriodColor(
              selectedPeriod,
              theme,
            ).withValues(alpha: 0.1),
            border: Border.all(
              color: _getPeriodColor(
                selectedPeriod,
                theme,
              ).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14.0,
                color: _getPeriodColor(selectedPeriod, theme),
              ),
              SizedBox(width: 12.0),
              Text(
                _getPeriodDescription(selectedPeriod),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: 0.8,
                  ),
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
