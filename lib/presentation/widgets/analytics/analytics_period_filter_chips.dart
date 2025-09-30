import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre amélioré avec icône
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: DeepColorTokens.tertiaryContainer.withValues(
                  alpha: 0.8,
                ),
              ),
              child: Icon(
                Icons.calendar_view_day,
                size: 20.0,
                color: DeepColorTokens.tertiary,
              ),
            ),
            SizedBox(width: 12.0),
            Text(
              "Période d'analyse",
              style: TextStyle(
                fontSize: FontSizes.subtitleMedium.getSize(context),
                fontWeight: FontSizes.subtitleMedium.getFontWeight(),
                color: DeepColorTokens.neutral900,
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
                            ? DeepColorTokens.neutral0
                            : DeepColorTokens.neutral700,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        period.shortLabel,
                        style: TextStyle(
                          color: isSelected
                              ? DeepColorTokens.neutral0
                              : DeepColorTokens.neutral900,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(analyticsPeriodProvider.notifier).update(period);
                    }
                  },
                  selectedColor: _getPeriodColor(period),
                  backgroundColor: DeepColorTokens.neutral50.withValues(
                    alpha: 0.9,
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
            ).withValues(alpha: 0.1),
            border: Border.all(
              color: _getPeriodColor(
                selectedPeriod,
              ).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14.0,
                color: _getPeriodColor(selectedPeriod),
              ),
              SizedBox(width: 12.0),
              Text(
                _getPeriodDescription(selectedPeriod),
                style: TextStyle(
                  fontSize: FontSizes.bodySmall.getSize(context),
                  color: DeepColorTokens.neutral700,
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

  Color _getPeriodColor(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.day:
        return DeepColorTokens.success; // Vert forêt profond
      case AnalyticsPeriod.week:
        return DeepColorTokens.primary; // Bleu profond Nyth
      case AnalyticsPeriod.month:
        return DeepColorTokens.warning; // Orange brûlé profond
      case AnalyticsPeriod.year:
        return DeepColorTokens.secondary; // Violet profond Nyth
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
