import 'package:equatable/equatable.dart';

/// Classe abstraite représentant une erreur/échec dans l'application
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;
  
  const Failure(this.message, {this.code, this.details});
  
  @override
  List<Object?> get props => [message, code, details];
}

/// Erreur serveur (5xx)
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.details});
}

/// Erreur de connexion réseau
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.details});
}

/// Erreur de cache local
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code, super.details});
}

/// Erreur de validation des données
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;
  
  const ValidationFailure(
    super.message, {
    super.code,
    super.details,
    this.fieldErrors,
  });
  
  @override
  List<Object?> get props => [message, code, details, fieldErrors];
}

/// Erreur d'authentification
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, {super.code, super.details});
}

/// Erreur d'autorisation/permissions
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code, super.details});
}

/// Erreur de logique métier
class BusinessFailure extends Failure {
  const BusinessFailure(super.message, {super.code, super.details});
}

/// Ressource non trouvée (404)
class NotFoundFailure extends Failure {
  final String? resourceType;
  final String? resourceId;
  
  const NotFoundFailure(
    super.message, {
    super.code,
    super.details,
    this.resourceType,
    this.resourceId,
  });
  
  @override
  List<Object?> get props => [message, code, details, resourceType, resourceId];
}

/// Erreur de timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.code, super.details});
}

/// Erreur inattendue/inconnue
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code, super.details});
}

/// Erreur de quota/limite dépassée
class QuotaExceededFailure extends Failure {
  final int? currentUsage;
  final int? limit;
  
  const QuotaExceededFailure(
    super.message, {
    super.code,
    super.details,
    this.currentUsage,
    this.limit,
  });
  
  @override
  List<Object?> get props => [message, code, details, currentUsage, limit];
}

/// Erreur de paiement
class PaymentFailure extends Failure {
  final String? transactionId;
  final String? paymentMethod;
  
  const PaymentFailure(
    super.message, {
    super.code,
    super.details,
    this.transactionId,
    this.paymentMethod,
  });
  
  @override
  List<Object?> get props => [message, code, details, transactionId, paymentMethod];
}

/// Erreur de conflit (409)
class ConflictFailure extends Failure {
  const ConflictFailure(super.message, {super.code, super.details});
}

/// Erreur d'autorisation (401)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code, super.details});
}

/// Erreur d'autorisation (403)
class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message, {super.code, super.details});
}

/// Extensions pour faciliter la gestion des erreurs
extension FailureExtension on Failure {
  /// Retourne un message utilisateur-friendly
  String get userMessage {
    switch (runtimeType) {
      case NetworkFailure _:
        return 'Problème de connexion. Vérifiez votre connexion internet.';
      case ServerFailure _:
        return 'Erreur serveur. Veuillez réessayer plus tard.';
      case AuthenticationFailure _:
        return 'Erreur d\'authentification. Veuillez vous reconnecter.';
      case PermissionFailure _:
        return 'Vous n\'avez pas les permissions nécessaires.';
      case ValidationFailure _:
        return message;
      case TimeoutFailure _:
        return 'La requête a pris trop de temps. Veuillez réessayer.';
      case NotFoundFailure _:
        return 'Ressource non trouvée.';
      case QuotaExceededFailure _:
        return 'Limite dépassée. $message';
      case PaymentFailure _:
        return 'Erreur de paiement. $message';
      default:
        return 'Une erreur inattendue s\'est produite.';
    }
  }
  
  /// Indique si l'erreur est récupérable (peut être réessayée)
  bool get isRecoverable {
    return this is NetworkFailure || 
           this is TimeoutFailure || 
           (this is ServerFailure && code != '500');
  }
  
  /// Indique si l'erreur nécessite une ré-authentification
  bool get requiresReauth {
    return this is AuthenticationFailure || 
           (code == '401' || code == 'TOKEN_EXPIRED');
  }
}