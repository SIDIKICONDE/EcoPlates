import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../core/enums/merchant_enums.dart';

/// Entité représentant le profil complet d'un commerçant dans EcoPlates
///
/// Contient toutes les informations nécessaires pour le profil merchant
/// selon les spécifications métier définies
@immutable
class MerchantProfile {
  const MerchantProfile({
    required this.id,
    required this.name,
    required this.category,
    this.logoUrl,
    this.description,
    this.address,
    this.phoneNumber,
    this.email,
    this.openingHours = const {},
    this.coordinates,
    this.createdAt,
    this.updatedAt,
    this.isVerified = false,
    this.rating = 0.0,
    this.totalReviews = 0,
  });

  /// Identifiant unique du commerçant (non modifiable)
  final String id;

  /// Nom du commerce ou enseigne
  final String name;

  /// Catégorie du commerce
  final MerchantCategory category;

  /// URL de la photo de profil ou logo
  final String? logoUrl;

  /// Description courte du commerce
  final String? description;

  /// Adresse physique du commerce
  final MerchantAddress? address;

  /// Numéro de téléphone (optionnel)
  final String? phoneNumber;

  /// Email de contact (optionnel)
  final String? email;

  /// Horaires d'ouverture par jour
  final Map<WeekDay, OpeningHours> openingHours;

  /// Coordonnées GPS pour géolocalisation
  final GeoCoordinates? coordinates;

  /// Date de création du profil
  final DateTime? createdAt;

  /// Date de dernière modification
  final DateTime? updatedAt;

  /// Statut de vérification du profil
  final bool isVerified;

  /// Note moyenne du commerçant
  final double rating;

  /// Nombre total d'avis
  final int totalReviews;

  /// Créer une copie avec modifications
  MerchantProfile copyWith({
    String? name,
    MerchantCategory? category,
    String? logoUrl,
    String? description,
    MerchantAddress? address,
    String? phoneNumber,
    String? email,
    Map<WeekDay, OpeningHours>? openingHours,
    GeoCoordinates? coordinates,
    DateTime? updatedAt,
    bool? isVerified,
    double? rating,
    int? totalReviews,
  }) {
    return MerchantProfile(
      id: id, // ID ne change jamais
      name: name ?? this.name,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      openingHours: openingHours ?? this.openingHours,
      coordinates: coordinates ?? this.coordinates,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  /// Vérifier si le commerce est actuellement ouvert
  bool isOpenNow() {
    final now = DateTime.now();
    final today = WeekDay.values[now.weekday - 1];
    final todayHours = openingHours[today];

    if (todayHours == null || todayHours.isClosed) {
      return false;
    }

    final currentTime = now.hour * 60 + now.minute;
    return currentTime >= todayHours.openTimeInMinutes &&
        currentTime <= todayHours.closeTimeInMinutes;
  }

  /// Obtenir le statut d'ouverture actuel
  OpenStatus getCurrentStatus() {
    if (!isOpenNow()) {
      return OpenStatus.closed;
    }

    // Vérifier si ferme bientôt (dans les 30 prochaines minutes)
    final now = DateTime.now();
    final today = WeekDay.values[now.weekday - 1];
    final todayHours = openingHours[today];

    if (todayHours != null) {
      final currentTime = now.hour * 60 + now.minute;
      final closeTime = todayHours.closeTimeInMinutes;

      if (closeTime - currentTime <= 30) {
        return OpenStatus.closingSoon;
      }
    }

    return OpenStatus.open;
  }

  /// Obtenir les horaires du jour actuel
  OpeningHours? getTodayHours() {
    final today = WeekDay.values[DateTime.now().weekday - 1];
    return openingHours[today];
  }

  /// Validation des règles métier
  bool isValid() {
    return name.isNotEmpty &&
        id.isNotEmpty &&
        (phoneNumber == null || _isValidPhoneNumber(phoneNumber!)) &&
        (email == null || _isValidEmail(email!));
  }

  static bool _isValidPhoneNumber(String phone) {
    // Validation basique du numéro de téléphone français
    final cleanPhone = phone.replaceAll(RegExp(r'\s|-|\.'), '');
    return RegExp(r'^(\+33|0)[1-9](\d{8})$').hasMatch(cleanPhone);
  }

  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MerchantProfile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Adresse d'un commerce
@immutable
class MerchantAddress {
  const MerchantAddress({
    required this.street,
    required this.postalCode,
    required this.city,
    this.complement,
    this.country = 'France',
  });

  final String street;
  final String postalCode;
  final String city;
  final String? complement;
  final String country;

  /// Adresse formatée pour affichage
  String get formatted {
    final parts = [street];
    if (complement != null && complement!.isNotEmpty) {
      parts.add(complement!);
    }
    parts.add('$postalCode $city');
    if (country != 'France') {
      parts.add(country);
    }
    return parts.join(', ');
  }

  /// Adresse courte (sans complément ni pays)
  String get shortFormat => '$street, $postalCode $city';

  /// URL pour ouvrir dans Google Maps
  String get googleMapsUrl {
    final query = Uri.encodeComponent(formatted);
    return 'https://www.google.com/maps/search/?api=1&query=$query';
  }

  MerchantAddress copyWith({
    String? street,
    String? postalCode,
    String? city,
    String? complement,
    String? country,
  }) {
    return MerchantAddress(
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      complement: complement ?? this.complement,
      country: country ?? this.country,
    );
  }
}

/// Coordonnées GPS
@immutable
class GeoCoordinates {
  const GeoCoordinates({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  /// Distance en mètres entre deux points
  double distanceTo(GeoCoordinates other) {
    const earthRadius = 6371000.0; // en mètres
    final dLat = _toRadians(other.latitude - latitude);
    final dLon = _toRadians(other.longitude - longitude);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(latitude)) *
            math.cos(_toRadians(other.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// URL pour ouvrir dans Google Maps avec coordonnées
  String get googleMapsUrl {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }
}

/// Horaires d'ouverture pour une journée
@immutable
class OpeningHours {
  const OpeningHours({
    required this.openTime,
    required this.closeTime,
    this.breakStart,
    this.breakEnd,
    this.isClosed = false,
  });

  /// Créer des horaires pour un jour fermé
  const OpeningHours.closed()
    : openTime = '00:00',
      closeTime = '00:00',
      breakStart = null,
      breakEnd = null,
      isClosed = true;

  final String openTime; // Format: "HH:mm"
  final String closeTime; // Format: "HH:mm"
  final String? breakStart; // Pause déjeuner début
  final String? breakEnd; // Pause déjeuner fin
  final bool isClosed;

  /// Convertir l'heure en minutes depuis minuit
  int get openTimeInMinutes => _timeToMinutes(openTime);
  int get closeTimeInMinutes => _timeToMinutes(closeTime);
  int? get breakStartInMinutes =>
      breakStart != null ? _timeToMinutes(breakStart!) : null;
  int? get breakEndInMinutes =>
      breakEnd != null ? _timeToMinutes(breakEnd!) : null;

  static int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  /// Formatage pour affichage
  String get displayFormat {
    if (isClosed) {
      return '';
    }

    var format = '$openTime - $closeTime';
    if (breakStart != null && breakEnd != null) {
      format += ' (pause: $breakStart - $breakEnd)';
    }
    return format;
  }

  /// Format court sans pause
  String get shortFormat {
    if (isClosed) return '';
    return '$openTime - $closeTime';
  }

  /// Vérifier si une heure est dans les horaires d'ouverture
  bool isTimeInRange(int minutes) {
    if (isClosed) return false;

    // Gérer le cas où les horaires passent minuit
    if (closeTimeInMinutes < openTimeInMinutes) {
      return minutes >= openTimeInMinutes || minutes <= closeTimeInMinutes;
    }

    // Vérifier si c'est pendant la pause
    if (breakStartInMinutes != null && breakEndInMinutes != null) {
      if (minutes >= breakStartInMinutes! && minutes < breakEndInMinutes!) {
        return false;
      }
    }

    return minutes >= openTimeInMinutes && minutes <= closeTimeInMinutes;
  }

  OpeningHours copyWith({
    String? openTime,
    String? closeTime,
    String? breakStart,
    String? breakEnd,
    bool? isClosed,
  }) {
    return OpeningHours(
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}
