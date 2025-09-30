import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../domain/entities/stock_item.dart';
import '../../domain/repositories/stock_repository.dart';

/// Implémentation Supabase du repository de stock
///
/// Utilise Supabase pour la persistance réelle des articles de stock
class SupabaseStockRepository implements StockRepository {
  final SupabaseClient _supabase;

  SupabaseStockRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  @override
  Future<List<StockItem>> getStockItems({
    StockItemsFilter filter = StockItemsFilter.none,
    StockSortOption sortBy = StockSortOption.nameAsc,
  }) async {
    try {
      // Construire la requête Supabase
      final filteredQuery = _applyFilters(
        _supabase.from(SupabaseConfig.stockItemsTable).select(),
        filter,
      );

      // Appliquer le tri
      final query = _applySorting(filteredQuery, sortBy);

      final response = await query;

      // Mapper vers les entités du domaine
      final items = (response as List).map((json) {
        return _mapToStockItem(json as Map<String, dynamic>);
      }).toList();

      debugPrint('✅ ${items.length} articles de stock récupérés');
      return items;
    } catch (e) {
      debugPrint('❌ Erreur getStockItems: $e');
      rethrow;
    }
  }

  @override
  Future<StockItem?> getStockItemById(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.stockItemsTable)
          .select()
          .eq('id', id)
          .single();

      return _mapToStockItem(response);
    } catch (e) {
      debugPrint('❌ Erreur getStockItemById: $e');
      return null;
    }
  }

  @override
  Future<StockItem> updateStockItem(StockItem item) async {
    try {
      final updateData = {
        'name': item.name,
        'description': item.description,
        'sku': item.sku,
        'category': item.category,
        'price': item.price,
        'quantity': item.quantity,
        'unit': item.unit,
        'status': item.status.name,
        'low_stock_threshold': item.lowStockThreshold,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from(SupabaseConfig.stockItemsTable)
          .update(updateData)
          .eq('id', item.id)
          .select()
          .single();

      debugPrint('✅ Article de stock mis à jour: ${item.id}');
      return _mapToStockItem(response);
    } catch (e) {
      debugPrint('❌ Erreur updateStockItem: $e');
      throw Exception('Erreur lors de la mise à jour de l\'article: $e');
    }
  }

  @override
  Future<StockItem> adjustQuantity(String id, int delta) async {
    try {
      // Récupérer l'article actuel
      final current = await getStockItemById(id);
      if (current == null) {
        throw Exception('Article non trouvé: $id');
      }

      final newQuantity = current.quantity + delta;
      if (newQuantity < 0) {
        throw Exception(
          'Quantité insuffisante. Actuelle: ${current.quantity}, demandée: $delta',
        );
      }

      // Mettre à jour la quantité
      final response = await _supabase
          .from(SupabaseConfig.stockItemsTable)
          .update({
            'quantity': newQuantity,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      debugPrint('✅ Quantité ajustée pour $id: $delta');
      return _mapToStockItem(response);
    } catch (e) {
      debugPrint('❌ Erreur adjustQuantity: $e');
      rethrow;
    }
  }

  @override
  Future<StockItem> updateStatus(String id, StockItemStatus status) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.stockItemsTable)
          .update({
            'status': status.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      debugPrint('✅ Statut mis à jour pour $id: ${status.name}');
      return _mapToStockItem(response);
    } catch (e) {
      debugPrint('❌ Erreur updateStatus: $e');
      throw Exception('Erreur lors de la mise à jour du statut: $e');
    }
  }

  @override
  Future<StockItem> createStockItem(StockItem item) async {
    try {
      // Validation
      if (item.name.trim().isEmpty) {
        throw Exception('Le nom de l\'article est requis');
      }
      if (item.sku.trim().isEmpty) {
        throw Exception('Le SKU est requis');
      }

      // Vérifier l'unicité du SKU
      final existing = await _supabase
          .from(SupabaseConfig.stockItemsTable)
          .select('id')
          .eq('sku', item.sku)
          .maybeSingle();

      if (existing != null) {
        throw Exception('Un article avec ce SKU existe déjà');
      }

      // Obtenir l'ID du marchand depuis l'utilisateur connecté
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final merchantResponse = await _supabase
          .from('merchants')
          .select('id')
          .eq('user_id', userId)
          .single();

      final merchantId = merchantResponse['id'] as String;

      // Créer l'article
      final itemData = {
        'merchant_id': merchantId,
        'name': item.name,
        'description': item.description,
        'sku': item.sku,
        'category': item.category,
        'price': item.price,
        'quantity': item.quantity,
        'unit': item.unit,
        'status': item.status.name,
        'low_stock_threshold': item.lowStockThreshold,
      };

      final response = await _supabase
          .from(SupabaseConfig.stockItemsTable)
          .insert(itemData)
          .select()
          .single();

      debugPrint('✅ Article de stock créé: ${response['id']}');
      return _mapToStockItem(response);
    } catch (e) {
      debugPrint('❌ Erreur createStockItem: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteItem(String id) async {
    try {
      await _supabase
          .from(SupabaseConfig.stockItemsTable)
          .delete()
          .eq('id', id);

      debugPrint('✅ Article supprimé: $id');
      return true;
    } catch (e) {
      debugPrint('❌ Erreur deleteItem: $e');
      return false;
    }
  }

  /// Applique les filtres sur la requête Supabase
  PostgrestFilterBuilder<List<Map<String, dynamic>>> _applyFilters(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
    StockItemsFilter filter,
  ) {
    var filteredQuery = query;

    // Filtre par terme de recherche
    if (filter.searchQuery?.isNotEmpty ?? false) {
      filteredQuery = filteredQuery.or(
        'name.ilike.%${filter.searchQuery}%,sku.ilike.%${filter.searchQuery}%',
      );
    }

    // Filtre par statut
    if (filter.status != null) {
      filteredQuery = filteredQuery.eq('status', filter.status!.name);
    }

    // Filtre par catégorie
    if (filter.category?.isNotEmpty ?? false) {
      filteredQuery = filteredQuery.eq('category', filter.category!);
    }

    return filteredQuery;
  }

  /// Applique le tri sur la requête Supabase
  PostgrestTransformBuilder<List<Map<String, dynamic>>> _applySorting(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
    StockSortOption sortBy,
  ) {
    switch (sortBy) {
      case StockSortOption.nameAsc:
        return query.order('name', ascending: true);
      case StockSortOption.nameDesc:
        return query.order('name', ascending: false);
      case StockSortOption.quantityAsc:
        return query.order('quantity', ascending: true);
      case StockSortOption.quantityDesc:
        return query.order('quantity', ascending: false);
      case StockSortOption.updatedDesc:
        return query.order('updated_at', ascending: false);
      case StockSortOption.priceAsc:
        return query.order('price', ascending: true);
      case StockSortOption.priceDesc:
        return query.order('price', ascending: false);
    }
  }

  /// Mappe les données JSON vers l'entité StockItem
  StockItem _mapToStockItem(Map<String, dynamic> json) {
    // Parser le statut
    var status = StockItemStatus.active;
    if (json['status'] != null) {
      final statusStr = json['status'] as String;
      status = StockItemStatus.values.firstWhere(
        (s) => s.name == statusStr,
        orElse: () => StockItemStatus.active,
      );
    }

    return StockItem(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      unit: json['unit'] as String? ?? 'unité',
      status: status,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      description: json['description'] as String?,
      lowStockThreshold: json['low_stock_threshold'] as int?,
    );
  }
}
