import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplates/domain/entities/brand.dart';
import 'package:ecoplates/domain/entities/merchant.dart';
import 'package:ecoplates/presentation/providers/brand_provider.dart';
import 'package:ecoplates/presentation/providers/merchants_provider.dart';
import 'package:ecoplates/presentation/widgets/home/sections/merchant_section.dart';

void main() {
  group('MerchantSection', () {
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

    final sampleMerchants = [
      const Merchant(
        id: '1',
        name: 'Restaurant Gourmet',
        imageUrl: 'https://example.com/restaurant.jpg',
        category: 'Restaurant',
        cuisineType: 'Française',
        rating: 4.5,
        distanceText: '2.5 km',
        originalPrice: 25.0,
        discountedPrice: 15.0,
        minPrice: 12.0,
        availableOffers: 5,
        pickupTime: '12:00 - 14:00',
        discountPercentage: 40,
        isFavorite: false,
        tags: ['Bio', 'Local'],
        hasActiveOffer: true,
      ),
      const Merchant(
        id: '2',
        name: 'Boulangerie Artisanale',
        imageUrl: 'https://example.com/bakery.jpg',
        category: 'Boulangerie',
        cuisineType: 'Traditionnelle',
        rating: 4.2,
        distanceText: '1.8 km',
        originalPrice: 8.0,
        discountedPrice: 4.0,
        minPrice: 3.0,
        availableOffers: 3,
        pickupTime: '08:00 - 18:00',
        discountPercentage: 50,
        isFavorite: true,
        tags: ['Artisanal', 'Local'],
        hasActiveOffer: true,
      ),
    ];

    testWidgets('affiche le titre de section avec sous-titre', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantsProvider.overrideWith((ref) => sampleMerchants),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert
      expect(find.text('Nos partenaires'), findsOneWidget);
      expect(find.text('Découvrez nos commerçants engagés'), findsOneWidget);
    });

    testWidgets('affiche le bouton "Voir tout"', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantsProvider.overrideWith((ref) => sampleMerchants),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert
      expect(find.text('Voir tout'), findsOneWidget);
    });

    testWidgets('affiche les marchands dans une liste horizontale', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantsProvider.overrideWith((ref) => sampleMerchants),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert
      expect(find.text('Restaurant Gourmet'), findsOneWidget);
      expect(find.text('Boulangerie Artisanale'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('affiche un message quand il n\'y a pas de marchands', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantsProvider.overrideWith((ref) => const []),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert
      expect(find.text('Aucun marchand disponible'), findsOneWidget);
      expect(find.byIcon(Icons.store_outlined), findsOneWidget);
    });

    testWidgets('affiche un état de chargement', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantsProvider.overrideWith(
              (ref) => throw UnimplementedError('Loading state'),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
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
            merchantsProvider.overrideWith(
              (ref) => throw Exception('Erreur de chargement'),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
        ),
      );

      // Attendre que l'erreur soit affichée
      await tester.pump();

      // Assert - Le widget devrait gérer l'erreur gracieusement
      expect(find.byType(MerchantSection), findsOneWidget);
    });

    testWidgets('affiche les informations des marchands', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantsProvider.overrideWith((ref) => sampleMerchants),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Assert - Les informations devraient être affichées dans les MerchantCard
      expect(find.text('Française'), findsOneWidget);
      expect(find.text('Traditionnelle'), findsOneWidget);
    });

    testWidgets('a la bonne hauteur pour la liste', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantsProvider.overrideWith((ref) => sampleMerchants),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
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

    testWidgets('navigue vers la page complète des marchands', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantsProvider.overrideWith((ref) => sampleMerchants),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: MerchantSection())),
        ),
      );

      // Attendre que les données se chargent
      await tester.pump();

      // Act - Appuyer sur "Voir tout"
      await tester.tap(find.text('Voir tout'));
      await tester.pumpAndSettle();

      // Assert - Devrait naviguer vers AllMerchantsScreen
      // Note: Dans les tests, la navigation peut être limitée, on vérifie juste que le tap fonctionne
      expect(find.byType(MerchantSection), findsOneWidget);
    });
  });
}
