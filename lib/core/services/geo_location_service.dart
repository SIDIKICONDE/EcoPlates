import 'dart:async';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

/// Service centralisé pour la gestion de la localisation GPS
class GeoLocationService {
  GeoLocationService._();
  
  static final GeoLocationService instance = GeoLocationService._();
  
  StreamController<Position>? _positionStreamController;
  StreamSubscription<Position>? _positionStreamSubscription;
  
  /// Stream des positions GPS
  Stream<Position> get positionStream {
    _positionStreamController ??= StreamController<Position>.broadcast();
    return _positionStreamController!.stream;
  }
  
  /// Vérifie si la localisation est disponible
  Future<bool> isLocationAvailable() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }
      
      final permission = await Geolocator.checkPermission();
      return permission != LocationPermission.denied && 
             permission != LocationPermission.deniedForever;
    } catch (e) {
      // Log error: $e
      return false;
    }
  }
  
  /// Demande les permissions de localisation
  Future<bool> requestLocationPermission() async {
    try {
      var permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return false;
      }
      
      return true;
    } catch (e) {
      // Log error: $e
      return false;
    }
  }
  
  /// Obtient la position actuelle
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }
      
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      // Log error: $e
      return null;
    }
  }
  
  /// Démarre le suivi de la position
  Future<void> startLocationTracking() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return;
      }
      
      await _positionStreamSubscription?.cancel();
      
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 100, // Mise à jour tous les 100m
        ),
      ).listen(
        (position) {
          _positionStreamController?.add(position);
        },
        onError: (error) {
          // Log location stream error: $error
        },
      );
    } catch (e) {
      // Log error: $e
    }
  }
  
  /// Arrête le suivi de la position
  void stopLocationTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }
  
  /// Calcule la distance entre deux points GPS (en kilomètres)
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const earthRadius = 6371; // Rayon de la Terre en km
    
    final dLat = _toRadians(endLatitude - startLatitude);
    final dLon = _toRadians(endLongitude - startLongitude);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(startLatitude)) *
            math.cos(_toRadians(endLatitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  /// Convertit les degrés en radians
  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }
  
  /// Libère les ressources
  void dispose() {
    stopLocationTracking();
    _positionStreamController?.close();
    _positionStreamController = null;
  }
}