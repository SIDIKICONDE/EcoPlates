import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Écran d'historique des commandes de l'utilisateur
class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mon Historique'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'En cours', icon: Icon(Icons.pending)),
              Tab(text: 'Terminées', icon: Icon(Icons.check_circle)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_ActiveOrdersTab(), _CompletedOrdersTab()],
        ),
      ),
    );
  }
}

class _ActiveOrdersTab extends StatelessWidget {
  const _ActiveOrdersTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Remplacer par les vraies données depuis le provider
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune commande en cours',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Découvrez nos offres anti-gaspi !',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _CompletedOrdersTab extends StatelessWidget {
  const _CompletedOrdersTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _OrderHistoryCard(
          orderId: 'CMD-${2000 + index}',
          merchantName: 'Boulangerie Dupont',
          orderedAt: DateTime.now().subtract(Duration(days: index + 1)),
          collectedAt: DateTime.now().subtract(Duration(days: index)),
          ecoPoints: 10,
        );
      },
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  final String orderId;
  final String merchantName;
  final DateTime orderedAt;
  final DateTime collectedAt;
  final int ecoPoints;

  const _OrderHistoryCard({
    required this.orderId,
    required this.merchantName,
    required this.orderedAt,
    required this.collectedAt,
    required this.ecoPoints,
  });

  @override
  Widget build(BuildContext context) {
    final duration = collectedAt.difference(orderedAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(orderId, style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: [
                    Icon(Icons.eco, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      '+$ecoPoints pts',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              merchantName,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '${orderedAt.day}/${orderedAt.month}/${orderedAt.year}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.timer, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Récupérée en ${duration.inHours}h ${duration.inMinutes % 60}min',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
