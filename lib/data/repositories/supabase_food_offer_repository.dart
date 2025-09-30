import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/food_offer.dart';
import '../../domain/repositories/food_offer_repository.dart';

/// Implémentation Supabase du repository des offres alimentaires
class SupabaseFoodOfferRepository implements FoodOfferRepository {
  final SupabaseClient _supabase;

  SupabaseFoodOfferRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  @override
  Future<Either<Failure, List<FoodOffer>>> getUrgentOffers({
    int limit = 10,
    double? latitude,
    double? longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      var query = _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('''
            *,
            merchant:merchants!inner(
              id,
              business_name,
              logo_url,
              rating,
              addresses!inner(
                latitude,
                longitude,
                address_line1,
                city
              )
            ),
            category:categories(
              id,
              name,
              icon
            )
          ''')
          .eq('is_urgent', true)
          .eq('status', 'active')
          .gte('expiry_datetime', DateTime.now().toIso8601String())
          .order('created_at', ascending: false)
          .limit(limit);

      final response = await query;
      
      final offers = (response as List).map((json) {
        return _mapToFoodOffer(json);
      }).toList();

      // Filtrer par distance si latitude/longitude fournis
      if (latitude != null && longitude != null) {
        offers.removeWhere((offer) {
          final distance = _calculateDistance(
            latitude,
            longitude,
            offer.merchant.latitude ?? 0,
            offer.merchant.longitude ?? 0,
          );
          return distance > radiusKm;
        });
      }

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur getUrgentOffers: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getNearbyOffers({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
    int limit = 20,
  }) async {
    try {
      // Utiliser PostGIS pour la recherche géographique
      final response = await _supabase.rpc(
        'get_nearby_offers',
        params: {
          'user_lat': latitude,
          'user_lng': longitude,
          'radius_km': radiusKm,
          'limit_count': limit,
        },
      );

      final offers = (response as List).map((json) {
        return _mapToFoodOffer(json);
      }).toList();

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur getNearbyOffers: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getRecommendedOffers({
    String? userId,
    int limit = 15,
  }) async {
    try {
      var query = _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('''
            *,
            merchant:merchants!inner(
              id,
              business_name,
              logo_url,
              rating,
              is_featured
            ),
            category:categories(
              id,
              name,
              icon
            )
          ''')
          .eq('status', 'active')
          .gte('quantity_available', 1)
          .order('views_count', ascending: false)
          .order('saves_count', ascending: false)
          .limit(limit);

      // Prioriser les marchands featured
      final response = await query;
      
      final offers = (response as List).map((json) {
        return _mapToFoodOffer(json);
      }).toList();

      // Trier pour mettre les marchands featured en premier
      offers.sort((a, b) {
        if (a.merchant.isFeatured && !b.merchant.isFeatured) return -1;
        if (!a.merchant.isFeatured && b.merchant.isFeatured) return 1;
        return 0;
      });

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur getRecommendedOffers: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> searchOffers({
    required String query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    List<String>? dietaryPreferences,
  }) async {
    try {
      var supabaseQuery = _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('''
            *,
            merchant:merchants!inner(
              id,
              business_name,
              logo_url,
              rating
            ),
            category:categories(
              id,
              name,
              icon
            )
          ''')
          .eq('status', 'active')
          .gte('quantity_available', 1);

      // Recherche textuelle
      if (query.isNotEmpty) {
        supabaseQuery = supabaseQuery.textSearch('title', query);
      }

      // Filtres
      if (categoryId != null) {
        supabaseQuery = supabaseQuery.eq('category_id', categoryId);
      }
      if (minPrice != null) {
        supabaseQuery = supabaseQuery.gte('discounted_price', minPrice);
      }
      if (maxPrice != null) {
        supabaseQuery = supabaseQuery.lte('discounted_price', maxPrice);
      }

      final response = await supabaseQuery;
      
      var offers = (response as List).map((json) {
        return _mapToFoodOffer(json);
      }).toList();

      // Filtrer par préférences alimentaires
      if (dietaryPreferences != null && dietaryPreferences.isNotEmpty) {
        offers = offers.where((offer) {
          final offerDietary = offer.dietaryInfo ?? [];
          return dietaryPreferences.any((pref) => offerDietary.contains(pref));
        }).toList();
      }

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur searchOffers: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, FoodOffer>> getOfferById(String offerId) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('''
            *,
            merchant:merchants!inner(
              id,
              business_name,
              logo_url,
              rating,
              description,
              contact_phone,
              addresses!inner(
                latitude,
                longitude,
                address_line1,
                city
              )
            ),
            category:categories(
              id,
              name,
              icon
            )
          ''')
          .eq('id', offerId)
          .single();

      final offer = _mapToFoodOffer(response);
      
      // Incrémenter le compteur de vues
      await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .update({'views_count': offer.viewsCount + 1})
          .eq('id', offerId);

      return Right(offer);
    } catch (e) {
      debugPrint('Erreur getOfferById: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getOffersByMerchant(
    String merchantId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final offset = (page - 1) * limit;
      
      final response = await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('''
            *,
            merchant:merchants!inner(
              id,
              business_name,
              logo_url,
              rating
            ),
            category:categories(
              id,
              name,
              icon
            )
          ''')
          .eq('merchant_id', merchantId)
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final offers = (response as List).map((json) {
        return _mapToFoodOffer(json);
      }).toList();

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur getOffersByMerchant: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> reserveOffer({
    required String offerId,
    required String userId,
    required int quantity,
  }) async {
    try {
      // Vérifier la disponibilité
      final offerResponse = await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('quantity_available, discounted_price')
          .eq('id', offerId)
          .single();

      final availableQty = offerResponse['quantity_available'] as int;
      final price = offerResponse['discounted_price'] as double;

      if (availableQty < quantity) {
        return Left(ValidationFailure('Quantité insuffisante'));
      }

      // Créer la réservation
      await _supabase.from(SupabaseConfig.reservationsTable).insert({
        'user_id': userId,
        'food_offer_id': offerId,
        'quantity': quantity,
        'total_price': price * quantity,
        'status': 'pending',
        'reservation_code': _generateReservationCode(),
        'expires_at': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      });

      // Mettre à jour la quantité disponible
      await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .update({'quantity_available': availableQty - quantity})
          .eq('id', offerId);

      return const Right(true);
    } catch (e) {
      debugPrint('Erreur reserveOffer: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> cancelReservation({
    required String reservationId,
    required String userId,
    String? reason,
  }) async {
    try {
      // Récupérer la réservation
      final reservation = await _supabase
          .from(SupabaseConfig.reservationsTable)
          .select('food_offer_id, quantity')
          .eq('id', reservationId)
          .eq('user_id', userId)
          .single();

      // Annuler la réservation
      await _supabase
          .from(SupabaseConfig.reservationsTable)
          .update({
            'status': 'cancelled',
            'cancelled_at': DateTime.now().toIso8601String(),
            'cancellation_reason': reason,
          })
          .eq('id', reservationId);

      // Remettre la quantité disponible
      await _supabase.rpc(
        'increment_offer_quantity',
        params: {
          'offer_id': reservation['food_offer_id'],
          'quantity': reservation['quantity'],
        },
      );

      return const Right(true);
    } catch (e) {
      debugPrint('Erreur cancelReservation: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite({
    required String offerId,
    required String userId,
  }) async {
    try {
      // Vérifier si déjà en favoris
      final existing = await _supabase
          .from(SupabaseConfig.favoritesTable)
          .select('id')
          .eq('user_id', userId)
          .eq('food_offer_id', offerId)
          .maybeSingle();

      if (existing != null) {
        // Supprimer des favoris
        await _supabase
            .from(SupabaseConfig.favoritesTable)
            .delete()
            .eq('id', existing['id']);

        // Décrémenter le compteur
        await _supabase.rpc(
          'decrement_saves_count',
          params: {'offer_id': offerId},
        );

        return const Right(false);
      } else {
        // Ajouter aux favoris
        await _supabase.from(SupabaseConfig.favoritesTable).insert({
          'user_id': userId,
          'food_offer_id': offerId,
        });

        // Incrémenter le compteur
        await _supabase.rpc(
          'increment_saves_count',
          params: {'offer_id': offerId},
        );

        return const Right(true);
      }
    } catch (e) {
      debugPrint('Erreur toggleFavorite: $e');
      return Left(ServerFailure());
    }
  }

  /// Mapper les données JSON vers l'entité FoodOffer
  FoodOffer _mapToFoodOffer(Map<String, dynamic> json) {
    final merchantData = json['merchant'] as Map<String, dynamic>;
    final addressData = merchantData['addresses'] != null && 
                       (merchantData['addresses'] as List).isNotEmpty
        ? (merchantData['addresses'] as List).first
        : null;

    return FoodOffer(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      images: List<String>.from(json['images'] ?? []),
      originalPrice: (json['original_price'] as num).toDouble(),
      discountedPrice: (json['discounted_price'] as num).toDouble(),
      discountPercentage: json['discount_percentage'] as int? ?? 0,
      quantityAvailable: json['quantity_available'] as int,
      quantitySold: json['quantity_sold'] as int? ?? 0,
      pickupStartTime: json['pickup_start_time'] as String?,
      pickupEndTime: json['pickup_end_time'] as String?,
      availableDate: json['available_date'] != null
          ? DateTime.parse(json['available_date'] as String)
          : null,
      expiryDateTime: json['expiry_datetime'] != null
          ? DateTime.parse(json['expiry_datetime'] as String)
          : null,
      isUrgent: json['is_urgent'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      merchant: Merchant(
        id: merchantData['id'] as String,
        name: merchantData['business_name'] as String,
        logoUrl: merchantData['logo_url'] as String?,
        rating: (merchantData['rating'] as num?)?.toDouble() ?? 0.0,
        address: addressData != null
            ? '${addressData['address_line1']}, ${addressData['city']}'
            : '',
        latitude: (addressData?['latitude'] as num?)?.toDouble(),
        longitude: (addressData?['longitude'] as num?)?.toDouble(),
        isFeatured: merchantData['is_featured'] as bool? ?? false,
      ),
      category: json['category'] != null
          ? FoodCategory(
              id: json['category']['id'] as String,
              name: json['category']['name'] as String,
              icon: json['category']['icon'] as String?,
            )
          : null,
      allergens: List<String>.from(json['allergens'] ?? []),
      dietaryInfo: List<String>.from(
        (json['dietary_info'] as Map<String, dynamic>? ?? {})
            .entries
            .where((e) => e.value == true)
            .map((e) => e.key),
      ),
      tags: List<String>.from(json['tags'] ?? []),
      viewsCount: json['views_count'] as int? ?? 0,
      savesCount: json['saves_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Calculer la distance entre deux points géographiques
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    
    final double a = 
        (dLat / 2).sin() * (dLat / 2).sin() +
        _toRadians(lat1).cos() *
        _toRadians(lat2).cos() *
        (dLon / 2).sin() *
        (dLon / 2).sin();
    
    final double c = 2 * a.sqrt().asin();
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (3.141592653589793238 / 180);
  }

  /// Générer un code de réservation unique
  String _generateReservationCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp.remainder(10000);
    return 'RES-${timestamp.remainder(1000000)}-$random';
  }
}

// Extension du domaine si nécessaire
class Merchant {
  final String id;
  final String name;
  final String? logoUrl;
  final double rating;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool isFeatured;

  Merchant({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.rating,
    required this.address,
    this.latitude,
    this.longitude,
    this.isFeatured = false,
  });
}

class FoodCategory {
  final String id;
  final String name;
  final String? icon;

  FoodCategory({
    required this.id,
    required this.name,
    this.icon,
  });
}