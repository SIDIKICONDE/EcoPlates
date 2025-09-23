import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/adaptive_widgets.dart';

/// Dashboard principal pour les commerçants
class MerchantDashboardScreen extends ConsumerWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Dashboard Commerçant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Afficher les notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistiques du jour
            Text(
              'Aujourd\'hui',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Commandes vendues',
                    value: '47',
                    icon: Icons.shopping_cart,
                    color: Colors.blue,
                    trend: '+12%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Commandes récupérées',
                    value: '38',
                    icon: Icons.check,
                    color: Colors.green,
                    trend: '+5%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'En circulation',
                    value: '156',
                    icon: Icons.sync,
                    color: Colors.orange,
                    trend: null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Disponibles',
                    value: '234',
                    icon: Icons.check_circle,
                    color: Colors.purple,
                    trend: null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Actions rapides
            Text(
              'Actions rapides',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _ActionCard(
                  icon: Icons.qr_code_scanner,
                  title: 'Scanner retour',
                  subtitle: 'Enregistrer un retour',
                  color: Colors.blue,
                  onTap: () {
                    context.go('/merchant/scan-return');
                  },
                ),
                _ActionCard(
                  icon: Icons.inventory,
                  title: 'Inventaire',
                  subtitle: 'Gérer les stocks',
                  color: Colors.green,
                  onTap: () {
                    context.go('/merchant/inventory');
                  },
                ),
                _ActionCard(
                  icon: Icons.bar_chart,
                  title: 'Statistiques',
                  subtitle: 'Voir les rapports',
                  color: Colors.orange,
                  onTap: () {
                    context.go('/merchant/stats');
                  },
                ),
                _ActionCard(
                  icon: Icons.group,
                  title: 'Équipe',
                  subtitle: 'Gérer le personnel',
                  color: Colors.purple,
                  onTap: () {
                    context.go('/merchant/team');
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Alertes
            Text(
              'Alertes',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _AlertCard(
              type: AlertType.warning,
              title: 'Stock faible',
              message: 'Pensez à renouveler vos offres anti-gaspi',
              onAction: () {
                // TODO: Créer nouvelles offres
              },
            ),
            const SizedBox(height: 12),
            _AlertCard(
              type: AlertType.info,
              title: 'Nouvelle fonctionnalité',
              message: 'Découvrez le nouveau système de rapports automatiques',
              onAction: () {
                // TODO: Afficher les nouveautés
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher une statistique
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: trend!.startsWith('+') ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trend!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// Widget pour les actions rapides
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Types d'alertes
enum AlertType { info, warning, error }

/// Widget pour afficher une alerte
class _AlertCard extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final VoidCallback? onAction;

  const _AlertCard({
    required this.type,
    required this.title,
    required this.message,
    this.onAction,
  });

  Color get _color {
    switch (type) {
      case AlertType.info:
        return Colors.blue;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.error:
        return Colors.red;
    }
  }

  IconData get _icon {
    switch (type) {
      case AlertType.info:
        return Icons.info_outline;
      case AlertType.warning:
        return Icons.warning_amber;
      case AlertType.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: _color.withAlpha(50)),
        borderRadius: BorderRadius.circular(12),
        color: _color.withAlpha(10),
      ),
      child: Row(
        children: [
          Icon(_icon, color: _color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (onAction != null)
            IconButton(
              onPressed: onAction,
              icon: const Icon(Icons.arrow_forward),
              color: _color,
            ),
        ],
      ),
    );
  }
}
