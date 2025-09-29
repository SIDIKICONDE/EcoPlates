import 'dart:math' as math;
import 'package:meta/meta.dart';

/// Entité pour représenter les données de localisation
@immutable
class LocationData {
  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.postalCode,
  });
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? postalCode;

  /// Calcule la distance en kilomètres entre deux points
  double distanceTo(LocationData other) {
    const earthRadius = 6371.0; // Rayon de la Terre en km

    final dLat = _toRadians(other.latitude - latitude);
    final dLon = _toRadians(other.longitude - longitude);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(latitude)) *
            math.cos(_toRadians(other.latitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * math.pi / 180;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationData &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
