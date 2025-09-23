import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'failures.dart';

/// Gestionnaire d'erreurs centralisé pour le côté commerçant
class MerchantErrorHandler {
  static const _tag = 'MerchantErrorHandler';

  /// Convertit une exception en Failure approprié
  static Failure handleError(dynamic error, [StackTrace? stackTrace]) {
    debugPrint('$_tag: Error caught - $error');

    if (error is Failure) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is PlatformException) {
      return _handlePlatformError(error);
    }

    if (error is SocketException) {
      return NetworkFailure(
        'Erreur de connexion réseau',
        code: 'NETWORK_ERROR',
        details: error.toString(),
      );
    }

    if (error is FormatException) {
      return ValidationFailure(
        'Format de données invalide',
        code: 'FORMAT_ERROR',
        details: error.toString(),
      );
    }

    if (error is TimeoutException) {
      return TimeoutFailure(
        'Délai d\'attente dépassé',
        code: 'TIMEOUT',
        details: error.toString(),
      );
    }

    // Log l'erreur non gérée pour analyse
    _logUnhandledError(error, stackTrace);

    return UnexpectedFailure(
      'Une erreur inattendue s\'est produite',
      code: 'UNEXPECTED',
      details: error.toString(),
    );
  }

  /// Gère les erreurs Dio/HTTP
  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          'La connexion a expiré',
          code: 'TIMEOUT',
          details: error.message,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          'Impossible de se connecter au serveur',
          code: 'CONNECTION_ERROR',
          details: error.message,
        );

      case DioExceptionType.badResponse:
        return _handleHttpError(error.response);

      case DioExceptionType.cancel:
        return UnexpectedFailure(
          'Requête annulée',
          code: 'CANCELLED',
          details: error.message,
        );

      default:
        return NetworkFailure(
          'Erreur réseau',
          code: 'NETWORK_ERROR',
          details: error.message,
        );
    }
  }

  /// Gère les erreurs HTTP basées sur les codes de statut
  static Failure _handleHttpError(Response? response) {
    if (response == null) {
      return ServerFailure('Aucune réponse du serveur', code: 'NO_RESPONSE');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    final message = _extractErrorMessage(data);
    final code = _extractErrorCode(data);

    switch (statusCode) {
      case 400:
        // Vérifier si c'est une erreur de validation
        if (data is Map && data.containsKey('errors')) {
          return ValidationFailure(
            message ?? 'Données invalides',
            code: code,
            fieldErrors: _extractFieldErrors(data['errors']),
            details: data,
          );
        }
        return ValidationFailure(
          message ?? 'Requête invalide',
          code: code,
          details: data,
        );

      case 401:
        return AuthenticationFailure(
          message ?? 'Non authentifié',
          code: code ?? 'UNAUTHENTICATED',
          details: data,
        );

      case 403:
        return PermissionFailure(
          message ?? 'Accès refusé',
          code: code ?? 'FORBIDDEN',
          details: data,
        );

      case 404:
        return NotFoundFailure(
          message ?? 'Ressource non trouvée',
          code: code ?? 'NOT_FOUND',
          details: data,
          resourceType: data is Map ? data['resource_type'] : null,
          resourceId: data is Map ? data['resource_id'] : null,
        );

      case 409:
        return BusinessFailure(
          message ?? 'Conflit de données',
          code: code ?? 'CONFLICT',
          details: data,
        );

      case 422:
        return ValidationFailure(
          message ?? 'Entité non traitable',
          code: code ?? 'UNPROCESSABLE',
          fieldErrors: _extractFieldErrors(data),
          details: data,
        );

      case 429:
        return QuotaExceededFailure(
          message ?? 'Trop de requêtes',
          code: code ?? 'RATE_LIMITED',
          details: data,
          currentUsage: data is Map ? data['current_usage'] : null,
          limit: data is Map ? data['limit'] : null,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message ?? 'Erreur serveur',
          code: code ?? 'SERVER_ERROR',
          details: data,
        );

      default:
        return ServerFailure(
          message ?? 'Erreur HTTP $statusCode',
          code: code ?? 'HTTP_$statusCode',
          details: data,
        );
    }
  }

  /// Gère les erreurs de plateforme
  static Failure _handlePlatformError(PlatformException error) {
    switch (error.code) {
      case 'PERMISSION_DENIED':
        return PermissionFailure(
          error.message ?? 'Permission refusée',
          code: error.code,
          details: error.details,
        );

      case 'NETWORK_ERROR':
        return NetworkFailure(
          error.message ?? 'Erreur réseau',
          code: error.code,
          details: error.details,
        );

      default:
        return UnexpectedFailure(
          error.message ?? 'Erreur plateforme',
          code: error.code,
          details: error.details,
        );
    }
  }

  /// Extrait le message d'erreur depuis la réponse
  static String? _extractErrorMessage(dynamic data) {
    if (data is Map) {
      return data['message'] ??
          data['error'] ??
          data['error_message'] ??
          data['detail'];
    }
    if (data is String) {
      return data;
    }
    return null;
  }

  /// Extrait le code d'erreur depuis la réponse
  static String? _extractErrorCode(dynamic data) {
    if (data is Map) {
      return data['code'] ?? data['error_code'] ?? data['error_type'];
    }
    return null;
  }

  /// Extrait les erreurs de champs pour la validation
  static Map<String, List<String>>? _extractFieldErrors(dynamic errors) {
    if (errors is! Map) return null;

    final fieldErrors = <String, List<String>>{};

    errors.forEach((key, value) {
      if (value is List) {
        fieldErrors[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        fieldErrors[key] = [value];
      }
    });

    return fieldErrors.isEmpty ? null : fieldErrors;
  }

  /// Log les erreurs non gérées pour le monitoring
  static void _logUnhandledError(dynamic error, StackTrace? stackTrace) {
    debugPrint('$_tag: Unhandled error - $error');
    if (stackTrace != null) {
      debugPrint('$_tag: StackTrace - $stackTrace');
    }

    // TODO: Envoyer à un service de monitoring (Crashlytics, Sentry, etc.)
  }

  /// Affiche une erreur à l'utilisateur de manière appropriée
  static void showError(BuildContext context, Failure failure) {
    final message = failure.userMessage;
    final isRecoverable = failure.isRecoverable;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isRecoverable ? Colors.orange : Colors.red,
        duration: const Duration(seconds: 4),
        action: isRecoverable
            ? SnackBarAction(
                label: 'Réessayer',
                textColor: Colors.white,
                onPressed: () {
                  // Trigger retry logic
                },
              )
            : null,
      ),
    );
  }

  /// Affiche une boîte de dialogue d'erreur détaillée
  static Future<void> showErrorDialog(
    BuildContext context,
    Failure failure, {
    String? title,
    List<Widget>? actions,
    bool dismissible = true,
  }) async {
    final theme = Theme.of(context);

    await showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getErrorIcon(failure),
              color: _getErrorColor(failure),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(title ?? _getErrorTitle(failure)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(failure.userMessage),
            if (failure.code != null) ...[
              const SizedBox(height: 8),
              Text(
                'Code: ${failure.code}',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
            if (failure is ValidationFailure &&
                failure.fieldErrors != null) ...[
              const SizedBox(height: 12),
              ...failure.fieldErrors!.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${entry.key}: ${entry.value.join(', ')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        actions:
            actions ??
            [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
      ),
    );
  }

  /// Retourne l'icône appropriée pour le type d'erreur
  static IconData _getErrorIcon(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return Icons.wifi_off;
      case AuthenticationFailure _:
        return Icons.lock_outline;
      case PermissionFailure _:
        return Icons.block;
      case ValidationFailure _:
        return Icons.warning_amber;
      case PaymentFailure _:
        return Icons.credit_card_off;
      case TimeoutFailure _:
        return Icons.timer_off;
      default:
        return Icons.error_outline;
    }
  }

  /// Retourne la couleur appropriée pour le type d'erreur
  static Color _getErrorColor(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
      case TimeoutFailure _:
        return Colors.orange;
      case AuthenticationFailure _:
      case PermissionFailure _:
        return Colors.red;
      case ValidationFailure _:
        return Colors.amber;
      case PaymentFailure _:
        return Colors.deepOrange;
      default:
        return Colors.red;
    }
  }

  /// Retourne le titre approprié pour le type d'erreur
  static String _getErrorTitle(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return 'Erreur de connexion';
      case AuthenticationFailure _:
        return 'Erreur d\'authentification';
      case PermissionFailure _:
        return 'Accès refusé';
      case ValidationFailure _:
        return 'Données invalides';
      case PaymentFailure _:
        return 'Erreur de paiement';
      case TimeoutFailure _:
        return 'Délai dépassé';
      case BusinessFailure _:
        return 'Erreur métier';
      default:
        return 'Erreur';
    }
  }
}

/// Extension pour faciliter l'utilisation dans les widgets
extension BuildContextErrorHandling on BuildContext {
  /// Affiche rapidement une erreur
  void showError(Failure failure) {
    MerchantErrorHandler.showError(this, failure);
  }

  /// Affiche une boîte de dialogue d'erreur
  Future<void> showErrorDialog(
    Failure failure, {
    String? title,
    List<Widget>? actions,
  }) {
    return MerchantErrorHandler.showErrorDialog(
      this,
      failure,
      title: title,
      actions: actions,
    );
  }
}
