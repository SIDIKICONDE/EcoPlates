import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../../domain/entities/sale.dart';
import './stock_items_provider.dart';

/// Sentinelle interne pour détecter l'absence de valeur dans copyWith
const Object _unset = Object();

/// Filtre pour les ventes
enum SalesPeriodFilter { today, week, month, custom }

/// État des filtres de ventes
class SalesFilterState {
  const SalesFilterState({
    this.period = SalesPeriodFilter.today,
    this.status,
    this.startDate,
    this.endDate,
    this.searchQuery = '',
  });

  final SalesPeriodFilter period;
  final SaleStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String searchQuery;

  SalesFilterState copyWith({
    SalesPeriodFilter? period,
    Object? status = _unset,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return SalesFilterState(
      period: period ?? this.period,
      status: identical(status, _unset) ? this.status : status as SaleStatus?,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Notifier pour les filtres de ventes
class SalesFilterNotifier extends Notifier<SalesFilterState> {
  @override
  SalesFilterState build() {
    return const SalesFilterState();
  }

  void updatePeriod(SalesPeriodFilter period) {
    state = state.copyWith(period: period);
  }

  void updateStatus(SaleStatus? status) {
    state = state.copyWith(status: status);
  }

  void updateDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = const SalesFilterState();
  }
}

/// Provider pour les filtres de ventes
final salesFilterProvider =
    NotifierProvider<SalesFilterNotifier, SalesFilterState>(
      SalesFilterNotifier.new,
    );

/// Provider pour les ventes du marchand
final salesProvider = AsyncNotifierProvider<SalesNotifier, List<Sale>>(() {
  return SalesNotifier();
});

class SalesNotifier extends AsyncNotifier<List<Sale>> {
  @override
  Future<List<Sale>> build() async {
    // Simuler un chargement depuis une API
    await Future<void>.delayed(const Duration(seconds: 1));

    // Écouter les changements de filtres et régénérer la liste
    final filters = ref.watch(salesFilterProvider);

    return _generateMockSales(filters);
  }

  /// Rafraîchit les ventes
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  /// Met à jour le statut d'une vente
  Future<void> updateSaleStatus(String saleId, SaleStatus newStatus) async {
    state = await AsyncValue.guard(() async {
      final sales = state.value ?? [];
      final saleToUpdate = sales.firstWhere((sale) => sale.id == saleId);

      // Valider le stock avant certaines transitions
      if (newStatus == SaleStatus.collected) {
        final stockValid = await validateStockForSale(saleId);
        if (!stockValid) {
          throw Exception('Stock insuffisant pour récupérer cette commande');
        }
      }

      // Synchroniser avec le stock si nécessaire
      await _syncStockOnStatusChange(saleToUpdate, newStatus);

      final updatedSales = sales.map((sale) {
        if (sale.id == saleId) {
          return sale.copyWith(
            status: newStatus,
            collectedAt: newStatus == SaleStatus.collected
                ? DateTime.now()
                : null,
          );
        }
        return sale;
      }).toList();

      // Simuler une mise à jour API
      await Future<void>.delayed(const Duration(milliseconds: 500));

      return updatedSales;
    });
  }

  /// Vérifie si le stock est suffisant pour confirmer une vente
  Future<bool> validateStockForSale(String saleId) async {
    try {
      final sales = state.value ?? [];
      final sale = sales.firstWhere((s) => s.id == saleId);

      final stockItems = ref.read(stockItemsProvider).value ?? [];

      for (final item in sale.items) {
        if (item.stockItemId != null && item.stockItemId!.isNotEmpty) {
          final stockItem = stockItems.firstWhere(
            (stock) => stock.id == item.stockItemId,
            orElse: () => throw Exception(
              'Item de stock non trouvé: ${item.stockItemId}',
            ),
          );

          if (stockItem.quantity < item.quantity) {
            return false; // Stock insuffisant
          }
        }
      }

      return true; // Stock suffisant pour tous les items
    } catch (e) {
      // En cas d'erreur (item non trouvé, etc.), considérer comme valide
      // pour ne pas bloquer les ventes sans références de stock
      return true;
    }
  }

  /// Synchronise le stock selon le changement de statut de vente
  Future<void> _syncStockOnStatusChange(Sale sale, SaleStatus newStatus) async {
    // Récupérer le provider de stock
    final stockNotifier = ref.read(stockItemsProvider.notifier);

    // Selon le changement de statut, ajuster le stock
    switch (newStatus) {
      case SaleStatus.collected:
        // Quand la vente est récupérée, décrémenter le stock des items liés
        if (sale.status != SaleStatus.collected) {
          await _decrementStockForSale(sale, stockNotifier);
        }
        break;

      case SaleStatus.cancelled:
      case SaleStatus.refunded:
        // Quand la vente est annulée/remboursée, restaurer le stock
        if (sale.status == SaleStatus.collected) {
          await _restoreStockForSale(sale, stockNotifier);
        }
        break;

      case SaleStatus.pending:
      case SaleStatus.confirmed:
        // Pas de changement de stock pour ces statuts
        break;
    }
  }

  /// Décrémente le stock pour les items d'une vente
  Future<void> _decrementStockForSale(Sale sale, dynamic stockNotifier) async {
    for (final item in sale.items) {
      if (item.stockItemId != null && item.stockItemId!.isNotEmpty) {
        try {
          await stockNotifier.adjustQuantity(item.stockItemId!, -item.quantity);
        } catch (e) {
          // Log l'erreur mais ne bloque pas la vente
          print(
            'Erreur lors de la décrémentation du stock pour ${item.stockItemId}: $e',
          );
        }
      }
    }
  }

  /// Restaure le stock pour les items d'une vente
  Future<void> _restoreStockForSale(Sale sale, dynamic stockNotifier) async {
    for (final item in sale.items) {
      if (item.stockItemId != null && item.stockItemId!.isNotEmpty) {
        try {
          await stockNotifier.adjustQuantity(item.stockItemId!, item.quantity);
        } catch (e) {
          // Log l'erreur mais ne bloque pas la restauration
          print(
            'Erreur lors de la restauration du stock pour ${item.stockItemId}: $e',
          );
        }
      }
    }
  }

  /// Génère des ventes fictives pour la démo
  List<Sale> _generateMockSales(SalesFilterState filters) {
    final now = DateTime.now();

    // Base de ventes fictives
    final allSales = [
      Sale(
        id: '1',
        merchantId: 'merchant1',
        customerId: 'customer1',
        customerName: 'Sophie Martin',
        items: [
          const SaleItem(
            offerId: 'offer1',
            offerTitle: 'Panier anti-gaspi du soir',
            category: FoodCategory.diner,
            quantity: 1,
            unitPrice: 12,
            totalPrice: 12,
            stockItemId: 'stock_1', // Référence vers un item de stock fictif
          ),
        ],
        totalAmount: 12,
        discountAmount: 8,
        finalAmount: 4,
        createdAt: now.subtract(const Duration(minutes: 30)),
        collectedAt: null,
        status: SaleStatus.pending,
        paymentMethod: 'Carte bancaire',
        secureQrEnabled: true,
      ),
      Sale(
        id: '2',
        merchantId: 'merchant1',
        customerId: 'customer2',
        customerName: 'Jean Dupont',
        items: [
          const SaleItem(
            offerId: 'offer2',
            offerTitle: 'Panier boulangerie',
            category: FoodCategory.boulangerie,
            quantity: 2,
            unitPrice: 8,
            totalPrice: 16,
            stockItemId: 'stock_2',
          ),
        ],
        totalAmount: 16,
        discountAmount: 10,
        finalAmount: 6,
        createdAt: now.subtract(const Duration(hours: 1)),
        collectedAt: now.subtract(const Duration(minutes: 10)),
        status: SaleStatus.collected,
        paymentMethod: 'PayPal',
      ),
      Sale(
        id: '3',
        merchantId: 'merchant1',
        customerId: 'customer3',
        customerName: 'Marie Leroy',
        items: [
          const SaleItem(
            offerId: 'offer3',
            offerTitle: 'Menu végétarien',
            category: FoodCategory.dejeuner,
            quantity: 1,
            unitPrice: 15,
            totalPrice: 15,
            stockItemId: 'stock_3',
          ),
          const SaleItem(
            offerId: 'offer4',
            offerTitle: 'Dessert du jour',
            category: FoodCategory.dessert,
            quantity: 1,
            unitPrice: 5,
            totalPrice: 5,
            stockItemId: 'stock_4',
          ),
        ],
        totalAmount: 20,
        discountAmount: 12,
        finalAmount: 8,
        createdAt: now.subtract(const Duration(hours: 2)),
        collectedAt: null,
        status: SaleStatus.confirmed,
        paymentMethod: 'Apple Pay',
        notes: 'Allergique aux noix',
      ),
      Sale(
        id: '4',
        merchantId: 'merchant1',
        customerId: 'customer4',
        customerName: 'Pierre Bernard',
        items: [
          const SaleItem(
            offerId: 'offer5',
            offerTitle: 'Panier surprise',
            category: FoodCategory.autre,
            quantity: 1,
            unitPrice: 10,
            totalPrice: 10,
            stockItemId: 'stock_5',
          ),
        ],
        totalAmount: 10,
        discountAmount: 6,
        finalAmount: 4,
        createdAt: now.subtract(const Duration(days: 1)),
        collectedAt: null,
        status: SaleStatus.cancelled,
        paymentMethod: 'Carte bancaire',
      ),
    ];

    // Filtrer par période
    var filteredSales = allSales;
    switch (filters.period) {
      case SalesPeriodFilter.today:
        filteredSales = allSales.where((sale) {
          return sale.createdAt.day == now.day &&
              sale.createdAt.month == now.month &&
              sale.createdAt.year == now.year;
        }).toList();
      case SalesPeriodFilter.week:
        final weekAgo = now.subtract(const Duration(days: 7));
        filteredSales = allSales.where((sale) {
          return sale.createdAt.isAfter(weekAgo);
        }).toList();
      case SalesPeriodFilter.month:
        final monthAgo = now.subtract(const Duration(days: 30));
        filteredSales = allSales.where((sale) {
          return sale.createdAt.isAfter(monthAgo);
        }).toList();
      case SalesPeriodFilter.custom:
      // Implémenter la logique pour les dates personnalisées
    }

    // Filtrer par statut
    if (filters.status != null) {
      filteredSales = filteredSales
          .where((sale) => sale.status == filters.status)
          .toList();
    }

    // Filtrer par recherche
    if (filters.searchQuery.isNotEmpty) {
      final query = filters.searchQuery.toLowerCase();
      filteredSales = filteredSales.where((sale) {
        return sale.customerName.toLowerCase().contains(query) ||
            sale.items.any(
              (item) => item.offerTitle.toLowerCase().contains(query),
            ) ||
            sale.totpSecretId != null &&
                sale.totpSecretId!.toLowerCase().contains(query);
      }).toList();
    }

    // Trier par date (plus récent en premier)
    filteredSales.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filteredSales;
  }
}

/// Extensions pour les filtres
extension SalesPeriodFilterExtensions on SalesPeriodFilter {
  String get label {
    switch (this) {
      case SalesPeriodFilter.today:
        return "Aujourd'hui";
      case SalesPeriodFilter.week:
        return 'Cette semaine';
      case SalesPeriodFilter.month:
        return 'Ce mois';
      case SalesPeriodFilter.custom:
        return 'Personnalisé';
    }
  }
}
