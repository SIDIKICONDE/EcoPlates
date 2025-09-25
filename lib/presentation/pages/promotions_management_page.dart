import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/promotion_service.dart';
import '../../core/widgets/adaptive_widgets.dart';
import '../providers/store_offers_provider.dart';
import '../widgets/store/global_promotion_dialog.dart';
import '../widgets/store/offer_promotion_manager.dart';

/// Page de gestion des promotions pour les marchands
class PromotionsManagementPage extends ConsumerWidget {
  const PromotionsManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final offersAsync = ref.watch(storeOffersProvider);
    final promotionStats = ref.watch(promotionStatsProvider);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Row(
          children: [
            Icon(Icons.local_offer, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Gestion des promotions'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nouvelle promotion globale',
            onPressed: () => _showGlobalPromotionDialog(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('Supprimer toutes les promotions'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: ListTile(
                  leading: Icon(Icons.analytics),
                  title: Text('Voir les statistiques'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: offersAsync.when(
        data: (offers) {
          final offersWithPromotions = offers
              .where((offer) => offer.discountPercentage > 0)
              .toList();
          final offersWithoutPromotions = offers
              .where((offer) => offer.discountPercentage == 0)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistiques rapides
                _buildPromotionStatsCard(context, promotionStats),
                const SizedBox(height: 24),

                // Promotions actives
                if (offersWithPromotions.isNotEmpty) ...[
                  Text(
                    'Promotions actives (${offersWithPromotions.length})',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...offersWithPromotions.map(
                    (offer) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: OfferPromotionManager(
                        offer: offer,
                        onPromotionUpdated: () =>
                            ref.invalidate(storeOffersProvider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Offres sans promotion
                Text(
                  'Ajouter une promotion (${offersWithoutPromotions.length})',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (offersWithoutPromotions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Toutes vos offres ont une promotion !',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...offersWithoutPromotions
                      .take(3)
                      .map(
                        (offer) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: OfferPromotionManager(
                            offer: offer,
                            onPromotionUpdated: () =>
                                ref.invalidate(storeOffersProvider),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Erreur lors du chargement des offres',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(storeOffersProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGlobalPromotionDialog(context),
        label: const Text('Promotion globale'),
        icon: const Icon(Icons.campaign),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildPromotionStatsCard(BuildContext context, PromotionStats stats) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'Statistiques des promotions',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.local_offer,
                  label: 'Actives',
                  value: stats.activePromotions.toString(),
                  color: theme.colorScheme.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.euro,
                  label: 'Réductions',
                  value: '${stats.totalDiscountGiven.toStringAsFixed(0)}€',
                  color: theme.colorScheme.error,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.trending_up,
                  label: 'Ventes',
                  value:
                      '${stats.totalRevenueFromPromotions.toStringAsFixed(0)}€',
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.visibility,
                  label: 'Vues',
                  value: stats.promotionViews.toString(),
                  color: theme.colorScheme.tertiary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.shopping_cart,
                  label: 'Conversions',
                  value: '${(stats.conversionRate * 100).toStringAsFixed(1)}%',
                  color: theme.colorScheme.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.percent,
                  label: 'Moyenne',
                  value: '${stats.averageDiscount.toStringAsFixed(0)}%',
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showGlobalPromotionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const GlobalPromotionDialog(),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'clear_all':
        _showClearAllPromotionsDialog(context, ref);
        break;
      case 'stats':
        // TODO: Navigation vers page de statistiques détaillées
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Statistiques détaillées à venir...'),
            backgroundColor: Colors.blue,
          ),
        );
        break;
    }
  }

  void _showClearAllPromotionsDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer toutes les promotions'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer toutes les promotions actives ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();

              try {
                await ref
                    .read(storeOffersProvider.notifier)
                    .removeAllPromotions();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Toutes les promotions ont été supprimées'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la suppression: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
