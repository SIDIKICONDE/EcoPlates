import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/services/geo_location_service.dart';
import '../../domain/entities/food_offer.dart';
import './offers_catalog_provider.dart';

/// État du formulaire d'offre
class OfferFormState {
  const OfferFormState({
    this.title = '',
    this.description = '',
    this.images = const [],
    this.type = OfferType.panier,
    this.customType,
    this.category = FoodCategory.diner,
    this.customCategory,
    this.originalPrice = 0.0,
    this.discountedPrice = 0.0,
    this.quantity = 1,
    this.pickupStartTime,
    this.pickupEndTime,
    this.status = OfferStatus.draft,
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isHalal = false,
    this.co2Saved = 500,
    this.tags = const [],
    this.nutritionalInfo,
    this.preparationTime = 30,
    this.isSubmitting = false,
    this.hasChanges = false,
  });

  final String title;
  final String description;
  final List<String> images;
  final OfferType type;
  final String? customType; // Type d'offre personnalisé
  final FoodCategory category;
  final String? customCategory; // Catégorie alimentaire personnalisée
  final double originalPrice;
  final double discountedPrice;
  final int quantity;
  final TimeOfDay? pickupStartTime;
  final TimeOfDay? pickupEndTime;
  final OfferStatus status;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isHalal;
  final int co2Saved;
  final List<String> tags;
  final Map<String, dynamic>? nutritionalInfo;
  final int preparationTime;
  final bool isSubmitting;
  final bool hasChanges;

  OfferFormState copyWith({
    String? title,
    String? description,
    List<String>? images,
    OfferType? type,
    String? customType,
    FoodCategory? category,
    String? customCategory,
    double? originalPrice,
    double? discountedPrice,
    int? quantity,
    TimeOfDay? pickupStartTime,
    TimeOfDay? pickupEndTime,
    OfferStatus? status,
    List<String>? allergens,
    bool? isVegetarian,
    bool? isVegan,
    bool? isHalal,
    int? co2Saved,
    List<String>? tags,
    Map<String, dynamic>? nutritionalInfo,
    int? preparationTime,
    bool? isSubmitting,
    bool? hasChanges,
  }) {
    return OfferFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      type: type ?? this.type,
      customType: customType ?? this.customType,
      category: category ?? this.category,
      customCategory: customCategory ?? this.customCategory,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      quantity: quantity ?? this.quantity,
      pickupStartTime: pickupStartTime ?? this.pickupStartTime,
      pickupEndTime: pickupEndTime ?? this.pickupEndTime,
      status: status ?? this.status,
      allergens: allergens ?? this.allergens,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isHalal: isHalal ?? this.isHalal,
      co2Saved: co2Saved ?? this.co2Saved,
      tags: tags ?? this.tags,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      preparationTime: preparationTime ?? this.preparationTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  // Validation
  bool get isValid {
    return title.trim().isNotEmpty &&
        description.trim().isNotEmpty &&
        images.isNotEmpty &&
        originalPrice > 0 &&
        discountedPrice >= 0 &&
        quantity > 0 &&
        pickupStartTime != null &&
        pickupEndTime != null;
  }

  // Calcul du pourcentage de réduction
  double get discountPercentage {
    if (originalPrice == 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice * 100)
        .roundToDouble();
  }

  // Vérifie si c'est gratuit
  bool get isFree => discountedPrice == 0;
}

/// Provider pour l'état du formulaire d'offre
final offerFormProvider =
    StateNotifierProvider<OfferFormNotifier, OfferFormState>(
      (ref) => OfferFormNotifier(ref),
    );

class OfferFormNotifier extends StateNotifier<OfferFormState> {
  OfferFormNotifier(this.ref) : super(const OfferFormState());
  final Ref ref;

  /// Réinitialise le formulaire avec des valeurs par défaut
  void resetForm() {
    state = const OfferFormState();
  }

  /// Charge une offre existante dans le formulaire
  void loadOffer(FoodOffer offer) {
    state = OfferFormState(
      title: offer.title,
      description: offer.description,
      images: offer.images,
      type: offer.type,
      category: offer.category,
      originalPrice: offer.originalPrice,
      discountedPrice: offer.discountedPrice,
      quantity: offer.quantity,
      pickupStartTime: TimeOfDay.fromDateTime(offer.pickupStartTime),
      pickupEndTime: TimeOfDay.fromDateTime(offer.pickupEndTime),
      status: offer.status,
      allergens: offer.allergens,
      isVegetarian: offer.isVegetarian,
      isVegan: offer.isVegan,
      isHalal: offer.isHalal,
      co2Saved: offer.co2Saved,
      tags: offer.tags,
      nutritionalInfo: offer.nutritionalInfo,
      preparationTime: offer.preparationTime,
    );
  }

  /// Met à jour les champs du formulaire

  void updateTitle(String title) {
    state = state.copyWith(title: title, hasChanges: true);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description, hasChanges: true);
  }

  void updateImages(List<String> images) {
    state = state.copyWith(images: images, hasChanges: true);
  }

  void updateType(OfferType type) {
    // Si on choisit un type prédéfini (autre que "autre"), on efface le type personnalisé
    final newCustomType = (type != OfferType.autre) ? null : state.customType;
    state = state.copyWith(
      type: type,
      customType: newCustomType,
      hasChanges: true,
    );
  }

  void updateCustomType(String? customType) {
    state = state.copyWith(customType: customType, hasChanges: true);
  }

  void updateCustomCategory(String? customCategory) {
    state = state.copyWith(customCategory: customCategory, hasChanges: true);
  }

  void updateCategory(FoodCategory category) {
    // Si on choisit une catégorie prédéfinie, on efface la catégorie personnalisée
    final newCustomCategory = (category != FoodCategory.autre)
        ? null
        : state.customCategory;
    state = state.copyWith(
      category: category,
      customCategory: newCustomCategory,
      hasChanges: true,
    );
  }

  void updateOriginalPrice(double price) {
    state = state.copyWith(originalPrice: price, hasChanges: true);
  }

  void updateDiscountedPrice(double price) {
    state = state.copyWith(discountedPrice: price, hasChanges: true);
  }

  void updateQuantity(int quantity) {
    state = state.copyWith(quantity: quantity, hasChanges: true);
  }

  void updatePickupStartTime(TimeOfDay time) {
    state = state.copyWith(pickupStartTime: time, hasChanges: true);
  }

  void updatePickupEndTime(TimeOfDay time) {
    state = state.copyWith(pickupEndTime: time, hasChanges: true);
  }

  void updateStatus(OfferStatus status) {
    state = state.copyWith(status: status, hasChanges: true);
  }

  void updateAllergens(List<String> allergens) {
    state = state.copyWith(allergens: allergens, hasChanges: true);
  }

  void toggleVegetarian() {
    state = state.copyWith(isVegetarian: !state.isVegetarian, hasChanges: true);
  }

  void toggleVegan() {
    state = state.copyWith(isVegan: !state.isVegan, hasChanges: true);
  }

  void toggleHalal() {
    state = state.copyWith(isHalal: !state.isHalal, hasChanges: true);
  }

  void updateCo2Saved(int co2) {
    state = state.copyWith(co2Saved: co2, hasChanges: true);
  }

  void updateTags(List<String> tags) {
    state = state.copyWith(tags: tags, hasChanges: true);
  }

  void updatePreparationTime(int time) {
    state = state.copyWith(preparationTime: time, hasChanges: true);
  }

  /// Crée une nouvelle offre
  Future<void> createOffer() async {
    if (!state.isValid) {
      throw Exception('Formulaire invalide');
    }

    state = state.copyWith(isSubmitting: true);

    try {
      // Obtenir la position actuelle pour la localisation
      final position = await _getCurrentLocation();

      if (position == null) {
        throw Exception('Impossible d\'obtenir la position actuelle');
      }

      final offer = FoodOffer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        // IMPORTANT: le Store filtre sur merchantId == 'merchant1'
        merchantId: 'merchant1',
        merchantName: 'Le Petit Bistrot',
        title: state.title.trim(),
        description: state.description.trim(),
        images: state.images,
        type: state.type,
        category: state.category,
        originalPrice: state.originalPrice,
        discountedPrice: state.discountedPrice,
        quantity: state.quantity,
        pickupStartTime: _combineDateTime(
          DateTime.now(),
          state.pickupStartTime!,
        ),
        pickupEndTime: _combineDateTime(
          DateTime.now(),
          state.pickupEndTime!,
        ),
        createdAt: DateTime.now(),
        status: state.status,
        location: Location(
          latitude: position.latitude,
          longitude: position.longitude,
          address: 'Adresse du commerçant',
          city: 'Ville',
          postalCode: 'Code postal',
        ),
        merchantAddress: 'Adresse complète',
        allergens: state.allergens,
        isVegetarian: state.isVegetarian,
        isVegan: state.isVegan,
        isHalal: state.isHalal,
        co2Saved: state.co2Saved,
        tags: state.tags,
        nutritionalInfo: state.nutritionalInfo,
        preparationTime: state.preparationTime,
        updatedAt: DateTime.now(),
      );

      // Écrit directement dans le catalogue partagé
      ref.read(offersCatalogProvider.notifier).upsert(offer);
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  /// Met à jour une offre existante
  Future<void> updateOffer(String offerId) async {
    if (!state.isValid) {
      throw Exception('Formulaire invalide');
    }

    state = state.copyWith(isSubmitting: true);

    try {
      // Récupère l'offre existante depuis le catalogue
      final catalog = ref.read(offersCatalogProvider);
      final existingIndex = catalog.indexWhere((o) => o.id == offerId);
      
      if (existingIndex == -1) {
        throw Exception(
          'Cette offre n\'existe plus dans le catalogue. '
          'Elle a peut-être été supprimée par un autre utilisateur. '
          'Veuillez actualiser la page et réessayer.',
        );
      }
      
      final existing = catalog[existingIndex];

      final updated = existing.copyWith(
        title: state.title.trim(),
        description: state.description.trim(),
        images: state.images,
        type: state.type,
        category: state.category,
        originalPrice: state.originalPrice,
        discountedPrice: state.discountedPrice,
        quantity: state.quantity,
        pickupStartTime: _combineDateTime(
          DateTime.now(),
          state.pickupStartTime!,
        ),
        pickupEndTime: _combineDateTime(
          DateTime.now(),
          state.pickupEndTime!,
        ),
        status: state.status,
        allergens: state.allergens,
        isVegetarian: state.isVegetarian,
        isVegan: state.isVegan,
        isHalal: state.isHalal,
        co2Saved: state.co2Saved,
        tags: state.tags,
        nutritionalInfo: state.nutritionalInfo,
        preparationTime: state.preparationTime,
        updatedAt: DateTime.now(),
      );

      ref.read(offersCatalogProvider.notifier).upsert(updated);
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  /// Supprime une offre
  Future<void> deleteOffer(String offerId) async {
    ref.read(offersCatalogProvider.notifier).delete(offerId);
  }

  /// Obtient la position actuelle
  Future<Position?> _getCurrentLocation() async {
    return await GeoLocationService.instance.getCurrentPosition();
  }

  /// Combine une date et une heure
  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
