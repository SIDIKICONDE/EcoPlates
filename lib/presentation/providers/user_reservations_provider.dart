import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/reservation.dart';

/// Liste simple des réservations utilisateur (dev/mock)
final userReservationsProvider =
    StateNotifierProvider<UserReservationsNotifier, List<Reservation>>(
  (ref) => UserReservationsNotifier(),
);

class UserReservationsNotifier extends StateNotifier<List<Reservation>> {
  UserReservationsNotifier() : super(const []);

  void add(Reservation reservation) {
    state = [reservation, ...state];
  }

  void remove(String reservationId) {
    state = state.where((r) => r.id != reservationId).toList();
  }

  Reservation? getById(String reservationId) {
    try {
      return state.firstWhere((r) => r.id == reservationId);
    } catch (_) {
      return null;
    }
  }
}
