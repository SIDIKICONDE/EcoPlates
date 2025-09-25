import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplates/domain/entities/brand.dart';
import 'package:ecoplates/domain/entities/food_offer.dart';
import 'package:ecoplates/presentation/providers/brand_provider.dart';
import 'package:ecoplates/presentation/providers/browse_search_provider.dart';
import 'package:ecoplates/presentation/widgets/browse/browse_list_view.dart';

void main() {
  group('BrowseListView', () {
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
      FoodOffer(
        id: '2',
        merchantId: 'merchant2',
        merchantName: 'Boulangerie Test',
        title: 'Croissants Gratuits',
        description: 'Croissants invendus de la journée',
        images: ['image2.jpg'],
        type: OfferType.boulangerie,
        category: FoodCategory.petitDejeuner,
        originalPrice: 5,
        discountedPrice: 0,
        quantity: 10,
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
        distanceKm: 1.2,
      ),
    ];

    testWidgets('affiche la liste des offres correctement', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            browseFiltersProvider.overrideWith((ref) => const BrowseFilters()),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsOneWidget);
      expect(find.text('Croissants Gratuits'), findsOneWidget);
      expect(find.text('Restaurant Test'), findsOneWidget);
      expect(find.text('Boulangerie Test'), findsOneWidget);
    });

    testWidgets('filtre les offres par recherche de titre', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => 'croissant'),
            browseFiltersProvider.overrideWith((ref) => const BrowseFilters()),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsNothing);
      expect(find.text('Croissants Gratuits'), findsOneWidget);
    });

    testWidgets('filtre les offres par recherche de nom de commerçant', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => 'boulangerie'),
            browseFiltersProvider.overrideWith((ref) => const BrowseFilters()),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsNothing);
      expect(find.text('Croissants Gratuits'), findsOneWidget);
    });

    testWidgets('filtre les offres par prix minimum', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            browseFiltersProvider.overrideWith(
              (ref) => const BrowseFilters(minPrice: 5),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsOneWidget);
      expect(find.text('Croissants Gratuits'), findsNothing); // Prix = 0
    });

    testWidgets('filtre les offres par prix maximum', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            browseFiltersProvider.overrideWith(
              (ref) => const BrowseFilters(maxPrice: 5),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsNothing); // Prix = 7.50
      expect(find.text('Croissants Gratuits'), findsOneWidget);
    });

    testWidgets('filtre les offres gratuites uniquement', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            browseFiltersProvider.overrideWith(
              (ref) => const BrowseFilters(freeOnly: true),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsNothing);
      expect(find.text('Croissants Gratuits'), findsOneWidget);
    });

    testWidgets('filtre les offres par catégories', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            browseFiltersProvider.overrideWith(
              (ref) => const BrowseFilters(categories: ['diner']),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsOneWidget);
      expect(find.text('Croissants Gratuits'), findsNothing);
    });

    testWidgets('filtre les offres végétariennes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            browseFiltersProvider.overrideWith(
              (ref) => const BrowseFilters(dietaryPreferences: ['vegetarian']),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsOneWidget);
      expect(find.text('Croissants Gratuits'), findsOneWidget);
    });

    testWidgets('filtre les offres vegans', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            browseFiltersProvider.overrideWith(
              (ref) => const BrowseFilters(dietaryPreferences: ['vegan']),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Panier Surprise'), findsNothing);
      expect(find.text('Croissants Gratuits'), findsOneWidget);
    });

    testWidgets("affiche un message quand aucune offre n'est trouvée", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => 'recherche inexistante'),
            browseFiltersProvider.overrideWith((ref) => const BrowseFilters()),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: BrowseListView(offers: sampleOffers)),
          ),
        ),
      );

      // Assert
      expect(find.text('Aucune offre trouvée'), findsOneWidget);
      expect(find.text('Modifiez vos critères de recherche'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('affiche un message quand la liste est vide', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith((ref) => ''),
            browseFiltersProvider.overrideWith((ref) => const BrowseFilters()),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: const MaterialApp(
            home: Scaffold(body: BrowseListView(offers: [])),
          ),
        ),
      );

      // Assert
      expect(find.text('Aucune offre trouvée'), findsOneWidget);
      expect(find.text('Modifiez vos critères de recherche'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });
  });
}
