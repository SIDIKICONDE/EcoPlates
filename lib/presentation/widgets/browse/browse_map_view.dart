import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/geo_location_service.dart';
import '../../../core/services/map_service.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/browse_search_provider.dart';

/// Vue carte des offres pour la page Parcourir
class BrowseMapView extends ConsumerStatefulWidget {
  const BrowseMapView({required this.offers, super.key});

  final List<FoodOffer> offers;

  @override
  ConsumerState<BrowseMapView> createState() => _BrowseMapViewState();
}

class _BrowseMapViewState extends ConsumerState<BrowseMapView> {
  // Utiliser l'instance singleton pour éviter les reconstructions infinies
  MapService get _mapService => MapService.instance;

  // Position initiale (Paris centre par défaut)
  static const LatLng _initialPosition = LatLng(48.8566, 2.3522);

  @override
  void initState() {
    super.initState();
    _mapService.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMarkers();
    });
  }

  @override
  void didUpdateWidget(BrowseMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.offers != widget.offers) {
      _updateMarkers();
    }
  }

  void _updateMarkers() {
    _mapService.updateMarkers(widget.offers);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapService.mapController = controller;

    // Essayer de centrer sur la position utilisateur en priorité
    _tryCenterOnUserLocation();
  }

  Future<void> _tryCenterOnUserLocation() async {
    try {
      final position = await GeoLocationService.instance.getCurrentPosition();
      if (position != null) {
        // Ajouter le marqueur de position utilisateur et centrer
        _mapService.updateUserLocationMarker(position);
        await _mapService.centerOnUserLocation();
      } else {
        // Fallback : montrer toutes les offres si disponibles
        if (widget.offers.isNotEmpty) {
          await _mapService.showAllOffers(widget.offers);
        }
      }
    } catch (e) {
      // En cas d'erreur, montrer les offres si disponibles
      if (widget.offers.isNotEmpty) {
        await _mapService.showAllOffers(widget.offers);
      }
    }
  }

  Future<void> _centerOnUserLocation() async {
    try {
      // Activer automatiquement la localisation si elle n'est pas activée
      final isLocationActive = ref.read(isLocationActiveProvider);
      if (!isLocationActive) {
        ref.read(isLocationActiveProvider.notifier).state = true;
      }

      // Utiliser le provider pour centrer la carte et attendre le résultat
      await ref.read(centerMapOnUserProvider.future);
    } catch (e) {
      // Ne rien afficher en cas d'erreur de localisation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Carte Google Maps avec StreamBuilder pour les marqueurs
        StreamBuilder<Set<Marker>>(
          stream: _mapService.markersStream,
          initialData: _mapService.markers,
          builder: (context, snapshot) {
            final markers = snapshot.data ?? {};
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              onMapCreated: _onMapCreated,
              markers: markers,
              myLocationButtonEnabled:
                  false, // Nous utilisons notre propre bouton
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              buildingsEnabled: false,
            );
          },
        ),

        // Bouton de recentrage
        Positioned(
          bottom: 16,
          right: 16,
          child: Consumer(
            builder: (context, ref, child) {
              final isLocationActive = ref.watch(isLocationActiveProvider);
              return FloatingActionButton(
                mini: true,
                onPressed: _centerOnUserLocation,
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                child: Icon(
                  isLocationActive ? Icons.near_me : Icons.near_me_outlined,
                  color: isLocationActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Ne pas disposer le singleton ici car il peut être utilisé ailleurs
    super.dispose();
  }
}
