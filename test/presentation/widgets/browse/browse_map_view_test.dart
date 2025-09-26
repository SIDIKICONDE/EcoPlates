import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ecoplates/domain/entities/food_offer.dart';
import 'package:ecoplates/presentation/providers/browse_search_provider.dart';
import 'package:ecoplates/presentation/widgets/browse/browse_map_view.dart';

class TestLocationActiveNotifier extends LocationActiveNotifier {
  TestLocationActiveNotifier(bool initialState) {
    state = initialState;
  }
}

void main() {
  group('BrowseMapView', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    final sampleOffers = [
      FoodOffer(
        id: '1',
        merchantId: 'merchant1',
        merchantName: 'Restaurant Test',
        title: 'Panier Surprise',
        description: 'Panier avec produits frais',
        images: ['image1.jpg'],
        type: OfferType.panier,
        category: FoodCategory.diner,
        originalPrice: 15,
        discountedPrice: 7.50,
        quantity: 5,
        pickupStartTime: DateTime.now().subtract(const Duration(hours: 1)),
        pickupEndTime: DateTime.now().add(const Duration(hours: 2)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: OfferStatus.available,
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: '123 Rue de Test',
          city: 'Paris',
          postalCode: '75001',
        ),
        merchantAddress: '123 Rue de Test, Paris',
        isVegetarian: true,
        distanceKm: 2.5,
      ),
    ];

    testWidgets('affiche la carte avec les éléments principaux', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
            centerMapOnUserProvider.overrideWith((ref) => Future.value()),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseMapView(offers: sampleOffers)),
          ),
        ),
      );

      // Attendre que les postFrameCallbacks soient exécutés
      await tester.pump();

      // Assert
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.near_me_outlined), findsOneWidget);
    });

    testWidgets("change l'icône du bouton selon l'état de localisation", (
      WidgetTester tester,
    ) async {
      // Arrange - Test avec localisation active
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(true),
            ),
            centerMapOnUserProvider.overrideWith((ref) => Future.value()),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseMapView(offers: sampleOffers)),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.near_me), findsOneWidget);
    });

    testWidgets('le bouton de centrage est présent', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
            centerMapOnUserProvider.overrideWith((ref) => Future.value()),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseMapView(offers: sampleOffers)),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('affiche la position initiale correcte', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
            centerMapOnUserProvider.overrideWith((ref) => Future.value()),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseMapView(offers: sampleOffers)),
          ),
        ),
      );

      await tester.pump();

      // Assert
      final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
      expect(googleMap.initialCameraPosition.target.latitude, 48.8566);
      expect(googleMap.initialCameraPosition.target.longitude, 2.3522);
      expect(googleMap.initialCameraPosition.zoom, 12);
    });
  });
}
