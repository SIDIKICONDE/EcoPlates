import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/failures.dart';
import '../../core/providers/injection_providers.dart';
import '../../domain/entities/food_offer.dart';
import './offers_catalog_provider.dart';
import './stock_items_provider.dart';
import './user_reservations_provider.dart';
import '../../domain/entities/reservation.dart';

/// Contrôleur de réservation d'offres qui synchronise aussi le stock (Option 2)
final offerReservationProvider =
    AsyncNotifierProvider<OfferReservationController, void>(
      OfferReservationController.new,
    );

class OfferReservationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Pas d'état persistant à charger pour l'instant
  }

  /// Réserve une offre et, si fourni, décrémente aussi le stock lié.
  /// - Décrémente la quantité de l'offre dans le catalogue partagé
  /// - Appelle le repository pour la réservation (mock en dev)
  /// - Si [stockItemId] est fourni, ajuste la quantité du stock correspondant
  Future<String> reserve({
    required FoodOffer offer,
    int quantity = 1,
    String? stockItemId,
    String userId = 'current_user_id', // TODO: récupérer depuis l'auth
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(foodOfferRepositoryProvider);

    // Nouveau total pour l'offre (sans descendre sous 0)
    final newQty = (offer.quantity - quantity).clamp(0, 999999);

    try {
      // 1) Appel domaine: réservation (gère offline/online via repository)
      final result = await repo.reserveOffer(
        offerId: offer.id,
        userId: userId,
        quantity: quantity,
      );

      // Gestion d'erreur propre
      result.fold(
        (failure) => throw Exception(failure.userMessage),
        (_) => null,
      );

      // 2) Mettre à jour l'offre dans le catalogue partagé
      final updatedOffer = offer.copyWith(
        quantity: newQty,
        updatedAt: DateTime.now(),
        // On peut garder le statut à available; quantity==0 suffira à masquer l'offre
      );
      ref.read(offersCatalogProvider.notifier).upsert(updatedOffer);

      // 3) Ajuster le stock si un item est lié
      if (stockItemId != null && stockItemId.isNotEmpty) {
        try {
          await ref
              .read(stockItemsProvider.notifier)
              .adjustQuantity(stockItemId, -quantity);
        } catch (e) {
          // Rollback de l'offre si l'ajustement stock échoue
          ref.read(offersCatalogProvider.notifier).upsert(offer);
          rethrow;
        }
      }

      // 4) Enregistrer la réservation localement (mock/dev)
      final reservationId = DateTime.now().millisecondsSinceEpoch.toString();
      final reservation = Reservation(
        id: reservationId,
        offerId: offer.id,
        title: offer.title,
        quantity: quantity,
        stockItemId: stockItemId,
        createdAt: DateTime.now(),
      );
      ref.read(userReservationsProvider.notifier).add(reservation);

      state = const AsyncData(null);
      return reservationId;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Annule une réservation par son identifiant (restaure quantités + stock)
  Future<void> cancelById(String reservationId) async {
    state = const AsyncLoading();
    final repo = ref.read(foodOfferRepositoryProvider);

    try {
      // Retrouver la réservation locale
      final reservation = ref
          .read(userReservationsProvider)
          .firstWhere((r) => r.id == reservationId, orElse: () => throw Exception('Réservation introuvable'));

      // 1) Annulation via repository (si implémentée). Ici, best-effort.
      final result = await repo.cancelReservation(reservationId);
      result.fold(
        (failure) => throw Exception(failure.userMessage),
        (_) => null,
      );

      // 2) Restaurer l'offre courante
      final offers = ref.read(offersCatalogProvider);
      final existing = offers.firstWhere(
        (o) => o.id == reservation.offerId,
        orElse: () => throw Exception('Offre introuvable pour annulation'),
      );

      final restored = existing.copyWith(
        quantity: (existing.quantity + reservation.quantity).clamp(0, 999999),
        updatedAt: DateTime.now(),
      );
      ref.read(offersCatalogProvider.notifier).upsert(restored);

      // 3) Restaurer le stock si lié
      if (reservation.stockItemId != null && reservation.stockItemId!.isNotEmpty) {
        await ref
            .read(stockItemsProvider.notifier)
            .adjustQuantity(reservation.stockItemId!, reservation.quantity);
      }

      // 4) Retirer la réservation locale
      ref.read(userReservationsProvider.notifier).remove(reservationId);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
