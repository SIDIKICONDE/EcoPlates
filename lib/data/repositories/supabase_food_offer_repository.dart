import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<Either<Failure, List<FoodOffer>>> getUrgentOffers() async {
    try {
      final query = _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('''
            *,
            merchant:merchants!inner(
              id,
              business_name,
              logo_url,
              rating,
              total_reviews,
              addresses!inner(
                latitude,
                longitude,
                address_line1,
                address_line2,
                city,
                postal_code
              )
            )
          ''')
          .eq('is_urgent', true)
          .eq('status', 'active')
          .gte('quantity_available', 1)
          .order('created_at', ascending: false)
          .limit(10);

      final response = await query;

      final offers = (response as List).map((json) {
        return _mapToFoodOffer(json as Map<String, dynamic>);
      }).toList();

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur getUrgentOffers: $e');
      return Left(
        ServerFailure('Erreur lors de la récupération des offres urgentes'),
      );
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getOffers({
    required int page,
    required int limit,
    String? categoryId,
    double? maxDistance,
    String? sortBy,
  }) async {
    try {
      final offset = (page - 1) * limit;

      final query = _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('''
            *,
            merchant:merchants!inner(
              id,
              business_name,
              logo_url,
              rating,
              total_reviews,
              addresses!inner(
                latitude,
                longitude,
                address_line1,
                address_line2,
                city,
                postal_code
              )
            )
          ''')
          .eq('status', 'active')
          .gte('quantity_available', 1);

      var filteredQuery = query;

      // Filtrer par catégorie
      if (categoryId != null) {
        filteredQuery = filteredQuery.eq('category_id', categoryId);
      }

      var rangedQuery = filteredQuery.range(offset, offset + limit - 1);

      // Trier selon le critère
      final orderedQuery = sortBy != null
          ? switch (sortBy) {
              'price_asc' => rangedQuery.order(
                'discounted_price',
                ascending: true,
              ),
              'price_desc' => rangedQuery.order(
                'discounted_price',
                ascending: false,
              ),
              'newest' => rangedQuery.order('created_at', ascending: false),
              _ => rangedQuery.order('created_at', ascending: false),
            }
          : rangedQuery.order('created_at', ascending: false);

      final response = await orderedQuery;

      final offers = (response as List).map((json) {
        return _mapToFoodOffer(json as Map<String, dynamic>);
      }).toList();

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur getOffers: $e');
      return Left(
        ServerFailure('Erreur lors de la récupération des offres'),
      );
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
              total_reviews,
              description,
              contact_phone,
              addresses!inner(
                latitude,
                longitude,
                address_line1,
                address_line2,
                city,
                postal_code
              )
            )
          ''')
          .eq('id', offerId)
          .single();

      final offer = _mapToFoodOffer(response);

      // Incrémenter le compteur de vues
      await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .update({'views_count': offer.viewCount + 1})
          .eq('id', offerId);

      return Right(offer);
    } catch (e) {
      debugPrint('Erreur getOfferById: $e');
      return Left(
        ServerFailure('Erreur lors de la récupération de l\'offre'),
      );
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getRecommendedOffers(
    String userId,
  ) async {
    try {
      // Récupérer les préférences de l'utilisateur si disponibles
      // Pour l'instant, on retourne les offres les plus populaires

      final query = _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('''
            *,
            merchant:merchants!inner(
              id,
              business_name,
              logo_url,
              rating,
              total_reviews,
              is_featured,
              addresses!inner(
                latitude,
                longitude,
                address_line1,
                address_line2,
                city,
                postal_code
              )
            )
          ''')
          .eq('status', 'active')
          .gte('quantity_available', 1)
          .order('views_count', ascending: false)
          .order('saves_count', ascending: false)
          .limit(15);

      final response = await query;

      final offers = (response as List).map((json) {
        return _mapToFoodOffer(json as Map<String, dynamic>);
      }).toList();

      // Trier par rating pour mettre les mieux notés en premier
      offers.sort((a, b) => b.rating.compareTo(a.rating));

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur getRecommendedOffers: $e');
      return Left(
        ServerFailure('Erreur lors de la récupération des offres recommandées'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> reserveOffer({
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

      final availableQuantity = offerResponse['quantity_available'] as int;

      if (availableQuantity < quantity) {
        return Left(
          ValidationFailure('Quantité insuffisante disponible'),
        );
      }

      // Créer la réservation
      final reservationCode = _generateReservationCode();
      final totalPrice = (offerResponse['discounted_price'] as num) * quantity;

      await _supabase.from('reservations').insert({
        'user_id': userId,
        'food_offer_id': offerId,
        'quantity': quantity,
        'total_price': totalPrice,
        'status': 'pending',
        'reservation_code': reservationCode,
        'pickup_time': DateTime.now()
            .add(const Duration(hours: 1))
            .toIso8601String(),
        'expires_at': DateTime.now()
            .add(const Duration(minutes: 30))
            .toIso8601String(),
      });

      // Mettre à jour la quantité disponible
      await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .update({
            'quantity_available': availableQuantity - quantity,
            'quantity_sold': (offerResponse['quantity_sold'] ?? 0) + quantity,
          })
          .eq('id', offerId);

      return const Right(null);
    } catch (e) {
      debugPrint('Erreur reserveOffer: $e');
      return Left(
        ServerFailure('Erreur lors de la réservation de l\'offre'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cancelReservation(String reservationId) async {
    try {
      // Récupérer les détails de la réservation
      final reservationResponse = await _supabase
          .from('reservations')
          .select('food_offer_id, quantity, status')
          .eq('id', reservationId)
          .single();

      if (reservationResponse['status'] != 'pending') {
        return Left(
          ValidationFailure('Cette réservation ne peut pas être annulée'),
        );
      }

      // Annuler la réservation
      await _supabase
          .from('reservations')
          .update({
            'status': 'cancelled',
            'cancelled_at': DateTime.now().toIso8601String(),
          })
          .eq('id', reservationId);

      // Remettre la quantité disponible
      final offerId = reservationResponse['food_offer_id'];
      final quantity = reservationResponse['quantity'] as int;

      final offerResponse = await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .select('quantity_available, quantity_sold')
          .eq('id', offerId as String)
          .single();

      await _supabase
          .from(SupabaseConfig.foodOffersTable)
          .update({
            'quantity_available':
                (offerResponse['quantity_available'] as int) + quantity,
            'quantity_sold': math.max(
              0,
              (offerResponse['quantity_sold'] as int) - quantity,
            ),
          })
          .eq('id', offerId);

      return const Right(null);
    } catch (e) {
      debugPrint('Erreur cancelReservation: $e');
      return Left(
        ServerFailure('Erreur lors de l\'annulation de la réservation'),
      );
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> searchOffers({
    required String query,
    Map<String, dynamic>? filters,
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
              rating,
              total_reviews,
              addresses!inner(
                latitude,
                longitude,
                address_line1,
                address_line2,
                city,
                postal_code
              )
            )
          ''')
          .eq('status', 'active')
          .gte('quantity_available', 1);

      // Recherche textuelle
      if (query.isNotEmpty) {
        supabaseQuery = supabaseQuery.textSearch('title', query);
      }

      // Appliquer les filtres
      if (filters != null) {
        if (filters['categoryId'] != null) {
          supabaseQuery = supabaseQuery.eq(
            'category_id',
            filters['categoryId'] as String,
          );
        }
        if (filters['minPrice'] != null) {
          supabaseQuery = supabaseQuery.gte(
            'discounted_price',
            filters['minPrice'] as num,
          );
        }
        if (filters['maxPrice'] != null) {
          supabaseQuery = supabaseQuery.lte(
            'discounted_price',
            filters['maxPrice'] as num,
          );
        }
        if (filters['isVegetarian'] == true) {
          supabaseQuery = supabaseQuery.contains('dietary_info', {
            'vegetarian': true,
          });
        }
        if (filters['isVegan'] == true) {
          supabaseQuery = supabaseQuery.contains('dietary_info', {
            'vegan': true,
          });
        }
        if (filters['isHalal'] == true) {
          supabaseQuery = supabaseQuery.contains('dietary_info', {
            'halal': true,
          });
        }
      }

      final response = await supabaseQuery;

      final offers = (response as List).map((json) {
        return _mapToFoodOffer(json as Map<String, dynamic>);
      }).toList();

      return Right(offers);
    } catch (e) {
      debugPrint('Erreur searchOffers: $e');
      return Left(ServerFailure('Erreur lors de la recherche d\'offres'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheOffers(List<FoodOffer> offers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final offersJson = offers.map((offer) => offer.toJson()).toList();
      await prefs.setString('cached_offers', offersJson.toString());
      return const Right(null);
    } catch (e) {
      debugPrint('Erreur cacheOffers: $e');
      return Left(CacheFailure('Erreur lors de la mise en cache des offres'));
    }
  }

  @override
  Future<Either<Failure, List<FoodOffer>>> getCachedOffers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_offers');

      if (cachedData == null || cachedData.isEmpty) {
        return const Right([]);
      }

      // Parse le JSON string
      // Note: Une meilleure approche serait d'utiliser json.encode/decode
      return const Right([]);
    } catch (e) {
      debugPrint('Erreur getCachedOffers: $e');
      return Left(
        CacheFailure('Erreur lors de la récupération des offres en cache'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> syncOfflineData() async {
    try {
      // Implémentation basique de synchronisation
      // Récupérer les données locales et les synchroniser avec Supabase
      // Pour l'instant, retourner succès
      return const Right(null);
    } catch (e) {
      debugPrint('Erreur syncOfflineData: $e');
      return Left(
        ServerFailure('Erreur lors de la synchronisation des données'),
      );
    }
  }

  /// Mapper les données JSON vers l'entité FoodOffer
  FoodOffer _mapToFoodOffer(Map<String, dynamic> json) {
    final merchantData = json['merchant'] as Map<String, dynamic>? ?? {};
    final addressData =
        merchantData['addresses'] != null &&
            (merchantData['addresses'] as List).isNotEmpty
        ? (merchantData['addresses'] as List).first as Map<String, dynamic>
        : <String, dynamic>{};

    // Parser les heures de pickup
    var pickupStartTime = DateTime.now();
    var pickupEndTime = DateTime.now().add(const Duration(hours: 2));

    if (json['pickup_start_time'] != null && json['available_date'] != null) {
      try {
        final availableDate = DateTime.parse(json['available_date'] as String);
        final startTime = json['pickup_start_time'] as String;
        final endTime = json['pickup_end_time'] as String? ?? '23:59';

        // Extraire heures et minutes
        final startParts = startTime.split(':');
        final endParts = endTime.split(':');

        pickupStartTime = DateTime(
          availableDate.year,
          availableDate.month,
          availableDate.day,
          int.parse(startParts[0]),
          startParts.length > 1 ? int.parse(startParts[1]) : 0,
        );

        pickupEndTime = DateTime(
          availableDate.year,
          availableDate.month,
          availableDate.day,
          int.parse(endParts[0]),
          endParts.length > 1 ? int.parse(endParts[1]) : 0,
        );
      } catch (e) {
        debugPrint('Erreur parsing pickup times: $e');
      }
    }

    // Parser le status
    var status = OfferStatus.available;
    if (json['status'] != null) {
      final statusStr = json['status'] as String;
      status = OfferStatus.values.firstWhere(
        (s) => s.name == statusStr,
        orElse: () => OfferStatus.available,
      );
    }

    // Parser les informations diététiques
    final dietaryInfo = json['dietary_info'] as Map<String, dynamic>? ?? {};
    final isVegetarian = dietaryInfo['vegetarian'] as bool? ?? false;
    final isVegan = dietaryInfo['vegan'] as bool? ?? false;
    final isHalal = dietaryInfo['halal'] as bool? ?? false;

    return FoodOffer(
      id: json['id'] as String,
      merchantId:
          json['merchant_id'] as String? ?? merchantData['id'] as String? ?? '',
      merchantName: merchantData['business_name'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [],
      type: OfferType.panier, // Default type - panier surprise
      category: FoodCategory.autre, // Default category
      originalPrice: (json['original_price'] as num?)?.toDouble() ?? 0.0,
      discountedPrice: (json['discounted_price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity_available'] as int? ?? 0,
      pickupStartTime: pickupStartTime,
      pickupEndTime: pickupEndTime,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: status,
      location: Location(
        latitude: (addressData['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (addressData['longitude'] as num?)?.toDouble() ?? 0.0,
        address: addressData['address_line1'] as String? ?? '',
        city: addressData['city'] as String? ?? '',
        postalCode: addressData['postal_code'] as String? ?? '',
        additionalInfo: addressData['address_line2'] as String?,
      ),
      merchantAddress: addressData.isNotEmpty
          ? '${addressData['address_line1']}, ${addressData['city']}'
          : '',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      merchantLogo: merchantData['logo_url'] as String?,
      availableQuantity: json['quantity_available'] as int? ?? 0,
      totalQuantity: json['quantity_available'] as int? ?? 0,
      rating: (merchantData['rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: merchantData['total_reviews'] as int? ?? 0,
      preparationTime: 30,
      allergens: json['allergens'] != null
          ? List<String>.from(json['allergens'] as List)
          : [],
      isVegetarian: isVegetarian,
      isVegan: isVegan,
      isHalal: isHalal,
      co2Saved: 500, // Valeur par défaut
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
      nutritionalInfo: json['nutritional_info'] as Map<String, dynamic>?,
      viewCount: json['views_count'] as int? ?? 0,
      soldCount: json['quantity_sold'] as int? ?? 0,
      isFavorite: false, // À déterminer par une requête séparée
    );
  }

  /// Générer un code de réservation unique
  String _generateReservationCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp.remainder(10000);
    return 'RES-${timestamp.remainder(1000000)}-$random';
  }
}
