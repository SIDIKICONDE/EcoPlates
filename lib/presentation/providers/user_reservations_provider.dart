import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/reservation.dart';

class UserReservationsNotifier extends Notifier<List<Reservation>> {
  @override
  List<Reservation> build() {
    return const [];
  }

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

/// Liste simple des réservations utilisateur (dev/mock)
final userReservationsProvider =
    NotifierProvider<UserReservationsNotifier, List<Reservation>>(
      UserReservationsNotifier.new,
    );
