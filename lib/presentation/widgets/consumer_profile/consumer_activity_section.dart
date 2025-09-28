import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/color_tokens.dart';
import '../../../core/themes/tokens/spacing_tokens.dart';

/// Section d'activité récente du consommateur
class ConsumerActivitySection extends StatelessWidget {
  const ConsumerActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    // TODO: Récupérer les données d'activité depuis un provider
    final activities = _getMockActivities();

    return Container(
      padding: EdgeInsets.all(
        context.responsiveValue(
          mobile: EcoSpacing.md,
          tablet: EcoSpacing.lg,
          desktop: EcoSpacing.xl,
        ),
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            mobile: EcoPlatesDesignTokens.radius.md,
            tablet: EcoPlatesDesignTokens.radius.lg,
            desktop: EcoPlatesDesignTokens.radius.xl,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec action
          Row(
            children: [
              Icon(
                Icons.history,
                color: colors.primary,
                size: context.responsiveValue(
                  mobile: context.scaleIconStandard,
                  tablet:
                      context.scaleIconStandard * 1.2, // 20% larger on tablet
                  desktop:
                      context.scaleIconStandard * 1.4, // 40% larger on desktop
                ),
              ),
              SizedBox(
                width: context.responsiveValue(
                  mobile: EcoSpacing.xs,
                  tablet: EcoSpacing.sm,
                  desktop: EcoSpacing.md,
                ),
              ),
              Text(
                'Activité Récente',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showFullHistory(context),
                child: const Text('Voir tout'),
              ),
            ],
          ),

          SizedBox(
            height: context.responsiveValue(
              mobile: EcoSpacing.md,
              tablet: EcoSpacing.lg,
              desktop: EcoSpacing.xl,
            ),
          ),

          // Liste des activités
          if (activities.isEmpty)
            _buildEmptyState(context)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length > DesignConstants.five.toInt()
                  ? DesignConstants.five.toInt()
                  : activities.length,
              separatorBuilder: (context, index) => SizedBox(
                height: context.responsiveValue(
                  mobile: EcoSpacing.sm,
                  tablet: EcoSpacing.md,
                  desktop: EcoSpacing.lg,
                ),
              ),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityTile(context, activity);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(BuildContext context, ActivityItem activity) {
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
        color: activity.color.withValues(
          alpha: EcoPlatesDesignTokens.opacity.verySubtle,
        ),
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            mobile: EcoPlatesDesignTokens.radius.sm,
            tablet: EcoPlatesDesignTokens.radius.md,
            desktop: EcoPlatesDesignTokens.radius.lg,
          ),
        ),
        border: Border.all(
          color: activity.color.withValues(
            alpha: EcoPlatesDesignTokens.opacity.verySubtle,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icône d'activité
          Container(
            padding: EdgeInsets.all(
              context.responsiveValue(
                mobile: EcoSpacing.xs,
                tablet: EcoSpacing.sm,
                desktop: EcoSpacing.md,
              ),
            ),
            decoration: BoxDecoration(
              color: activity.color.withValues(
                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
              ),
              borderRadius: BorderRadius.circular(
                context.responsiveValue(
                  mobile: EcoPlatesDesignTokens.radius.xs,
                  tablet: EcoPlatesDesignTokens.radius.sm,
                  desktop: EcoPlatesDesignTokens.radius.md,
                ),
              ),
            ),
            child: Icon(
              activity.icon,
              color: activity.color,
              size: context.responsiveValue(
                mobile:
                    context.scaleIconStandard * 0.9, // 10% smaller on mobile
                tablet: context.scaleIconStandard,
                desktop:
                    context.scaleIconStandard * 1.1, // 10% larger on desktop
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

          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: textTheme.bodyLarge?.copyWith(
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
                  activity.subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Timestamp et badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity.timeAgo,
                style: textTheme.labelSmall?.copyWith(
                  color: colors.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.disabled,
                  ),
                ),
              ),
              if (activity.badge != null) ...[
                SizedBox(
                  height: context.responsiveValue(
                    mobile: DesignConstants.two,
                    tablet: DesignConstants.four,
                    desktop: DesignConstants.six,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveValue(
                      mobile: EcoSpacing.xs,
                      tablet: EcoSpacing.sm,
                      desktop: EcoSpacing.md,
                    ),
                    vertical: context.responsiveValue(
                      mobile: DesignConstants.one,
                      tablet: DesignConstants.two,
                      desktop: DesignConstants.three,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: activity.color,
                    borderRadius: BorderRadius.circular(
                      context.responsiveValue(
                        mobile: EcoPlatesDesignTokens.radius.sm,
                        tablet: EcoPlatesDesignTokens.radius.md,
                        desktop: EcoPlatesDesignTokens.radius.lg,
                      ),
                    ),
                  ),
                  child: Text(
                    activity.badge!,
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(
        context.responsiveValue(
          mobile: EcoSpacing.xxl,
          tablet: EcoSpacing.xxxl,
          desktop: EcoSpacing.huge,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.eco_outlined,
            size: context.responsiveValue(
              mobile: EcoPlatesDesignTokens.size.minTouchTarget,
              tablet:
                  EcoPlatesDesignTokens.size.minTouchTarget *
                  1.17, // ~17% larger on tablet
              desktop:
                  EcoPlatesDesignTokens.size.minTouchTarget *
                  1.33, // ~33% larger on desktop
            ),
            color: colors.onSurface.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: EcoSpacing.md,
              tablet: EcoSpacing.lg,
              desktop: EcoSpacing.xl,
            ),
          ),
          Text(
            'Aucune activité pour le moment',
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
            ),
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: EcoSpacing.xs,
              tablet: EcoSpacing.sm,
              desktop: EcoSpacing.md,
            ),
          ),
          Text(
            'Commencez à utiliser EcoPlates pour voir votre impact ici !',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.disabled,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFullHistory(BuildContext context) {
    // TODO: Naviguer vers la page d'historique complet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Historique complet à implémenter'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<ActivityItem> _getMockActivities() {
    // TODO: Remplacer par de vraies données
    return [
      ActivityItem(
        title: 'Commande récupérée',
        subtitle: 'Chez Le Petit Bistrot - Salade César',
        timeAgo: 'Il y a 2h',
        icon: Icons.check_circle,
        color: EcoColorTokens.success,
        badge: '+10 pts',
      ),
      ActivityItem(
        title: 'Nouvelle réservation',
        subtitle: 'Pizza Margherita - Livraison prévue à 18h30',
        timeAgo: 'Hier',
        icon: Icons.dinner_dining,
        color: EcoColorTokens.info,
      ),
      ActivityItem(
        title: 'Niveau Bronze atteint !',
        subtitle: 'Félicitations pour vos premiers pas écologiques',
        timeAgo: 'Il y a 3 jours',
        icon: Icons.military_tech,
        color: const Color(0xFFCD7F32),
        badge: 'Nouveau',
      ),
      ActivityItem(
        title: 'Premier impact écologique',
        subtitle: '0.8 kg de CO₂ économisés',
        timeAgo: 'Il y a 5 jours',
        icon: Icons.eco,
        color: EcoColorTokens.success,
        badge: '🌱',
      ),
      ActivityItem(
        title: 'Compte créé',
        subtitle: 'Bienvenue dans la communauté EcoPlates !',
        timeAgo: 'Il y a 1 semaine',
        icon: Icons.account_circle,
        color: EcoColorTokens.warning,
      ),
    ];
  }
}

class ActivityItem {
  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.icon,
    required this.color,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final String? badge;
}
