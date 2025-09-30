import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/promotion_service.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
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
          children: const [
            Icon(Icons.local_offer, color: DeepColorTokens.primary),
            SizedBox(width: 12.0),
            Text('Gestion des promotions'),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistiques rapides
                _buildPromotionStatsCard(context, promotionStats),
                const SizedBox(height: 24.0),

                // Promotions actives
                if (offersWithPromotions.isNotEmpty) ...[
                  Text(
                    'Promotions actives (${offersWithPromotions.length})',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ...offersWithPromotions.map(
                    (offer) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: OfferPromotionManager(
                        offer: offer,
                        onPromotionUpdated: () =>
                            ref.invalidate(storeOffersProvider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],

                // Offres sans promotion
                Text(
                  'Ajouter une promotion (${offersWithoutPromotions.length})',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16.0),
                if (offersWithoutPromotions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: 64.0,
                            color: DeepColorTokens.primary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Toutes vos offres ont une promotion !',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: DeepColorTokens.neutral0.withValues(
                                alpha: 0.6,
                              ),
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
                          padding: const EdgeInsets.only(bottom: 16.0),
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
              Icon(
                Icons.error,
                size: 48.0,
                color: DeepColorTokens.error,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Erreur lors du chargement des offres',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: DeepColorTokens.neutral0.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
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
        backgroundColor: DeepColorTokens.primary,
      ),
    );
  }

  Widget _buildPromotionStatsCard(BuildContext context, PromotionStats stats) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DeepColorTokens.surfaceContainer,
            DeepColorTokens.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.primary.withValues(alpha: 0.1),
            blurRadius: 8.0,
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
                color: DeepColorTokens.neutral0,
                size: 24.0,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Statistiques des promotions',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: DeepColorTokens.neutral0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.local_offer,
                  label: 'Actives',
                  value: stats.activePromotions.toString(),
                  color: DeepColorTokens.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.euro,
                  label: 'Réductions',
                  value: '${stats.totalDiscountGiven.toStringAsFixed(0)}€',
                  color: DeepColorTokens.error,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.trending_up,
                  label: 'Ventes',
                  value:
                      '${stats.totalRevenueFromPromotions.toStringAsFixed(0)}€',
                  color: DeepColorTokens.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.visibility,
                  label: 'Vues',
                  value: stats.promotionViews.toString(),
                  color: DeepColorTokens.tertiary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.shopping_cart,
                  label: 'Conversions',
                  value: '${(stats.conversionRate * 100).toStringAsFixed(1)}%',
                  color: DeepColorTokens.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context: context,
                  icon: Icons.percent,
                  label: 'Moyenne',
                  value: '${stats.averageDiscount.toStringAsFixed(0)}%',
                  color: DeepColorTokens.error,
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
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.0, color: color),
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: DeepColorTokens.neutral600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showGlobalPromotionDialog(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => const GlobalPromotionDialog(),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'clear_all':
        _showClearAllPromotionsDialog(context, ref);
      case 'stats':
        // TODO: Navigation vers page de statistiques détaillées
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Statistiques détaillées à venir...'),
            backgroundColor: DeepColorTokens.primary,
          ),
        );
    }
  }

  void _showClearAllPromotionsDialog(BuildContext context, WidgetRef ref) {
    unawaited(
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
                      SnackBar(
                        content: Text(
                          'Toutes les promotions ont été supprimées',
                        ),
                        backgroundColor: DeepColorTokens.success,
                      ),
                    );
                  }
                } on Exception catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur lors de la suppression: $e'),
                        backgroundColor: DeepColorTokens.error,
                      ),
                    );
                  }
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: DeepColorTokens.error,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        ),
      ),
    );
  }
}
