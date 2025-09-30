import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes/route_constants.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../core/widgets/adaptive_widgets.dart';
import '../providers/store_offers_provider.dart';
import '../widgets/store/global_promotion_dialog.dart';
import '../widgets/store/store_filter_chips.dart';
import '../widgets/store/store_offers_grid.dart';

/// Page principale de gestion de la boutique pour les marchands
///
/// Affiche les offres alimentaires du marchand avec possibilité de :
/// - Rechercher des offres par nom
/// - Filtrer par statut (actif/inactif) et catégories
/// - Gérer les promotions et prix
/// - Visualiser les statistiques de vente
/// - Ajouter/modifier/supprimer des offres
class MerchantStorePage extends ConsumerWidget {
  const MerchantStorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final offersCount = ref.watch(activeOffersCountProvider);
    final inactiveOffersCount = ref.watch(inactiveOffersCountProvider);
    final promotionsCount = ref.watch(activePromotionsCountProvider);

    return AdaptiveScaffold(
      appBar: _buildAppBar(
        context,
        ref,
        theme,
        offersCount,
        inactiveOffersCount,
        promotionsCount,
      ),
      body: const Column(
        children: [
          // En-tête avec recherche et filtres
          _StoreHeader(),

          // Grille des offres
          Expanded(child: StoreOffersGrid()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToOfferForm(context),
        label: const Text('Nouvelle offre'),
        icon: const Icon(Icons.add),
        backgroundColor: DeepColorTokens.primary,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    int offersCount,
    int inactiveOffersCount,
    int promotionsCount,
  ) {
    return AdaptiveAppBar(
      leading: const _MerchantLogo(),
      title: Row(
        children: [
          Icon(Icons.storefront, size: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ma Boutique', overflow: TextOverflow.ellipsis),
                if (offersCount > 0 ||
                    inactiveOffersCount > 0 ||
                    promotionsCount > 0)
                  Text(
                    '$offersCount actives${inactiveOffersCount > 0 ? ' • $inactiveOffersCount inactives' : ''}${promotionsCount > 0 ? ' • $promotionsCount promo' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Mode d'affichage (grille/liste)
        IconButton(
          icon: Icon(
            ref.watch(storeViewModeProvider) == StoreViewMode.grid
                ? Icons.view_list
                : Icons.grid_view,
          ),
          tooltip: 'Changer la vue',
          onPressed: () {
            ref.read(storeViewModeProvider.notifier).toggle();
          },
        ),

        // Actions rapides
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(context, ref, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Actualiser'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'sort',
              child: ListTile(
                leading: Icon(Icons.sort),
                title: Text('Trier'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'bulk_actions',
              child: ListTile(
                leading: Icon(Icons.checklist),
                title: Text('Actions groupées'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: Icon(Icons.download),
                title: Text('Exporter catalogue'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'promotions',
              child: ListTile(
                leading: Icon(Icons.local_offer),
                title: Text('Gérer les promotions'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'analytics',
              child: ListTile(
                leading: Icon(Icons.analytics),
                title: Text('Analytics détaillés'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),

        const SizedBox(width: 6),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'refresh':
        unawaited(ref.read(storeOffersProvider.notifier).refresh());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Actualisation en cours...'),
            duration: Duration(seconds: 1),
          ),
        );
      case 'sort':
        _showSortBottomSheet(context, ref);
      case 'bulk_actions':
        _showBulkActionsDialog(context, ref);
      case 'export':
        unawaited(_exportCatalog(context, ref));
      case 'promotions':
        context.go(RouteConstants.merchantPromotions);
      case 'analytics':
        // TODO: Navigation vers analytics détaillés
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analytics détaillés à venir...'),
            backgroundColor: Colors.blue,
          ),
        );
    }
  }

  void _showSortBottomSheet(BuildContext context, WidgetRef ref) {
    final currentSort = ref.read(storeFiltersProvider).sortBy;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.all(
                    16,
                  ),
                  child: Text(
                    'Trier les offres par',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ...StoreSortOption.values.map((option) {
                  final isSelected = option == currentSort;
                  return ListTile(
                    leading: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(option.label),
                    subtitle: Text(option.description),
                    onTap: () {
                      ref
                          .read(storeFiltersProvider.notifier)
                          .updateSortBy(option);
                      Navigator.of(context).pop();
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBulkActionsDialog(BuildContext context, WidgetRef ref) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Actions groupées'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.visibility_off),
                  title: const Text('Désactiver toutes les offres'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _confirmBulkAction(context, ref, 'deactivate_all');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_offer),
                  title: const Text('Appliquer une promotion globale'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showGlobalPromotionDialog(context, ref);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: const Text('Mettre à jour les prix'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showPriceUpdateDialog(context, ref);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmBulkAction(BuildContext context, WidgetRef ref, String action) {
    // TODO: Implémenter les actions groupées
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action "$action" à implémenter'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showGlobalPromotionDialog(BuildContext context, WidgetRef ref) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => const GlobalPromotionDialog(),
      ),
    );
  }

  void _showPriceUpdateDialog(BuildContext context, WidgetRef ref) {
    // TODO: Dialog pour mise à jour des prix en masse
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mise à jour des prix à implémenter'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _exportCatalog(BuildContext context, WidgetRef ref) async {
    try {
      // TODO: Implémenter l'export du catalogue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Export du catalogue en cours...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Simuler l'export
      await Future<void>.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catalogue exporté avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'export : $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToOfferForm(BuildContext context) {
    // Navigation vers le formulaire d'offres (mode création)
    context.go(RouteConstants.merchantOfferForm);
  }
}

/// Widget pour l'en-tête de recherche et filtres avec espacement responsive
class _StoreHeader extends StatelessWidget {
  const _StoreHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Barre de recherche
          SizedBox(height: 16),

          // Chips de filtrage
          Align(
            alignment: Alignment.centerLeft,
            child: StoreFilterChips(),
          ),
        ],
      ),
    );
  }
}

/// Widget pour le logo du marchand avec espacement responsive
class _MerchantLogo extends StatelessWidget {
  const _MerchantLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: Récupérer le logo depuis le profil marchand connecté
    const merchantLogoUrl =
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop&crop=center';

    return Container(
      margin: EdgeInsets.all(16),
      child: CircleAvatar(
        backgroundImage: NetworkImage(merchantLogoUrl),
        radius: 16,
        onBackgroundImageError: (_, _) {
          // Fallback si l'image ne charge pas
        },
        child: Icon(
          Icons.store,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
