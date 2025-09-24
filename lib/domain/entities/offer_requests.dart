import 'food_offer.dart';

/// Requête de création d'offre
class CreateOfferRequest {
  final String title;
  final String description;
  final OfferType type;
  final FoodCategory category;
  final double originalPrice;
  final double discountedPrice;
  final int quantity;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final List<String> images;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isHalal;

  const CreateOfferRequest({
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.originalPrice,
    required this.discountedPrice,
    required this.quantity,
    required this.pickupStartTime,
    required this.pickupEndTime,
    this.images = const [],
    this.allergens = const [],
    this.isVegetarian = false,
    this.isVegan = false,
    this.isHalal = false,
  });

  /// Valide les données de la requête
  String? validate() {
    if (title.isEmpty) return 'Le titre est obligatoire';
    if (description.isEmpty) return 'La description est obligatoire';
    if (originalPrice < 0) return 'Le prix original ne peut pas être négatif';
    if (discountedPrice < 0) return 'Le prix réduit ne peut pas être négatif';
    if (discountedPrice > originalPrice) {
      return 'Le prix réduit ne peut pas être supérieur au prix original';
    }
    if (quantity <= 0) return 'La quantité doit être supérieure à 0';
    if (pickupStartTime.isAfter(pickupEndTime)) {
      return 'L\'heure de début doit être antérieure à l\'heure de fin';
    }
    if (pickupEndTime.isBefore(DateTime.now())) {
      return 'L\'heure de fin doit être dans le futur';
    }
    return null;
  }
}

/// Requête de mise à jour d'offre
class UpdateOfferRequest {
  final String? title;
  final String? description;
  final OfferType? type;
  final FoodCategory? category;
  final double? originalPrice;
  final double? discountedPrice;
  final int? quantity;
  final DateTime? pickupStartTime;
  final DateTime? pickupEndTime;
  final List<String>? images;
  final List<String>? allergens;
  final bool? isVegetarian;
  final bool? isVegan;
  final bool? isHalal;
  final OfferStatus? status;

  const UpdateOfferRequest({
    this.title,
    this.description,
    this.type,
    this.category,
    this.originalPrice,
    this.discountedPrice,
    this.quantity,
    this.pickupStartTime,
    this.pickupEndTime,
    this.images,
    this.allergens,
    this.isVegetarian,
    this.isVegan,
    this.isHalal,
    this.status,
  });

  /// Vérifie si la requête contient des modifications
  bool get hasUpdates {
    return title != null ||
        description != null ||
        type != null ||
        category != null ||
        originalPrice != null ||
        discountedPrice != null ||
        quantity != null ||
        pickupStartTime != null ||
        pickupEndTime != null ||
        images != null ||
        allergens != null ||
        isVegetarian != null ||
        isVegan != null ||
        isHalal != null ||
        status != null;
  }

  /// Valide les données de la requête
  String? validate() {
    if (title != null && title!.isEmpty) return 'Le titre ne peut pas être vide';
    if (description != null && description!.isEmpty) {
      return 'La description ne peut pas être vide';
    }
    if (originalPrice != null && originalPrice! < 0) {
      return 'Le prix original ne peut pas être négatif';
    }
    if (discountedPrice != null && discountedPrice! < 0) {
      return 'Le prix réduit ne peut pas être négatif';
    }
    if (originalPrice != null && discountedPrice != null && 
        discountedPrice! > originalPrice!) {
      return 'Le prix réduit ne peut pas être supérieur au prix original';
    }
    if (quantity != null && quantity! <= 0) {
      return 'La quantité doit être supérieure à 0';
    }
    if (pickupStartTime != null && pickupEndTime != null &&
        pickupStartTime!.isAfter(pickupEndTime!)) {
      return 'L\'heure de début doit être antérieure à l\'heure de fin';
    }
    if (pickupEndTime != null && pickupEndTime!.isBefore(DateTime.now())) {
      return 'L\'heure de fin doit être dans le futur';
    }
    return null;
  }

  /// Convertit la requête en Map pour l'API
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    
    if (title != null) json['title'] = title;
    if (description != null) json['description'] = description;
    if (type != null) json['type'] = type!.name;
    if (category != null) json['category'] = category!.name;
    if (originalPrice != null) json['originalPrice'] = originalPrice;
    if (discountedPrice != null) json['discountedPrice'] = discountedPrice;
    if (quantity != null) json['quantity'] = quantity;
    if (pickupStartTime != null) json['pickupStartTime'] = pickupStartTime!.toIso8601String();
    if (pickupEndTime != null) json['pickupEndTime'] = pickupEndTime!.toIso8601String();
    if (images != null) json['images'] = images;
    if (allergens != null) json['allergens'] = allergens;
    if (isVegetarian != null) json['isVegetarian'] = isVegetarian;
    if (isVegan != null) json['isVegan'] = isVegan;
    if (isHalal != null) json['isHalal'] = isHalal;
    if (status != null) json['status'] = status!.name;
    
    return json;
  }
}