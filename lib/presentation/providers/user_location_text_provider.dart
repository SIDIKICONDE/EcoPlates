import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/services/geo_location_service.dart';
import '../../core/services/geocoding_service.dart';
import 'location_state_provider.dart';

/// État de la localisation textuelle
class UserLocationText {
  const UserLocationText({
    this.address = 'Localisation...',
    this.isLoading = false,
    this.hasError = false,
  });
  
  final String address;
  final bool isLoading;
  final bool hasError;
  
  UserLocationText copyWith({
    String? address,
    bool? isLoading,
    bool? hasError,
  }) {
    return UserLocationText(
      address: address ?? this.address,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

/// Notifier pour gérer l'état de la localisation textuelle
class UserLocationTextNotifier extends StateNotifier<UserLocationText> {
  UserLocationTextNotifier(this.ref) : super(const UserLocationText()) {
    _init();
  }
  
  final Ref ref;
  final _geocodingService = GeocodingService.instance;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _debounceTimer;
  
  void _init() {
    // Écouter les changements d'état de localisation
    ref.listen(locationStateProvider, (previous, next) {
      if (next.isActive && next.currentPosition != null) {
        _updateAddressFromPosition(next.currentPosition!);
        _startListeningToPositionChanges();
      } else if (!next.isActive) {
        _stopListeningToPositionChanges();
        state = const UserLocationText(address: 'Activer la localisation');
      }
    });
    
    // Vérifier l'état initial
    final locationState = ref.read(locationStateProvider);
    if (locationState.isActive && locationState.currentPosition != null) {
      _updateAddressFromPosition(locationState.currentPosition!);
      _startListeningToPositionChanges();
    }
  }
  
  void _startListeningToPositionChanges() {
    _positionSubscription?.cancel();
    
    // Écouter les changements de position
    _positionSubscription = GeoLocationService.instance.positionStream.listen(
      (position) {
        // Debouncer pour éviter trop d'appels API
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 3), () {
          _updateAddressFromPosition(position);
        });
      },
    );
  }
  
  void _stopListeningToPositionChanges() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
  
  Future<void> _updateAddressFromPosition(Position position) async {
    state = state.copyWith(isLoading: true, hasError: false);
    
    try {
      final address = await _geocodingService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (address != null && mounted) {
        state = UserLocationText(
          address: address,
        );
      } else if (mounted) {
        state = const UserLocationText(
          address: 'Position actuelle',
        );
      }
    } catch (e) {
      if (mounted) {
        state = const UserLocationText(
          address: 'Erreur de localisation',
          hasError: true,
        );
      }
    }
  }
  
  /// Met à jour manuellement l'adresse
  Future<void> refreshAddress() async {
    final locationState = ref.read(locationStateProvider);
    if (locationState.isActive && locationState.currentPosition != null) {
      await _updateAddressFromPosition(locationState.currentPosition!);
    }
  }
  
  @override
  void dispose() {
    _stopListeningToPositionChanges();
    super.dispose();
  }
}

/// Provider pour la localisation textuelle de l'utilisateur
final userLocationTextProvider = StateNotifierProvider<UserLocationTextNotifier, UserLocationText>((ref) {
  return UserLocationTextNotifier(ref);
});