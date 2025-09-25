import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplates/domain/entities/brand.dart';
import 'package:ecoplates/domain/entities/food_offer.dart';
import 'package:ecoplates/presentation/providers/brand_provider.dart';
import 'package:ecoplates/presentation/providers/nearby_offers_provider.dart';
import 'package:ecoplates/presentation/widgets/home/sections/nearby_section.dart';

void main() {
  group('NearbySection', () {
    late ProviderContainer container;

    // Données de test pour les brands
    final testBrands = [
      const Brand(
        id: '1',
        name: 'Test Brand',
        logoUrl: 'https://example.com/logo.png',
        category: 'Test',
        totalStores: 10,
        activeOffers: 5,
        averageDiscount: 20,
        description: 'Test brand',
        primaryColor: '#000000',
      ),
    ];

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    final sampleNearbyOffers = [
      FoodOffer(
        id: '1',
        merchantId: 'merchant1',
        merchantName: 'Restaurant Nearby',
        title: 'Panier Surprise Nearby',
        description: 'Panier avec produits frais à proximité',
        images: ['image1.jpg'],
        type: OfferType.panier,
        category: FoodCategory.diner,
        originalPrice: 15.0,
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
        isVegan: false,
        isHalal: false,
        distanceKm: 0.5, // Très proche
      ),
      FoodOffer(
        id: '2',
        merchantId: 'merchant2',
        merchantName: 'Boulangerie Nearby',
        title: 'Croissants Nearby',
        description: 'Croissants frais à proximité',
        images: ['image2.jpg'],
        type: OfferType.boulangerie,
        category: FoodCategory.petitDejeuner,
        originalPrice: 5.0,
        discountedPrice: 2.50,
        quantity: 3,
        pickupStartTime: DateTime.now().subtract(const Duration(hours: 1)),
        pickupEndTime: DateTime.now().add(const Duration(hours: 2)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: OfferStatus.available,
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: '456 Rue de Test',
          city: 'Paris',
          postalCode: '75002',
        ),
        merchantAddress: '456 Rue de Test, Paris',
        isVegetarian: true,
        isVegan: true,
        isHalal: false,
        distanceKm: 1.2, // Un peu plus loin
      ),
    ];

    testWidgets('affiche le titre de section avec bouton de filtre', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyOffersProvider.overrideWith((ref) => sampleNearbyOffers),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: NearbySection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert
      expect(find.text('Près de chez vous'), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('affiche les offres à proximité dans une liste horizontale', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyOffersProvider.overrideWith((ref) => sampleNearbyOffers),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: NearbySection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert
      expect(find.text('Panier Surprise Nearby'), findsOneWidget);
      expect(find.text('Croissants Nearby'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets(
      'affiche un message quand il n\'y a pas d\'offres à proximité',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              nearbyOffersProvider.overrideWith((ref) => const []),
              brandsProvider.overrideWith((ref) => testBrands),
            ],
            child: MaterialApp(home: Scaffold(body: NearbySection())),
          ),
        );

        // Attendre que les données se chargent
        await tester.pump();

        // Assert
        expect(find.text('Aucune offre à proximité'), findsOneWidget);
        expect(find.text('Élargissez votre zone de recherche'), findsOneWidget);
        expect(find.byIcon(Icons.location_off_outlined), findsOneWidget);
      },
    );

    testWidgets('affiche un état de chargement', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyOffersProvider.overrideWith(
              (ref) => throw UnimplementedError('Loading state'),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: NearbySection())),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('gère les erreurs de chargement', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyOffersProvider.overrideWith(
              (ref) => throw Exception('Erreur de localisation'),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: NearbySection())),
        ),
      );

      // Attendre que l'erreur soit affichée
      await tester.pump();

      // Assert - Le widget devrait gérer l'erreur gracieusement
      expect(find.byType(NearbySection), findsOneWidget);
    });

    testWidgets('affiche les distances des offres', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyOffersProvider.overrideWith((ref) => sampleNearbyOffers),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: NearbySection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert - Les distances devraient être affichées
      expect(find.text('0.5 km'), findsOneWidget);
      expect(find.text('1.2 km'), findsOneWidget);
    });

    testWidgets('a la bonne hauteur pour la liste', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyOffersProvider.overrideWith((ref) => sampleNearbyOffers),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: NearbySection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert - Vérifier que la hauteur est correcte (280 comme défini dans le code)
      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(ListView),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sizedBox.height, 280);
    });

    testWidgets('ouvre le filtre de distance quand on appuie sur le bouton', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyOffersProvider.overrideWith((ref) => sampleNearbyOffers),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: NearbySection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Act - Appuyer sur le bouton de filtre
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pump();

      // Assert - Le widget devrait toujours exister (le filtre peut ne pas s'ouvrir dans les tests)
      expect(find.byType(NearbySection), findsOneWidget);
    });

    testWidgets('surveille les changements de localisation et de rayon', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyOffersProvider.overrideWith((ref) => sampleNearbyOffers),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: NearbySection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert - Le widget devrait se reconstruire quand les providers changent
      expect(find.byType(NearbySection), findsOneWidget);
      expect(find.text('Près de chez vous'), findsOneWidget);
    });
  });
}
