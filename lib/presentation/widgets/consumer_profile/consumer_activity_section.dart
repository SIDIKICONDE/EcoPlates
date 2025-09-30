import 'package:flutter/material.dart';

import '../../../core/themes/tokens/color_tokens.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Section d'activité récente du consommateur
class ConsumerActivitySection extends StatelessWidget {
  const ConsumerActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // TODO: Récupérer les données d'activité depuis un provider
    final activities = _getMockActivities();

    return Container(
      padding: EdgeInsets.all(
        16.0,
      ),
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.neutral0.withValues(
              alpha: 0.08,
            ),
            blurRadius: 8.0,
            offset: Offset(0, 4),
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
                color: DeepColorTokens.primary,
                size: 24.0,
              ),
              SizedBox(
                width: 8.0,
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
            height: 16.0,
          ),

          // Liste des activités
          if (activities.isEmpty)
            _buildEmptyState(context)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length > 5 ? 5 : activities.length,
              separatorBuilder: (context, index) => SizedBox(
                height: 12.0,
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
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(
        16.0,
      ),
      decoration: BoxDecoration(
        color: activity.color.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: activity.color.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icône d'activité
          Container(
            padding: EdgeInsets.all(
              8.0,
            ),
            decoration: BoxDecoration(
              color: activity.color.withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Icon(
              activity.icon,
              color: activity.color,
              size: 24.0,
            ),
          ),

          SizedBox(
            width: 12.0,
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
                  height: 2.0,
                ),
                Text(
                  activity.subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: DeepColorTokens.neutral0.withValues(
                      alpha: 0.87,
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
                  color: DeepColorTokens.neutral0.withValues(
                    alpha: 0.38,
                  ),
                ),
              ),
              if (activity.badge != null) ...[
                SizedBox(
                  height: 4.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: activity.color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    activity.badge!,
                    style: textTheme.labelSmall?.copyWith(
                      color: DeepColorTokens.neutral0,
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
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.eco_outlined,
            size: 48.0,
            color: DeepColorTokens.neutral0.withValues(
              alpha: 0.38,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'Aucune activité pour le moment',
            style: textTheme.titleMedium?.copyWith(
              color: DeepColorTokens.neutral0.withValues(
                alpha: 0.87,
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Commencez à utiliser EcoPlates pour voir votre impact ici !',
            style: textTheme.bodySmall?.copyWith(
              color: DeepColorTokens.neutral0.withValues(
                alpha: 0.38,
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
