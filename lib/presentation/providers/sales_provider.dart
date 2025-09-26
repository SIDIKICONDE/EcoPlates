import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../../domain/entities/sale.dart';

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
final salesFilterProvider = NotifierProvider<SalesFilterNotifier, SalesFilterState>(
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
          ),
        ],
        totalAmount: 12,
        discountAmount: 8,
        finalAmount: 4,
        createdAt: now.subtract(const Duration(minutes: 30)),
        collectedAt: null,
        status: SaleStatus.pending,
        paymentMethod: 'Carte bancaire',
        qrCode: 'QR123456',
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
          ),
          const SaleItem(
            offerId: 'offer4',
            offerTitle: 'Dessert du jour',
            category: FoodCategory.dessert,
            quantity: 1,
            unitPrice: 5,
            totalPrice: 5,
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
            sale.qrCode != null && sale.qrCode!.toLowerCase().contains(query);
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
