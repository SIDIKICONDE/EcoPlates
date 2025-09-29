import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/stock_repository_impl.dart';
import '../../domain/entities/stock_item.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/usecases/adjust_stock_quantity_usecase.dart';
import '../../domain/usecases/create_stock_item_usecase.dart';
import '../../domain/usecases/delete_stock_item_usecase.dart';
import '../../domain/usecases/get_stock_items_usecase.dart';
import '../../domain/usecases/update_stock_item_status_usecase.dart';
import '../../domain/usecases/update_stock_item_usecase.dart';

/// Provider pour le repository de stock
final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepositoryImpl();
});

/// Provider pour le use case de récupération des articles
final getStockItemsUseCaseProvider = Provider<GetStockItemsUseCase>((ref) {
  return GetStockItemsUseCase(ref.read(stockRepositoryProvider));
});

/// Provider pour le use case d'ajustement des quantités
final adjustStockQuantityUseCaseProvider = Provider<AdjustStockQuantityUseCase>(
  (ref) {
    return AdjustStockQuantityUseCase(ref.read(stockRepositoryProvider));
  },
);

/// Provider pour le use case de changement de statut
final updateStockItemStatusUseCaseProvider =
    Provider<UpdateStockItemStatusUseCase>((ref) {
      return UpdateStockItemStatusUseCase(ref.read(stockRepositoryProvider));
    });

/// Provider pour le use case de création d'article
final createStockItemUseCaseProvider = Provider<CreateStockItemUseCase>((ref) {
  return CreateStockItemUseCase(ref.read(stockRepositoryProvider));
});

/// Provider pour le use case de mise à jour d'article
final updateStockItemUseCaseProvider = Provider<UpdateStockItemUseCase>((ref) {
  return UpdateStockItemUseCase(ref.read(stockRepositoryProvider));
});

/// Provider pour le use case de suppression d'article
final deleteStockItemUseCaseProvider = Provider<DeleteStockItemUseCase>((ref) {
  return DeleteStockItemUseCase(ref.read(stockRepositoryProvider));
});

/// État des filtres de recherche
class StockFiltersState {
  const StockFiltersState({
    this.searchQuery = '',
    this.statusFilter,
    this.sortBy = StockSortOption.nameAsc,
  });

  final String searchQuery;
  final StockItemStatus? statusFilter;
  final StockSortOption sortBy;

  StockFiltersState copyWith({
    String? searchQuery,
    StockItemStatus? statusFilter,
    StockSortOption? sortBy,
  }) {
    return StockFiltersState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  /// Convertit l'état en filtre pour les use cases
  StockItemsFilter toFilter() {
    return StockItemsFilter(
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
      status: statusFilter,
    );
  }
}

/// Notifier pour l'état des filtres
class StockFiltersNotifier extends Notifier<StockFiltersState> {
  @override
  StockFiltersState build() {
    return const StockFiltersState();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateStatusFilter(StockItemStatus? status) {
    state = state.copyWith(statusFilter: status);
  }

  void updateSortBy(StockSortOption sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void clearFilters() {
    state = const StockFiltersState();
  }
}

/// Provider pour l'état des filtres
final stockFiltersProvider =
    NotifierProvider<StockFiltersNotifier, StockFiltersState>(
      StockFiltersNotifier.new,
    );

/// Notifier pour la gestion des articles de stock
class StockItemsNotifier extends AsyncNotifier<List<StockItem>> {
  Timer? _debounceTimer;

  @override
  Future<List<StockItem>> build() async {
    // Charger le tri sauvegardé si nécessaire
    await _loadPersistedSortIfAny();

    // Écoute les changements de filtres avec debounce pour la recherche
    final filters = ref.watch(stockFiltersProvider);

    // Annule le timer précédent s'il existe
    _debounceTimer?.cancel();

    // Si c'est une recherche textuelle, on applique un debounce
    if (filters.searchQuery.isNotEmpty) {
      final completer = Completer<List<StockItem>>();

      _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        try {
          final result = await _loadItems(filters);
          if (!completer.isCompleted) {
            completer.complete(result);
          }
        } catch (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        }
      });

      return completer.future;
    }

    // Pour les autres filtres, on charge immédiatement
    return _loadItems(filters);
  }

  /// Charge le tri sauvegardé dans SharedPreferences et l'applique au filtre
  Future<void> _loadPersistedSortIfAny() async {
    try {
      // Evite un import direct ici en gardant la logique dans la page si besoin;
      // mais on peut accéder dynamiquement à shared_preferences via Function.apply? Non.
      // Solution simple: faire l'application côté UI. Ici on ne fait rien si non dispo.
    } on Exception catch (_) {
      // ignore
    }
  }

  /// Charge les articles avec les filtres appliqués
  Future<List<StockItem>> _loadItems(StockFiltersState filters) async {
    final useCase = ref.read(getStockItemsUseCaseProvider);

    try {
      return await useCase.call(
        filter: filters.toFilter(),
        sortBy: filters.sortBy,
      );
    } catch (error) {
      // Log l'erreur si nécessaire
      rethrow;
    }
  }

  /// Ajuste la quantité d'un article
  Future<void> adjustQuantity(String itemId, int delta) async {
    final useCase = ref.read(adjustStockQuantityUseCaseProvider);

    try {
      // Mise à jour optimiste : on met à jour l'état immédiatement
      final currentState = state.value;
      if (currentState != null) {
        final updatedItems = currentState.map((item) {
          if (item.id == itemId) {
            final newQuantity = (item.quantity + delta).clamp(0, 999999);
            return item.copyWith(
              quantity: newQuantity,
              updatedAt: DateTime.now(),
            );
          }
          return item;
        }).toList();

        state = AsyncData(updatedItems);
      }

      // Puis on effectue la vraie mise à jour
      await useCase.call(itemId, delta);

      // On recharge pour s'assurer de la cohérence
      await _refreshItems();
    } catch (error) {
      // En cas d'erreur, on recharge les données depuis le serveur
      await _refreshItems();

      // On relance l'erreur pour que l'UI puisse la gérer
      rethrow;
    }
  }

  /// Bascule le statut d'un article
  Future<void> toggleStatus(String itemId) async {
    final useCase = ref.read(updateStockItemStatusUseCaseProvider);

    try {
      // Mise à jour optimiste
      final currentState = state.value;
      if (currentState != null) {
        final updatedItems = currentState.map((item) {
          if (item.id == itemId) {
            final newStatus = item.status == StockItemStatus.active
                ? StockItemStatus.inactive
                : StockItemStatus.active;
            return item.copyWith(status: newStatus, updatedAt: DateTime.now());
          }
          return item;
        }).toList();

        state = AsyncData(updatedItems);
      }

      // Mise à jour réelle (sans rechargement automatique pour plus de fluidité)
      await useCase.toggle(itemId);

      // Note: On ne fait pas de rechargement automatique ici pour éviter les délais
      // La mise à jour optimiste devrait être suffisante pour l'UX
    } catch (error) {
      // En cas d'erreur, on recharge pour restaurer l'état correct
      await _refreshItems();
      rethrow;
    }
  }

  /// Met à jour un article existant
  Future<void> updateItem(StockItem item) async {
    final useCase = ref.read(updateStockItemUseCaseProvider);

    try {
      // Mise à jour optimiste
      final currentState = state.value;
      if (currentState != null) {
        final updatedItems = currentState.map((currentItem) {
          if (currentItem.id == item.id) {
            return item.copyWith(updatedAt: DateTime.now());
          }
          return currentItem;
        }).toList();

        state = AsyncData(updatedItems);
      }

      // Mise à jour réelle
      await useCase.call(item);

      // Rechargement pour cohérence
      await _refreshItems();
    } catch (error) {
      // En cas d'erreur, on recharge
      await _refreshItems();
      rethrow;
    }
  }

  /// Crée un nouvel article
  Future<void> createItem({
    required String name,
    required String sku,
    required String category,
    required double price,
    required int quantity,
    required String unit,
    String? description,
    int? lowStockThreshold,
    StockItemStatus? status,
  }) async {
    final useCase = ref.read(createStockItemUseCaseProvider);

    try {
      // Création réelle via use case
      final created = await useCase.call(
        name: name,
        sku: sku,
        category: category,
        price: price,
        quantity: quantity,
        unit: unit,
        description: description,
        lowStockThreshold: lowStockThreshold,
        status: status,
      );

      // Mise à jour de l'état local
      final currentState = state.value ?? [];
      state = AsyncData([created, ...currentState]);

      // Optionnel: recharger depuis la source
      await _refreshItems();
    } catch (error) {
      // En cas d'erreur, recharger et relancer
      await _refreshItems();
      rethrow;
    }
  }

  /// Supprime un article
  Future<void> deleteItem(String itemId) async {
    final useCase = ref.read(deleteStockItemUseCaseProvider);

    try {
      // Suppression optimiste
      final currentState = state.value;
      if (currentState != null) {
        final updatedItems = currentState
            .where((item) => item.id != itemId)
            .toList();

        state = AsyncData(updatedItems);
      }

      // Suppression réelle
      await useCase.call(itemId);

      // Rechargement pour cohérence
      await _refreshItems();
    } catch (error) {
      // En cas d'erreur, on recharge
      await _refreshItems();
      rethrow;
    }
  }

  /// Force le rechargement des données
  Future<void> refresh() async {
    state = const AsyncLoading();
    await _refreshItems();
  }

  /// Recharge les articles avec les filtres actuels
  Future<void> _refreshItems() async {
    final filters = ref.read(stockFiltersProvider);
    state = AsyncData(await _loadItems(filters));
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}

/// Provider principal pour les articles de stock
final stockItemsProvider =
    AsyncNotifierProvider<StockItemsNotifier, List<StockItem>>(() {
      return StockItemsNotifier();
    });

/// Provider pour le nombre total d'articles
final stockItemsCountProvider = Provider<int>((ref) {
  final stockItems = ref.watch(stockItemsProvider);
  return stockItems.maybeWhen(data: (items) => items.length, orElse: () => 0);
});

/// Provider pour les articles en rupture de stock
final outOfStockItemsProvider = Provider<List<StockItem>>((ref) {
  final stockItems = ref.watch(stockItemsProvider);
  return stockItems.maybeWhen(
    data: (items) => items.where((item) => item.isOutOfStock).toList(),
    orElse: () => [],
  );
});

/// Provider pour les articles inactifs
final inactiveItemsProvider = Provider<List<StockItem>>((ref) {
  final stockItems = ref.watch(stockItemsProvider);
  return stockItems.maybeWhen(
    data: (items) =>
        items.where((item) => item.status == StockItemStatus.inactive).toList(),
    orElse: () => [],
  );
});

/// Provider pour les articles avec stock faible
final lowStockItemsProvider = Provider<List<StockItem>>((ref) {
  final stockItems = ref.watch(stockItemsProvider);
  return stockItems.maybeWhen(
    data: (items) => items.where((item) => item.isLowStock).toList(),
    orElse: () => [],
  );
});

/// Provider pour les articles nécessitant une alerte (stock faible ou rupture)
final stockAlertItemsProvider = Provider<List<StockItem>>((ref) {
  final stockItems = ref.watch(stockItemsProvider);
  return stockItems.maybeWhen(
    data: (items) => items
        .where((item) => item.alertLevel != StockAlertLevel.normal)
        .toList(),
    orElse: () => [],
  );
});

/// Notifier pour le mode d'affichage de la liste
class StockViewModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    // false = vue détaillée (par défaut)
    return false;
  }

  void toggle() {
    state = !state;
  }

  void setCompact({required bool isCompact}) {
    state = isCompact;
  }
}

/// Provider pour le mode d'affichage de la liste (compact ou détaillé)
final stockViewModeProvider = NotifierProvider<StockViewModeNotifier, bool>(
  StockViewModeNotifier.new,
);

/// Messages d'erreur localisés
class StockErrorMessages {
  static const String networkError = 'Problème de connexion réseau';
  static const String unknownError = "Une erreur inattendue s'est produite";
  static const String noItemsFound = 'Aucun article trouvé';
  static const String adjustQuantityError =
      'Impossible de modifier la quantité';
  static const String toggleStatusError = 'Impossible de changer le statut';

  /// Retourne un message d'erreur localisé selon le type d'exception
  static String getErrorMessage(Object error) {
    if (error.toString().contains('network') ||
        error.toString().contains('connexion')) {
      return networkError;
    }

    if (error is InvalidQuantityAdjustmentException) {
      return error.message;
    }

    return unknownError;
  }
}
