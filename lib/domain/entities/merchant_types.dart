import 'package:json_annotation/json_annotation.dart';

/// Enums et types pour l'entité Merchant

/// Types de merchant
enum MerchantType {
  @JsonValue('restaurant')
  restaurant,
  @JsonValue('boulangerie')
  bakery,
  @JsonValue('cafeteria')
  cafe,
  @JsonValue('supermarche')
  supermarket,
  @JsonValue('epicerie')
  grocery,
  @JsonValue('hotel')
  hotel,
  @JsonValue('traiteur')
  butcher,
  @JsonValue('autre')
  other,
}

/// Statut du merchant
enum MerchantStatus {
  pending,
  @JsonValue('verified')
  active,
  suspended,
  inactive,
}

/// Jours de la semaine
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

/// Canaux de notification
enum NotificationChannel {
  push,
  email,
  sms,
  inApp,
}

/// Extension pour convertir les enums en chaîne
extension MerchantTypeExtension on MerchantType {
  String get displayName {
    switch (this) {
      case MerchantType.restaurant:
        return 'Restaurant';
      case MerchantType.bakery:
        return 'Boulangerie';
      case MerchantType.cafe:
        return 'Café';
      case MerchantType.supermarket:
        return 'Supermarché';
      case MerchantType.grocery:
        return 'Épicerie';
      case MerchantType.hotel:
        return 'Hôtel';
      case MerchantType.butcher:
        return 'Boucherie';
      case MerchantType.other:
        return 'Autre';
    }
  }
}

extension MerchantStatusExtension on MerchantStatus {
  String get displayName {
    switch (this) {
      case MerchantStatus.pending:
        return 'En attente';
      case MerchantStatus.active:
        return 'Actif';
      case MerchantStatus.suspended:
        return 'Suspendu';
      case MerchantStatus.inactive:
        return 'Inactif';
    }
  }
}

extension DayOfWeekExtension on DayOfWeek {
  String get displayName {
    switch (this) {
      case DayOfWeek.monday:
        return 'Lundi';
      case DayOfWeek.tuesday:
        return 'Mardi';
      case DayOfWeek.wednesday:
        return 'Mercredi';
      case DayOfWeek.thursday:
        return 'Jeudi';
      case DayOfWeek.friday:
        return 'Vendredi';
      case DayOfWeek.saturday:
        return 'Samedi';
      case DayOfWeek.sunday:
        return 'Dimanche';
    }
  }

  String get shortName {
    switch (this) {
      case DayOfWeek.monday:
        return 'Lun';
      case DayOfWeek.tuesday:
        return 'Mar';
      case DayOfWeek.wednesday:
        return 'Mer';
      case DayOfWeek.thursday:
        return 'Jeu';
      case DayOfWeek.friday:
        return 'Ven';
      case DayOfWeek.saturday:
        return 'Sam';
      case DayOfWeek.sunday:
        return 'Dim';
    }
  }
}