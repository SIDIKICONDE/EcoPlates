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
class UserLocationTextNotifier extends Notifier<UserLocationText> {
  final GeocodingService _geocodingService = GeocodingService.instance;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _debounceTimer;

  @override
  UserLocationText build() {
    _init();
    return const UserLocationText();
  }

  void _init() {
    // Écouter les changements d'état de localisation
    ref.listen(locationStateProvider, (previous, next) {
      if (next.isActive && next.currentPosition != null) {
        unawaited(_updateAddressFromPosition(next.currentPosition!));
        unawaited(_startListeningToPositionChanges());
      } else if (!next.isActive) {
        _stopListeningToPositionChanges();
        state = const UserLocationText(address: 'Activer la localisation');
      }
    });

    // Vérifier l'état initial
    final locationState = ref.read(locationStateProvider);
    if (locationState.isActive && locationState.currentPosition != null) {
      unawaited(_updateAddressFromPosition(locationState.currentPosition!));
      unawaited(_startListeningToPositionChanges());
    }
  }

  Future<void> _startListeningToPositionChanges() async {
    await _positionSubscription?.cancel();

    // Écouter les changements de position
    _positionSubscription = GeoLocationService.instance.positionStream.listen(
      (position) {
        // Debouncer pour éviter trop d'appels API
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 3), () {
          unawaited(_updateAddressFromPosition(position));
        });
      },
    );
  }

  void _stopListeningToPositionChanges() {
    unawaited(_positionSubscription?.cancel());
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

      if (address != null) {
        state = UserLocationText(
          address: address,
        );
      } else {
        state = const UserLocationText(
          address: 'Position actuelle',
        );
      }
    } on Exception {
      state = const UserLocationText(
        address: 'Erreur de localisation',
        hasError: true,
      );
    }
  }

  /// Met à jour manuellement l'adresse
  Future<void> refreshAddress() async {
    final locationState = ref.read(locationStateProvider);
    if (locationState.isActive && locationState.currentPosition != null) {
      await _updateAddressFromPosition(locationState.currentPosition!);
    }
  }

  void dispose() {
    _stopListeningToPositionChanges();
  }
}

/// Provider pour la localisation textuelle de l'utilisateur
final userLocationTextProvider =
    NotifierProvider<UserLocationTextNotifier, UserLocationText>(
      UserLocationTextNotifier.new,
    );
