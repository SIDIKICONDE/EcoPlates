import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/services/geo_location_service.dart';

/// Provider centralisé pour gérer l'état de localisation dans toute l'application
/// 
/// Synchronise l'état entre tous les boutons GPS de l'interface
class LocationStateNotifier extends StateNotifier<LocationState> {
  LocationStateNotifier(this.ref) : super(const LocationState());
  
  final Ref ref;
  final _geoService = GeoLocationService.instance;

  /// Active/désactive la localisation
  Future<void> toggleLocation() async {
    if (state.isActive) {
      // Désactiver
      _geoService.stopLocationTracking();
      state = state.copyWith(isActive: false);
    } else {
      // Activer
      state = state.copyWith(isActive: true, isLoading: true);
      
      try {
        // Demander la position actuelle
        final position = await _geoService.getCurrentPosition();
        
        if (position != null) {
          // Démarrer le tracking
          await _geoService.startLocationTracking();
          
          state = state.copyWith(
            isActive: true,
            isLoading: false,
            currentPosition: position,
            hasPermission: true,
          );
        } else {
          // Pas de permission ou service désactivé
          state = state.copyWith(
            isActive: false,
            isLoading: false,
            hasPermission: false,
            errorMessage: "Impossible d'activer la localisation",
          );
        }
      } catch (e) {
        state = state.copyWith(
          isActive: false,
          isLoading: false,
          errorMessage: 'Erreur: $e',
        );
      }
    }
  }

  /// Met à jour la position actuelle
  void updatePosition(Position position) {
    if (state.isActive) {
      state = state.copyWith(currentPosition: position);
    }
  }
  
  @override
  void dispose() {
    if (state.isActive) {
      _geoService.stopLocationTracking();
    }
    super.dispose();
  }
}

/// État de la localisation GPS
class LocationState {
  const LocationState({
    this.isActive = false,
    this.isLoading = false,
    this.hasPermission = true,
    this.currentPosition,
    this.errorMessage,
  });

  final bool isActive;
  final bool isLoading;
  final bool hasPermission;
  final Position? currentPosition;
  final String? errorMessage;

  LocationState copyWith({
    bool? isActive,
    bool? isLoading,
    bool? hasPermission,
    Position? currentPosition,
    String? errorMessage,
  }) {
    return LocationState(
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
      currentPosition: currentPosition ?? this.currentPosition,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Provider pour gérer l'état de localisation centralisé
final locationStateProvider = StateNotifierProvider<LocationStateNotifier, LocationState>((ref) {
  return LocationStateNotifier(ref);
});