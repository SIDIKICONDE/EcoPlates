import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/tokens/color_tokens.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/user.dart';
import '../../providers/consumer_profile_provider.dart';
import 'eco_calculations.dart';
import 'eco_stat_card.dart';
import 'tier_progress_widget.dart';

/// Widget affichant les statistiques écologiques détaillées du consommateur
class ConsumerEcoStats extends ConsumerWidget {
  const ConsumerEcoStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumerProfile = ref.watch(consumerEcoStatsProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EcoColorTokens.success.withValues(
              alpha: 0.1,
            ),
            DeepColorTokens.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de section
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: EcoColorTokens.success,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: DeepColorTokens.neutral0,
                    size: 16.0,
                  ),
                ),
                SizedBox(width: 12.0),
                Text(
                  'Impact Écologique',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: EcoColorTokens.success,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.0),

            // Grille de statistiques
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 768 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: MediaQuery.of(context).size.width > 768
                  ? 1.0
                  : 1.5,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              children: [
                EcoStatCard(
                  title: 'EcoScore Total',
                  value: '${consumerProfile?.ecoScore ?? 0}',
                  unit: 'pts',
                  icon: Icons.trending_up,
                  color: EcoColorTokens.success,
                  subtitle: 'Votre contribution écologique',
                ),
                EcoStatCard(
                  title: 'CO₂ Économisé',
                  value: (consumerProfile?.co2Saved ?? 0).toStringAsFixed(1),
                  unit: 'kg',
                  icon: Icons.air,
                  color: EcoColorTokens.info,
                  subtitle:
                      'Équivaut à ${EcoCalculations.calculateTreesEquivalent(consumerProfile?.co2Saved ?? 0)} arbres',
                ),
                EcoStatCard(
                  title: 'Assiettes Utilisées',
                  value: '${consumerProfile?.totalPlatesUsed ?? 0}',
                  unit: 'total',
                  icon: Icons.dinner_dining,
                  color: DeepColorTokens.primary,
                  subtitle: 'Depuis le début',
                ),
                EcoStatCard(
                  title: 'Déchets Évités',
                  value: EcoCalculations.calculateWasteAvoided(
                    consumerProfile?.totalPlatesUsed ?? 0,
                  ),
                  unit: 'g',
                  icon: Icons.recycling,
                  color: EcoColorTokens
                      .warning, // Orange brûlé pour attirer l'attention sur l'impact environnemental
                  subtitle: 'Plastique économisé',
                ),
              ],
            ),

            SizedBox(height: 20.0),

            // Progression vers le prochain niveau
            TierProgressWidget(
              currentTier: consumerProfile?.tier ?? ConsumerTier.bronze,
              currentScore: consumerProfile?.ecoScore ?? 0,
            ),

            SizedBox(height: 16.0),

            // Message motivationnel
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: DeepColorTokens.surface.withValues(
                  alpha: 0.1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: EcoColorTokens.warning,
                    size: MediaQuery.of(context).size.width > 768 ? 28.0 : 20.0,
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Conseil Éco',
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: EcoColorTokens.warning,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width > 768
                              ? 6.0
                              : 2.0,
                        ),
                        Text(
                          EcoCalculations.getEcoTip(
                            consumerProfile?.totalPlatesUsed ?? 0,
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: DeepColorTokens.neutral700.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
