import '../entities/reservation.dart';
import '../entities/food_offer.dart';
import '../../data/services/reservation_service.dart';
import '../../data/services/food_offer_service.dart';

/// Use case pour gérer les réservations d'offres
class ManageReservationUseCase {
  final ReservationService _reservationService;
  final FoodOfferService _offerService;

  ManageReservationUseCase({
    required ReservationService reservationService,
    required FoodOfferService offerService,
  }) : _reservationService = reservationService,
       _offerService = offerService;

  /// Créer une nouvelle réservation
  Future<Reservation> createReservation({
    required String offerId,
    int quantity = 1,
    PaymentMethod? paymentMethod,
    String? paymentToken,
  }) async {
    try {
      // Vérifier d'abord que l'offre est disponible
      final offer = await _offerService.getOfferById(offerId);
      
      if (!offer.isAvailable) {
        throw Exception('Cette offre n\'est plus disponible');
      }

      if (offer.quantity < quantity) {
        throw Exception('Quantité demandée non disponible');
      }

      if (!offer.canPickup) {
        throw Exception('La fenêtre de collecte n\'est pas encore ouverte');
      }

      // Déterminer la méthode de paiement
      final method = paymentMethod ?? 
                    (offer.isFree ? PaymentMethod.free : PaymentMethod.card);

      // Créer la réservation
      final reservation = await _reservationService.createReservation(
        offerId: offerId,
        quantity: quantity,
        paymentMethod: method,
        paymentToken: paymentToken,
      );

      return reservation;
    } catch (e) {
      throw Exception('Erreur lors de la création de la réservation: $e');
    }
  }

  /// Annuler une réservation
  Future<void> cancelReservation({
    required String reservationId,
    String? reason,
  }) async {
    try {
      // Vérifier que la réservation peut être annulée
      final reservation = await _reservationService.getReservationById(reservationId);
      
      if (reservation.status != ReservationStatus.confirmed) {
        throw Exception('Cette réservation ne peut pas être annulée');
      }

      // Vérifier le délai d'annulation (ex: 2h avant collecte)
      final timeUntilPickup = reservation.pickupStartTime.difference(DateTime.now());
      if (timeUntilPickup.inHours < 2) {
        throw Exception('Il est trop tard pour annuler cette réservation (moins de 2h avant collecte)');
      }

      await _reservationService.cancelReservation(
        reservationId,
        reason: reason ?? 'Annulation par l\'utilisateur',
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'annulation de la réservation: $e');
    }
  }

  /// Confirmer la collecte d'une réservation
  Future<void> confirmCollection({
    required String reservationId,
    required String confirmationCode,
  }) async {
    try {
      final reservation = await _reservationService.getReservationById(reservationId);
      
      if (!reservation.canCollect) {
        throw Exception('La fenêtre de collecte n\'est pas ouverte');
      }

      await _reservationService.confirmCollection(
        reservationId,
        confirmationCode,
      );
    } catch (e) {
      throw Exception('Erreur lors de la confirmation de collecte: $e');
    }
  }

  /// Récupérer les réservations actives de l'utilisateur
  Future<List<Reservation>> getActiveReservations() async {
    try {
      final reservations = await _reservationService.getUserReservations(
        active: true,
      );

      // Trier par heure de collecte
      reservations.sort((a, b) => a.pickupStartTime.compareTo(b.pickupStartTime));
      
      return reservations;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des réservations actives: $e');
    }
  }

  /// Récupérer l'historique des réservations
  Future<List<Reservation>> getReservationHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _reservationService.getReservationHistory(
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'historique: $e');
    }
  }

  /// Récupérer une réservation avec les détails de l'offre
  Future<ReservationWithOffer> getReservationWithOffer(String reservationId) async {
    try {
      final reservation = await _reservationService.getReservationById(reservationId);
      final offer = await _offerService.getOfferById(reservation.offerId);
      
      return ReservationWithOffer(
        reservation: reservation,
        offer: offer,
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la réservation: $e');
    }
  }

  /// Obtenir le QR code d'une réservation
  Future<String> getReservationQRCode(String reservationId) async {
    try {
      return await _reservationService.getReservationQRCode(reservationId);
    } catch (e) {
      throw Exception('Erreur lors de la génération du QR code: $e');
    }
  }

  /// Vérifier si une réservation est valide (pour commerçants)
  Future<bool> verifyReservation(String confirmationCode) async {
    try {
      return await _reservationService.verifyReservation(confirmationCode);
    } catch (e) {
      throw Exception('Erreur lors de la vérification de la réservation: $e');
    }
  }

  /// Mettre à jour automatiquement le statut des réservations expirées
  Future<void> updateExpiredReservations() async {
    try {
      final activeReservations = await getActiveReservations();
      
      for (final reservation in activeReservations) {
        if (reservation.isExpired) {
          // Ici on devrait appeler une API pour marquer comme no-show
          // Pour l'instant on ne fait rien car c'est géré côté serveur
        }
      }
    } catch (e) {
      // Log l'erreur mais ne pas la propager
      // En production, utiliser un logger approprié
      // ignore: avoid_print
      print('Erreur lors de la mise à jour des réservations expirées: $e');
    }
  }

  /// Calculer les statistiques de l'utilisateur
  Future<UserReservationStats> getUserStats() async {
    try {
      final history = await getReservationHistory(limit: 100);
      
      int totalReservations = history.length;
      int completedReservations = 0;
      int cancelledReservations = 0;
      double totalSaved = 0;
      int co2Saved = 0;

      for (final reservation in history) {
        switch (reservation.status) {
          case ReservationStatus.collected:
            completedReservations++;
            if (reservation.paymentInfo != null) {
              // Calculer les économies (différence prix original - prix payé)
              // Nécessiterait l'info de l'offre
            }
            break;
          case ReservationStatus.cancelled:
            cancelledReservations++;
            break;
          default:
            break;
        }
      }

      return UserReservationStats(
        totalReservations: totalReservations,
        completedReservations: completedReservations,
        cancelledReservations: cancelledReservations,
        totalMoneySaved: totalSaved,
        totalCO2Saved: co2Saved,
      );
    } catch (e) {
      throw Exception('Erreur lors du calcul des statistiques: $e');
    }
  }
}

/// Classe combinant une réservation avec son offre associée
class ReservationWithOffer {
  final Reservation reservation;
  final FoodOffer offer;

  const ReservationWithOffer({
    required this.reservation,
    required this.offer,
  });
}

/// Statistiques des réservations de l'utilisateur
class UserReservationStats {
  final int totalReservations;
  final int completedReservations;
  final int cancelledReservations;
  final double totalMoneySaved;
  final int totalCO2Saved; // en grammes

  const UserReservationStats({
    required this.totalReservations,
    required this.completedReservations,
    required this.cancelledReservations,
    required this.totalMoneySaved,
    required this.totalCO2Saved,
  });

  double get completionRate {
    if (totalReservations == 0) return 0;
    return (completedReservations / totalReservations) * 100;
  }
}