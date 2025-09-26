import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/adaptive_widgets.dart';
import '../../providers/sales_provider.dart';

/// Barre d'app bar pour la page de gestion des ventes
class SalesAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SalesAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(salesStatsProvider);
    final todayCount = (stats['todayCount'] as int?) ?? 0;
    final todayRevenue = (stats['todayRevenue'] as double?) ?? 0.0;

    return AdaptiveAppBar(
      leading: const _MerchantLogo(),
      title: const Text('Ventes'),
      actions: [
        // Badge du nombre de ventes du jour
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '$todayCount',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        // CA du jour
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.euro,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${todayRevenue.toStringAsFixed(0)}€',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),

        // Menu d'actions
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          iconSize: 20,
          tooltip: 'Actions',
          onSelected: (value) => _handleMenuAction(context, ref, value),
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download, size: 18),
                  title: Text('Exporter', style: TextStyle(fontSize: 14)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: ListTile(
                  leading: Icon(Icons.refresh, size: 18),
                  title: Text('Actualiser', style: TextStyle(fontSize: 14)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  dense: true,
                ),
              ),
            ];
          },
        ),

        const SizedBox(width: 4),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'export':
        // TODO: Implémenter l'export des ventes
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export des ventes en cours...')),
        );
      case 'refresh':
        ref.read(salesProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Actualisation en cours...')),
        );
    }
  }
}

/// Logo du marchand dans la barre d'app bar
class _MerchantLogo extends StatelessWidget {
  const _MerchantLogo();

  @override
  Widget build(BuildContext context) {
    const merchantLogoUrl =
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop&crop=center';

    return Container(
      margin: const EdgeInsets.all(8),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundImage: const NetworkImage(merchantLogoUrl),
        onBackgroundImageError: (_, __) {
          // Fallback vers une icône si l'image ne charge pas
        },
        child: const Icon(Icons.store, size: 20, color: Colors.grey),
      ),
    );
  }
}
