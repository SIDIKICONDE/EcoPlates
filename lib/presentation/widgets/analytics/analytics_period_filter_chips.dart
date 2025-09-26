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
        Text(
          "Période d'analyse",
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AnalyticsPeriod.values.map((period) {
              final isSelected = period == selectedPeriod;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(period.shortLabel),
                  selected: isSelected,
                  onSelected: (selected) {
                  if (selected) {
                      ref.read(analyticsPeriodProvider.notifier).update(period);
                    }
                  },
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surface,
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 1,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  showCheckmark: false,
                  pressElevation: 2,
                  elevation: isSelected ? 4 : 0,
                  shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 4),

        // Sous-titre avec description de la période sélectionnée
        Text(
          _getPeriodDescription(selectedPeriod),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
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
