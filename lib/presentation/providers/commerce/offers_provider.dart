import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../data/services/food_offer_service.dart';

/// Provider pour le service des offres
final foodOfferServiceProvider = Provider<FoodOfferService>((ref) {
  return FoodOfferService();
});

/// Position de l'utilisateur
class UserLocation {
  final double latitude;
  final double longitude;

  const UserLocation({
    required this.latitude,
    required this.longitude,
  });
}

/// Provider pour la position de l'utilisateur
final userLocationProvider = StateProvider<UserLocation?>((ref) => null);

/// Provider simple pour récupérer toutes les offres disponibles
final allOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final offerService = ref.watch(foodOfferServiceProvider);
  final userLocation = ref.watch(userLocationProvider);
  
  return await offerService.getAvailableOffers(
    latitude: userLocation?.latitude,
    longitude: userLocation?.longitude,
  );
});

/// Provider pour les offres à proximité (5km par défaut)
final nearbyOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final offerService = ref.watch(foodOfferServiceProvider);
  final userLocation = ref.watch(userLocationProvider);

  if (userLocation == null) {
    // Si pas de localisation, retourner toutes les offres
    return await offerService.getAvailableOffers();
  }

  return await offerService.getNearbyOffers(
    latitude: userLocation.latitude,
    longitude: userLocation.longitude,
    radius: 5.0, // 5km par défaut
  );
});

/// Provider pour les offres gratuites uniquement
final freeOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final offerService = ref.watch(foodOfferServiceProvider);
  final userLocation = ref.watch(userLocationProvider);
  
  return await offerService.getAvailableOffers(
    latitude: userLocation?.latitude,
    longitude: userLocation?.longitude,
    freeOnly: true,
  );
});

/// Provider pour une offre spécifique
final offerByIdProvider = FutureProvider.family<FoodOffer, String>((ref, offerId) async {
  final offerService = ref.watch(foodOfferServiceProvider);
  return await offerService.getOfferById(offerId);
});

/// Provider pour les offres d'un commerçant
final merchantOffersProvider = FutureProvider.family<List<FoodOffer>, String>((ref, merchantId) async {
  final offerService = ref.watch(foodOfferServiceProvider);
  return await offerService.getMerchantOffers(merchantId);
});

/// État du panier (offres sélectionnées pour réservation)
class CartItem {
  final FoodOffer offer;
  final int quantity;

  const CartItem({
    required this.offer,
    required this.quantity,
  });

  double get totalPrice => offer.discountedPrice * quantity;
}

/// Provider pour gérer le panier
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(FoodOffer offer, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.offer.id == offer.id);
    
    if (existingIndex != -1) {
      // Augmenter la quantité si l'offre est déjà dans le panier
      final updated = List<CartItem>.from(state);
      final existing = updated[existingIndex];
      updated[existingIndex] = CartItem(
        offer: existing.offer,
        quantity: existing.quantity + quantity,
      );
      state = updated;
    } else {
      // Ajouter une nouvelle offre au panier
      state = [...state, CartItem(offer: offer, quantity: quantity)];
    }
  }

  void removeFromCart(String offerId) {
    state = state.where((item) => item.offer.id != offerId).toList();
  }

  void updateQuantity(String offerId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(offerId);
      return;
    }

    state = state.map((item) {
      if (item.offer.id == offerId) {
        return CartItem(offer: item.offer, quantity: quantity);
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  double get totalAmount {
    return state.fold(0, (total, item) => total + item.totalPrice);
  }

  int get totalItems {
    return state.fold(0, (total, item) => total + item.quantity);
  }
}