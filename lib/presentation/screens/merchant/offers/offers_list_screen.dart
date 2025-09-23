import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/adaptive_widgets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/merchant/offers_management_provider.dart';

/// Écran de liste des offres pour les commerçants
class OffersListScreen extends ConsumerStatefulWidget {
  const OffersListScreen({super.key});

  @override
  ConsumerState<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends ConsumerState<OffersListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(merchantOffersProvider);

    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text('Mes Offres'),
        actions: [
          // Bouton de création d'offre
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/merchant/offers/create'),
          ),
          // Menu d'options
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'bulk_actions',
                child: Text('Actions groupées'),
              ),
              const PopupMenuItem(value: 'export', child: Text('Exporter')),
              const PopupMenuItem(value: 'settings', child: Text('Paramètres')),
            ],
            onSelected: _handleMenuAction,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: Column(
            children: [
              // Barre de recherche
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une offre...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: _performSearch,
                ),
              ),
              // Onglets de filtres
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Toutes'),
                  Tab(text: 'Actives'),
                  Tab(text: 'Brouillons'),
                  Tab(text: 'Expirées'),
                ],
                onTap: _onTabChanged,
              ),
            ],
          ),
        ),
      ),
      body: offersAsync.when(
        data: (result) => result.fold(
          (failure) => _buildErrorState(failure.userMessage),
          (offers) => _buildOffersList(offers),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/merchant/offers/create'),
        tooltip: 'Créer une offre',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOffersList(List<FoodOffer> offers) {
    if (offers.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(merchantOffersProvider);
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return _buildOfferCard(offer);
        },
      ),
    );
  }

  Widget _buildOfferCard(FoodOffer offer) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => context.push('/merchant/offers/${offer.id}/edit'),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec titre et statut
              Row(
                children: [
                  Expanded(
                    child: Text(
                      offer.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(offer.status),
                ],
              ),

              SizedBox(height: 8.h),

              // Description
              Text(
                offer.description,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12.h),

              // Prix et quantité
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${offer.discountedPrice.toStringAsFixed(2)}€',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  if (offer.originalPrice > offer.discountedPrice)
                    Text(
                      '${offer.originalPrice.toStringAsFixed(2)}€',
                      style: TextStyle(
                        fontSize: 14.sp,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey[600],
                      ),
                    ),

                  const Spacer(),

                  // Quantité disponible
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getStockColor(offer.quantity),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${offer.quantity} dispo',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Footer avec dates et actions
              Row(
                children: [
                  // Date d'expiration
                  Icon(Icons.schedule, size: 16.sp, color: Colors.grey[600]),
                  SizedBox(width: 4.w),
                  Text(
                    'Expire le ${_formatDate(offer.pickupEndTime)}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),

                  const Spacer(),

                  // Actions rapides
                  Row(
                    children: [
                      // Toggle status
                      IconButton(
                        icon: Icon(
                          offer.status == OfferStatus.available
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 20.sp,
                        ),
                        onPressed: () => _toggleOfferStatus(offer),
                        tooltip: offer.status == OfferStatus.available
                            ? 'Désactiver'
                            : 'Activer',
                      ),

                      // Dupliquer
                      IconButton(
                        icon: Icon(Icons.content_copy, size: 20.sp),
                        onPressed: () => _duplicateOffer(offer),
                        tooltip: 'Dupliquer',
                      ),

                      // Menu d'options
                      PopupMenuButton<String>(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Modifier'),
                          ),
                          const PopupMenuItem(
                            value: 'analytics',
                            child: Text('Analytics'),
                          ),
                          const PopupMenuItem(
                            value: 'share',
                            child: Text('Partager'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Supprimer'),
                          ),
                        ],
                        onSelected: (value) => _handleOfferAction(value, offer),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OfferStatus status) {
    Color color;
    String label;

    switch (status) {
      case OfferStatus.available:
        color = Colors.green;
        label = 'Active';
        break;
      case OfferStatus.draft:
        color = Colors.grey;
        label = 'Brouillon';
        break;
      case OfferStatus.expired:
        color = Colors.red;
        label = 'Expirée';
        break;
      case OfferStatus.reserved:
        color = Colors.blue;
        label = 'Réservée';
        break;
      case OfferStatus.collected:
        color = Colors.purple;
        label = 'Collectée';
        break;
      case OfferStatus.cancelled:
        color = Colors.orange;
        label = 'Annulée';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStockColor(int stock) {
    if (stock > 10) return Colors.green;
    if (stock > 3) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'Aujourd\'hui';
    if (difference == 1) return 'Demain';
    if (difference < 7) return '${difference}j';

    return '${date.day}/${date.month}';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'Aucune offre',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Créez votre première offre pour commencer à vendre',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => context.push('/merchant/offers/create'),
              icon: const Icon(Icons.add),
              label: const Text('Créer une offre'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red[400]),
            SizedBox(height: 16.h),
            Text(
              'Erreur',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(merchantOffersProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  // Actions

  void _performSearch(String query) {
    // TODO: Implémenter la recherche avec filtres
    ref.read(offersFiltersProvider.notifier).updateSearch(query);
  }

  void _onTabChanged(int index) {
    OffersViewFilter? status;
    switch (index) {
      case 0:
        status = OffersViewFilter.all;
        break; // Toutes
      case 1:
        status = OffersViewFilter.active;
        break;
      case 2:
        status = OffersViewFilter.draft;
        break;
      case 3:
        status = OffersViewFilter.expired;
        break;
    }
    ref.read(offersFiltersProvider.notifier).updateStatus(status);
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'bulk_actions':
        _showBulkActionsDialog();
        break;
      case 'export':
        _exportOffers();
        break;
      case 'settings':
        _showSettingsDialog();
        break;
    }
  }

  Future<void> _toggleOfferStatus(FoodOffer offer) async {
    final activate = offer.status != OfferStatus.available;
    final result = await ref.read(
      toggleOfferStatusProvider((offerId: offer.id, activate: activate)).future,
    );

    result.fold(
      (failure) => context.showError(failure),
      (_) =>
          context.showSuccess(activate ? 'Offre activée' : 'Offre désactivée'),
    );
  }

  Future<void> _duplicateOffer(FoodOffer offer) async {
    final result = await ref.read(
      duplicateOfferProvider((
        offerId: offer.id,
        startTime: null,
        endTime: null,
      )).future,
    );

    result.fold((failure) => context.showError(failure), (newOffer) {
      context.showSuccess('Offre dupliquée avec succès');
      context.push('/merchant/offers/${newOffer.id}/edit');
    });
  }

  void _handleOfferAction(String action, FoodOffer offer) {
    switch (action) {
      case 'edit':
        context.push('/merchant/offers/${offer.id}/edit');
        break;
      case 'analytics':
        _showOfferAnalytics(offer);
        break;
      case 'share':
        _shareOffer(offer);
        break;
      case 'delete':
        _confirmDeleteOffer(offer);
        break;
    }
  }

  void _showBulkActionsDialog() {
    // TODO: Implémenter les actions groupées
  }

  void _exportOffers() {
    // TODO: Implémenter l'export
  }

  void _showSettingsDialog() {
    // TODO: Implémenter les paramètres
  }

  void _showOfferAnalytics(FoodOffer offer) {
    // TODO: Afficher les analytics de l'offre
  }

  void _shareOffer(FoodOffer offer) {
    // TODO: Implémenter le partage
  }

  Future<void> _confirmDeleteOffer(FoodOffer offer) async {
    final confirmed = await context.showConfirmationDialog(
      title: 'Supprimer l\'offre',
      message: 'Êtes-vous sûr de vouloir supprimer "${offer.title}" ?',
      confirmText: 'Supprimer',
      isDestructive: true,
    );

    if (confirmed == true) {
      final result = await ref.read(
        deleteOfferProvider((offerId: offer.id, reason: null)).future,
      );

      result.fold(
        (failure) => context.showError(failure),
        (_) => context.showSuccess('Offre supprimée'),
      );
    }
  }
}
