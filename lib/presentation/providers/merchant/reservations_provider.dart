import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/reservation.dart';
import '../../../domain/usecases/manage_reservation_usecase.dart';
import '../../../data/services/reservation_service.dart';
import '../../../data/services/food_offer_service.dart';

/// Provider pour le service des réservations
final reservationServiceProvider = Provider<ReservationService>((ref) {
  return ReservationService();
});

/// Provider pour le use case de gestion des réservations
final manageReservationUseCaseProvider = Provider<ManageReservationUseCase>((
  ref,
) {
  final reservationService = ref.watch(reservationServiceProvider);
  final offerService = ref.watch(foodOfferServiceProvider);

  return ManageReservationUseCase(
    reservationService: reservationService,
    offerService: offerService,
  );
});

/// Provider pour le service des offres (importé depuis offers_provider)
final foodOfferServiceProvider = Provider<FoodOfferService>((ref) {
  return FoodOfferService();
});

/// Provider simple pour créer une réservation
final createReservationProvider =
    FutureProvider.family<Reservation, ({String offerId, int quantity})>((
      ref,
      params,
    ) async {
      final useCase = ref.watch(manageReservationUseCaseProvider);

      return await useCase.createReservation(
        offerId: params.offerId,
        quantity: params.quantity,
      );
    });

/// Provider pour les réservations de l'utilisateur connecté
final userReservationsProvider = FutureProvider<List<Reservation>>((ref) async {
  final useCase = ref.watch(manageReservationUseCaseProvider);
  return await useCase.getActiveReservations();
});

/// Provider pour les réservations actives
final activeReservationsProvider = FutureProvider<List<Reservation>>((
  ref,
) async {
  final useCase = ref.watch(manageReservationUseCaseProvider);
  return await useCase.getActiveReservations();
});

/// Provider pour l'historique des réservations
final reservationHistoryProvider =
    FutureProvider.family<List<Reservation>, ({int page, int limit})>((
      ref,
      params,
    ) async {
      final useCase = ref.watch(manageReservationUseCaseProvider);
      return await useCase.getReservationHistory(
        page: params.page,
        limit: params.limit,
      );
    });

/// Provider pour une réservation avec son offre
final reservationWithOfferProvider =
    FutureProvider.family<ReservationWithOffer, String>((
      ref,
      reservationId,
    ) async {
      final useCase = ref.watch(manageReservationUseCaseProvider);
      return await useCase.getReservationWithOffer(reservationId);
    });

/// Provider pour le QR code d'une réservation
final reservationQRCodeProvider = FutureProvider.family<String, String>((
  ref,
  reservationId,
) async {
  final useCase = ref.watch(manageReservationUseCaseProvider);
  return await useCase.getReservationQRCode(reservationId);
});

/// Provider pour les statistiques utilisateur
final userReservationStatsProvider = FutureProvider<UserReservationStats>((
  ref,
) async {
  final useCase = ref.watch(manageReservationUseCaseProvider);
  return await useCase.getUserStats();
});

/// Notifier pour gérer l'état global des réservations
class ReservationsStateNotifier
    extends StateNotifier<AsyncValue<List<Reservation>>> {
  final ManageReservationUseCase _useCase;

  ReservationsStateNotifier(this._useCase) : super(const AsyncValue.loading()) {
    loadActiveReservations();
  }

  Future<void> loadActiveReservations() async {
    state = const AsyncValue.loading();
    try {
      final reservations = await _useCase.getActiveReservations();
      state = AsyncValue.data(reservations);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> cancelReservation(String reservationId, {String? reason}) async {
    try {
      await _useCase.cancelReservation(
        reservationId: reservationId,
        reason: reason,
      );
      // Recharger la liste après annulation
      await loadActiveReservations();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmCollection(
    String reservationId,
    String confirmationCode,
  ) async {
    try {
      await _useCase.confirmCollection(
        reservationId: reservationId,
        confirmationCode: confirmationCode,
      );
      // Recharger la liste après confirmation
      await loadActiveReservations();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyReservation(String confirmationCode) async {
    try {
      return await _useCase.verifyReservation(confirmationCode);
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider pour l'état global des réservations
final reservationsStateProvider =
    StateNotifierProvider<
      ReservationsStateNotifier,
      AsyncValue<List<Reservation>>
    >((ref) {
      final useCase = ref.watch(manageReservationUseCaseProvider);
      return ReservationsStateNotifier(useCase);
    });

/// Provider pour vérifier si l'utilisateur a des réservations actives à récupérer bientôt
final upcomingPickupsProvider = Provider<List<Reservation>>((ref) {
  final reservationsAsync = ref.watch(activeReservationsProvider);

  return reservationsAsync.maybeWhen(
    data: (reservations) {
      final now = DateTime.now();
      final in2Hours = now.add(const Duration(hours: 2));

      return reservations.where((r) {
        return r.pickupStartTime.isAfter(now) &&
            r.pickupStartTime.isBefore(in2Hours) &&
            r.status == ReservationStatus.confirmed;
      }).toList();
    },
    orElse: () => [],
  );
});

/// Provider pour compter le nombre de réservations actives
final activeReservationsCountProvider = Provider<int>((ref) {
  final reservationsAsync = ref.watch(activeReservationsProvider);

  return reservationsAsync.maybeWhen(
    data: (reservations) => reservations.length,
    orElse: () => 0,
  );
});
