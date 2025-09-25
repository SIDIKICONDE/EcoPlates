import 'dart:math';

import '../../domain/entities/stock_item.dart';
import '../../domain/repositories/stock_repository.dart';
import '../models/stock_item_model.dart';

/// Implémentation mock du repository de stock
/// 
/// Utilise un stockage en mémoire avec des données de test
/// et simule des délais réseau pour tester les états de chargement.
class StockRepositoryImpl implements StockRepository {
  StockRepositoryImpl() {
    _initializeMockData();
  }

  /// Stockage en mémoire des articles
  final List<StockItemModel> _items = [];

  /// Générateur de nombres aléatoires pour les délais
  final Random _random = Random();

  @override
  Future<List<StockItem>> getStockItems({
    StockItemsFilter filter = StockItemsFilter.none,
    StockSortOption sortBy = StockSortOption.nameAsc,
  }) async {
    // Simulation d'un délai réseau
    await _simulateNetworkDelay();

    var items = List<StockItemModel>.from(_items);

    // Application des filtres
    items = _applyFilters(items, filter);

    // Application du tri
    items = _applySorting(items, sortBy);

    // Conversion en entités du domaine
    return items.map((model) => model.toEntity()).toList();
  }

  @override
  Future<StockItem?> getStockItemById(String id) async {
    await _simulateNetworkDelay();

    try {
      final model = _items.firstWhere((item) => item.id == id);
      return model.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<StockItem> updateStockItem(StockItem item) async {
    await _simulateNetworkDelay();

    final index = _items.indexWhere((model) => model.id == item.id);
    if (index == -1) {
      throw Exception('Article non trouvé : ${item.id}');
    }

    final updatedModel = StockItemModel.fromEntity(
      item.copyWith(updatedAt: DateTime.now()),
    );
    _items[index] = updatedModel;

    return updatedModel.toEntity();
  }

  @override
  Future<StockItem> adjustQuantity(String id, int delta) async {
    await _simulateNetworkDelay();

    final index = _items.indexWhere((model) => model.id == id);
    if (index == -1) {
      throw Exception('Article non trouvé : $id');
    }

    final currentModel = _items[index];
    final newQuantity = currentModel.quantity + delta;

    if (newQuantity < 0) {
      throw Exception(
        'Quantité insuffisante. Actuelle: ${currentModel.quantity}, '
        'demandée: $delta',
      );
    }

    final updatedModel = currentModel.copyWith(
      quantity: newQuantity,
      updatedAt: DateTime.now(),
    );
    _items[index] = updatedModel;

    return updatedModel.toEntity();
  }

  @override
  Future<StockItem> updateStatus(String id, StockItemStatus status) async {
    await _simulateNetworkDelay();

    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) {
      throw Exception('Article non trouvé');
    }

    // Met à jour le statut et la date
    _items[index] = _items[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    return _items[index].toEntity();
  }

  @override
  Future<StockItem> createStockItem(StockItem item) async {
    await _simulateNetworkDelay();

    // Validation simple côté repository (en plus du use case)
    if (item.name.trim().isEmpty) {
      throw Exception("Le nom de l'article est requis");
    }
    if (item.sku.trim().isEmpty) {
      throw Exception('Le SKU est requis');
    }
    if (_items.any((m) => m.sku.toLowerCase() == item.sku.toLowerCase())) {
      throw Exception('Un article avec ce SKU existe déjà');
    }

    // Génération d'un ID unique mock
    final newId = 'item_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(9999)}';

    final model = StockItemModel.fromEntity(
      item.copyWith(
        id: newId,
        updatedAt: DateTime.now(),
        status: item.status, // conserve le statut passé (actif par défaut)
      ),
    );

    _items.insert(0, model);
    return model.toEntity();
  }

  @override
  Future<bool> deleteItem(String id) async {
    await _simulateNetworkDelay();

    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) {
      return false;
    }

    _items.removeAt(index);
    return true;
  }

  /// Applique les filtres sur la liste d'articles
  List<StockItemModel> _applyFilters(
    List<StockItemModel> items,
    StockItemsFilter filter,
  ) {
    var filtered = items;

    // Filtre par terme de recherche (nom ou SKU)
    if (filter.searchQuery?.isNotEmpty ?? false) {
      final query = filter.searchQuery!.toLowerCase();
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.sku.toLowerCase().contains(query);
      }).toList();
    }

    // Filtre par statut
    if (filter.status != null) {
      filtered = filtered.where((item) => item.status == filter.status).toList();
    }

    // Filtre par catégorie
    if (filter.category?.isNotEmpty ?? false) {
      filtered = filtered
          .where((item) => item.category == filter.category)
          .toList();
    }

    return filtered;
  }

  /// Applique le tri sur la liste d'articles
  List<StockItemModel> _applySorting(
    List<StockItemModel> items,
    StockSortOption sortBy,
  ) {
    final sorted = List<StockItemModel>.from(items);

    switch (sortBy) {
      case StockSortOption.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case StockSortOption.nameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
      case StockSortOption.quantityAsc:
        sorted.sort((a, b) => a.quantity.compareTo(b.quantity));
      case StockSortOption.quantityDesc:
        sorted.sort((a, b) => b.quantity.compareTo(a.quantity));
      case StockSortOption.updatedDesc:
        sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case StockSortOption.priceAsc:
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case StockSortOption.priceDesc:
        sorted.sort((a, b) => b.price.compareTo(a.price));
    }

    return sorted;
  }

  /// Simule un délai réseau variable
  Future<void> _simulateNetworkDelay() async {
    final delay = 300 + _random.nextInt(700); // 300-1000ms
    await Future<void>.delayed(Duration(milliseconds: delay));
  }

  /// Initialise les données de test
  void _initializeMockData() {
    final now = DateTime.now();

    _items.addAll([
      // Fruits & Légumes
      StockItemModel(
        id: 'fruit_001',
        name: 'Pommes Gala',
        sku: 'FRT-POMME-001',
        category: 'Fruits',
        price: 2.50,
        quantity: 25,
        unit: 'kg',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(hours: 2)),
        description: 'Pommes Gala fraîches de producteurs locaux',
      ),
      StockItemModel(
        id: 'fruit_002',
        name: 'Bananes bio',
        sku: 'FRT-BANANE-002',
        category: 'Fruits',
        price: 3.20,
        quantity: 18,
        unit: 'kg',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(hours: 1)),
        description: 'Bananes biologiques équitables',
      ),
      StockItemModel(
        id: 'leg_001',
        name: 'Carottes',
        sku: 'LEG-CAROTTE-001',
        category: 'Légumes',
        price: 1.80,
        quantity: 0, // Rupture de stock
        unit: 'kg',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(hours: 3)),
        description: 'Carottes fraîches du potager',
      ),
      StockItemModel(
        id: 'leg_002',
        name: 'Tomates cerises',
        sku: 'LEG-TOMATE-002',
        category: 'Légumes',
        price: 4.50,
        quantity: 12,
        unit: 'barquette',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),

      // Plats préparés
      StockItemModel(
        id: 'plat_001',
        name: 'Lasagnes veggie',
        sku: 'PLT-LASAGNE-001',
        category: 'Plats',
        price: 8.90,
        quantity: 6,
        unit: 'portion',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(hours: 4)),
        description: 'Lasagnes végétariennes maison',
      ),
      StockItemModel(
        id: 'plat_002',
        name: 'Curry de lentilles',
        sku: 'PLT-CURRY-002',
        category: 'Plats',
        price: 6.50,
        unit: 'portion',
        quantity: 8,
        status: StockItemStatus.inactive, // Article inactif
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),

      // Boulangerie
      StockItemModel(
        id: 'boul_001',
        name: 'Pain complet',
        sku: 'BOUL-PAIN-001',
        category: 'Boulangerie',
        price: 2.10,
        quantity: 15,
        unit: 'unité',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(minutes: 45)),
        description: 'Pain complet au levain naturel',
      ),
      StockItemModel(
        id: 'boul_002',
        name: 'Croissants',
        sku: 'BOUL-CROIS-002',
        category: 'Boulangerie',
        price: 1.30,
        quantity: 24,
        unit: 'unité',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(hours: 1)),
        description: 'Croissants au beurre artisanaux',
      ),

      // Boissons
      StockItemModel(
        id: 'bois_001',
        name: 'Jus d\'orange frais',
        sku: 'BOIS-JUS-001',
        category: 'Boissons',
        price: 3.80,
        quantity: 10,
        unit: 'bouteille',
        status: StockItemStatus.inactive, // Article inactif
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
      StockItemModel(
        id: 'bois_002',
        name: 'Smoothie vert',
        sku: 'BOIS-SMOOTH-002',
        category: 'Boissons',
        price: 4.20,
        quantity: 7,
        unit: 'bouteille',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(minutes: 15)),
        description: 'Smoothie épinards, pomme, banane',
      ),

      // Articles épuisés ou problématiques
      StockItemModel(
        id: 'div_001',
        name: 'Miel artisanal',
        sku: 'DIV-MIEL-001',
        category: 'Épicerie',
        price: 12.50,
        quantity: 0, // Épuisé
        unit: 'pot',
        status: StockItemStatus.active,
        updatedAt: now.subtract(const Duration(days: 1)),
        description: 'Miel de fleurs locales',
      ),
      StockItemModel(
        id: 'div_002',
        name: 'Confiture fraise',
        sku: 'DIV-CONF-002',
        category: 'Épicerie',
        price: 5.90,
        quantity: 3,
        unit: 'pot',
        status: StockItemStatus.inactive,
        updatedAt: now.subtract(const Duration(hours: 8)),
        description: 'Confiture de fraises maison',
      ),
    ]);
  }
}