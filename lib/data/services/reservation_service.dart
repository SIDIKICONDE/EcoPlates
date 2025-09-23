import 'package:dio/dio.dart';
import '../models/reservation_model.dart';
import '../../domain/entities/reservation.dart';
import '../../core/constants/env_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service pour gérer les réservations
class ReservationService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ReservationService({Dio? dio, FlutterSecureStorage? storage})
    : _dio = dio ?? Dio(),
      _secureStorage = storage ?? const FlutterSecureStorage();

  /// Créer une nouvelle réservation
  Future<Reservation> createReservation({
    required String offerId,
    required int quantity,
    PaymentMethod paymentMethod = PaymentMethod.free,
    String? paymentToken,
  }) async {
    try {
      final token = await _getAuthToken();

      final response = await _dio.post(
        '${EnvConfig.apiUrl}/reservations',
        data: {
          'offer_id': offerId,
          'quantity': quantity,
          'payment_method': paymentMethod.name,
          'payment_token': paymentToken,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        return ReservationModel.fromJson(response.data).toEntity();
      }

      throw Exception('Erreur lors de la création de la réservation');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer les réservations de l'utilisateur
  Future<List<Reservation>> getUserReservations({
    ReservationStatus? status,
    bool? active,
  }) async {
    try {
      final token = await _getAuthToken();
      final queryParams = <String, dynamic>{};

      if (status != null) queryParams['status'] = status.name;
      if (active != null) queryParams['active'] = active;

      final response = await _dio.get(
        '${EnvConfig.apiUrl}/reservations/my',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['reservations'];
        return data
            .map((json) => ReservationModel.fromJson(json).toEntity())
            .toList();
      }

      throw Exception('Erreur lors de la récupération des réservations');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer une réservation par son ID
  Future<Reservation> getReservationById(String reservationId) async {
    try {
      final token = await _getAuthToken();

      final response = await _dio.get(
        '${EnvConfig.apiUrl}/reservations/$reservationId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return ReservationModel.fromJson(response.data).toEntity();
      }

      throw Exception('Réservation non trouvée');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Annuler une réservation
  Future<void> cancelReservation(String reservationId, {String? reason}) async {
    try {
      final token = await _getAuthToken();

      final response = await _dio.patch(
        '${EnvConfig.apiUrl}/reservations/$reservationId/cancel',
        data: {'reason': reason},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de l\'annulation de la réservation');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Confirmer la collecte d'une réservation
  Future<void> confirmCollection(
    String reservationId,
    String confirmationCode,
  ) async {
    try {
      final token = await _getAuthToken();

      final response = await _dio.patch(
        '${EnvConfig.apiUrl}/reservations/$reservationId/collect',
        data: {'confirmation_code': confirmationCode},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la confirmation de collecte');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer l'historique des réservations
  Future<List<Reservation>> getReservationHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final token = await _getAuthToken();

      final response = await _dio.get(
        '${EnvConfig.apiUrl}/reservations/history',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['reservations'];
        return data
            .map((json) => ReservationModel.fromJson(json).toEntity())
            .toList();
      }

      throw Exception('Erreur lors de la récupération de l\'historique');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtenir le QR code pour une réservation
  Future<String> getReservationQRCode(String reservationId) async {
    try {
      final token = await _getAuthToken();

      final response = await _dio.get(
        '${EnvConfig.apiUrl}/reservations/$reservationId/qrcode',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['qr_code'];
      }

      throw Exception('Erreur lors de la génération du QR code');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Vérifier la validité d'une réservation (pour commerçants)
  Future<bool> verifyReservation(String confirmationCode) async {
    try {
      final token = await _getAuthToken();

      final response = await _dio.post(
        '${EnvConfig.apiUrl}/reservations/verify',
        data: {'confirmation_code': confirmationCode},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data['valid'] ?? false;
      }

      return false;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer le token d'authentification
  Future<String?> _getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  /// Gestion centralisée des erreurs
  Exception _handleError(DioException error) {
    if (error.response != null) {
      switch (error.response?.statusCode) {
        case 400:
          return Exception('Requête invalide');
        case 401:
          return Exception('Non autorisé - Veuillez vous reconnecter');
        case 403:
          return Exception('Accès interdit');
        case 404:
          return Exception('Ressource non trouvée');
        case 409:
          return Exception('Conflit - Cette offre n\'est plus disponible');
        case 500:
          return Exception('Erreur serveur');
        default:
          return Exception('Erreur: ${error.response?.statusMessage}');
      }
    }

    if (error.type == DioExceptionType.connectionTimeout) {
      return Exception('Délai de connexion dépassé');
    }

    if (error.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai de réponse dépassé');
    }

    if (error.type == DioExceptionType.connectionError) {
      return Exception('Erreur de connexion réseau');
    }

    return Exception('Erreur inconnue: ${error.message}');
  }
}
