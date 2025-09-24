import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../domain/entities/food_offer.dart';

/// Service pour gérer la carte Google Maps et les marqueurs d'offres
class MapService {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final StreamController<Set<Marker>> _markersController = StreamController<Set<Marker>>.broadcast();

  /// Instance singleton
  static MapService? _instance;

  /// Obtenir l'instance singleton
  static MapService get instance {
    _instance ??= MapService._();
    return _instance!;
  }

  /// Constructeur privé pour singleton
  MapService._();

  /// Constructeur public (pour compatibilité)
  factory MapService() => instance;

  /// Stream des marqueurs pour mettre à jour l'UI
  Stream<Set<Marker>> get markersStream => _markersController.stream;

  /// Marqueurs actuels
  Set<Marker> get markers => _markers;

  /// Contrôleur de la carte
  GoogleMapController? get mapController => _mapController;

  /// Initialise le service
  void initialize() {
    // Configuration initiale si nécessaire
  }

  /// Définit le contrôleur de la carte
  set mapController(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Met à jour les marqueurs pour les offres données
  void updateMarkers(List<FoodOffer> offers) {
    _markers.clear();

    for (final offer in offers) {
      if (offer.location.latitude != 0 && offer.location.longitude != 0) {
        final marker = Marker(
          markerId: MarkerId(offer.id),
          position: LatLng(offer.location.latitude, offer.location.longitude),
          infoWindow: InfoWindow(
            title: offer.merchantName,
            snippet: '${offer.title} - ${offer.priceText}',
            onTap: () {
              // Navigation vers les détails de l'offre
              _onMarkerTapped(offer);
            },
          ),
          icon: _getMarkerIcon(offer),
          onTap: () {
            // Animation ou zoom sur le marqueur
            _animateToMarker(offer.location.latitude, offer.location.longitude);
          },
        );
        _markers.add(marker);
      }
    }

    _markersController.add(_markers);
  }

  /// Obtient l'icône du marqueur selon le type d'offre
  BitmapDescriptor _getMarkerIcon(FoodOffer offer) {
    // Par défaut, utiliser l'icône standard
    // TODO: Personnaliser selon le type d'offre (panier, plat, etc.)
    return BitmapDescriptor.defaultMarkerWithHue(
      offer.isFree ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueOrange,
    );
  }

  /// Anime la carte vers une position donnée
  Future<void> _animateToMarker(double latitude, double longitude) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(latitude, longitude),
          16.0, // Zoom niveau rue
        ),
      );
    }
  }

  /// Gère le tap sur un marqueur
  void _onMarkerTapped(FoodOffer offer) {
    // TODO: Implémenter la navigation vers les détails de l'offre
    print("Marqueur tapé pour l'offre: ${offer.title}");
  }

  /// Obtient la position actuelle de l'utilisateur
  Future<Position?> getCurrentPosition() async {
    try {
      // Vérifier les permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Obtenir la position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Erreur lors de l'obtention de la position: $e");
      return null;
    }
  }

  /// Centre la carte sur la position actuelle
  Future<void> centerOnUserLocation() async {
    final position = await getCurrentPosition();
    if (position != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14, // Zoom niveau quartier
        ),
      );
    }
  }

  /// Calcule les bounds pour toutes les offres
  LatLngBounds? calculateBounds(List<FoodOffer> offers) {
    if (offers.isEmpty) return null;

    var minLat = double.infinity;
    var maxLat = double.negativeInfinity;
    var minLng = double.infinity;
    var maxLng = double.negativeInfinity;

    for (final offer in offers) {
      final lat = offer.location.latitude;
      final lng = offer.location.longitude;

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  /// Ajuste la caméra pour montrer toutes les offres
  Future<void> showAllOffers(List<FoodOffer> offers) async {
    final bounds = calculateBounds(offers);
    if (bounds != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50), // Padding de 50px
      );
    }
  }

  /// Libère les ressources
  void dispose() {
    _markersController.close();
    _mapController?.dispose();
  }

  /// Réinitialise l'instance singleton (pour les tests)
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}
