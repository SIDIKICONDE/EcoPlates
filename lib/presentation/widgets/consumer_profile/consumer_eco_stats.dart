import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/color_tokens.dart';
import '../../../core/themes/tokens/spacing_tokens.dart';
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EcoColorTokens.success.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            EcoColorTokens.eco.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle / 2,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            mobile: EcoPlatesDesignTokens.radius.md,
            tablet: EcoPlatesDesignTokens.radius.lg,
            desktop: EcoPlatesDesignTokens.radius.xl,
          ),
        ),
        border: Border.all(
          color: EcoColorTokens.success.withValues(
            alpha: EcoPlatesDesignTokens.opacity.verySubtle,
          ),
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
                  padding: EdgeInsets.all(
                    context.responsiveValue(
                      mobile: EcoSpacing.xs,
                      tablet: EcoSpacing.sm,
                      desktop: EcoSpacing.md,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: EcoColorTokens.success,
                    borderRadius: BorderRadius.circular(
                      context.responsiveValue(
                        mobile: EcoPlatesDesignTokens.radius.xs,
                        tablet: EcoPlatesDesignTokens.radius.sm,
                        desktop: EcoPlatesDesignTokens.radius.md,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: colors.onPrimary,
                    size: context.responsiveValue(
                      mobile:
                          context.scaleIconStandard *
                          0.9, // 10% smaller on mobile
                      tablet: context.scaleIconStandard,
                      desktop:
                          context.scaleIconStandard *
                          1.1, // 10% larger on desktop
                    ),
                  ),
                ),
                SizedBox(
                  width: context.responsiveValue(
                    mobile: EcoSpacing.sm,
                    tablet: EcoSpacing.md,
                    desktop: EcoSpacing.lg,
                  ),
                ),
                Text(
                  'Impact Écologique',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: EcoColorTokens.success,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: context.responsiveValue(
                mobile: EcoSpacing.lg,
                tablet: EcoSpacing.xl,
                desktop: EcoSpacing.xxl,
              ),
            ),

            // Grille de statistiques
            GridView.count(
              crossAxisCount: context.responsiveValue(
                mobile: DesignConstants.two.toInt(), // 2 colonnes sur mobile
                tablet: DesignConstants.two.toInt(),
                desktop: DesignConstants.four.toInt(),
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: context.responsiveValue(
                mobile: 1.5, // Ratio plus allongé sur mobile
                tablet: 1.2,
                desktop: 1,
              ),
              mainAxisSpacing: context.responsiveValue(
                mobile: EcoSpacing.sm,
                tablet: EcoSpacing.md,
                desktop: EcoSpacing.lg,
              ),
              crossAxisSpacing: context.responsiveValue(
                mobile: EcoSpacing.sm,
                tablet: EcoSpacing.md,
                desktop: EcoSpacing.lg,
              ),
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
                  color: colors.primary,
                  subtitle: 'Depuis le début',
                ),
                EcoStatCard(
                  title: 'Déchets Évités',
                  value: EcoCalculations.calculateWasteAvoided(
                    consumerProfile?.totalPlatesUsed ?? 0,
                  ),
                  unit: 'g',
                  icon: Icons.recycling,
                  color: EcoColorTokens.warning,
                  subtitle: 'Plastique économisé',
                ),
              ],
            ),

            SizedBox(
              height: context.responsiveValue(
                mobile: EcoSpacing.lg,
                tablet: EcoSpacing.xl,
                desktop: EcoSpacing.xxl,
              ),
            ),

            // Progression vers le prochain niveau
            TierProgressWidget(
              currentTier: consumerProfile?.tier ?? ConsumerTier.bronze,
              currentScore: consumerProfile?.ecoScore ?? 0,
            ),

            SizedBox(
              height: context.responsiveValue(
                mobile: EcoSpacing.md,
                tablet: EcoSpacing.lg,
                desktop: EcoSpacing.xl,
              ),
            ),

            // Message motivationnel
            Container(
              padding: EdgeInsets.all(
                context.responsiveValue(
                  mobile: EcoSpacing.md,
                  tablet: EcoSpacing.lg,
                  desktop: EcoSpacing.xl,
                ),
              ),
              decoration: BoxDecoration(
                color: colors.surface.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
                ),
                borderRadius: BorderRadius.circular(
                  context.responsiveValue(
                    mobile: EcoPlatesDesignTokens.radius.sm,
                    tablet: EcoPlatesDesignTokens.radius.md,
                    desktop: EcoPlatesDesignTokens.radius.lg,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: EcoColorTokens.warning,
                    size: context.responsiveValue(
                      mobile: context.scaleIconStandard,
                      tablet:
                          context.scaleIconStandard *
                          1.2, // 20% larger on tablet
                      desktop:
                          context.scaleIconStandard *
                          1.4, // 40% larger on desktop
                    ),
                  ),
                  SizedBox(
                    width: context.responsiveValue(
                      mobile: EcoSpacing.sm,
                      tablet: EcoSpacing.md,
                      desktop: EcoSpacing.lg,
                    ),
                  ),
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
                          height: context.responsiveValue(
                            mobile: DesignConstants.two,
                            tablet: DesignConstants.four,
                            desktop: DesignConstants.six,
                          ),
                        ),
                        Text(
                          EcoCalculations.getEcoTip(
                            consumerProfile?.totalPlatesUsed ?? 0,
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(
                              alpha:
                                  EcoPlatesDesignTokens.opacity.gradientPrimary,
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
