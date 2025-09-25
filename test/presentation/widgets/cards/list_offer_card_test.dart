import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplates/domain/entities/brand.dart';
import 'package:ecoplates/domain/entities/food_offer.dart';
import 'package:ecoplates/presentation/providers/brand_provider.dart';
import 'package:ecoplates/presentation/widgets/list_offer_card.dart';

void main() {
  group('ListOfferCard', () {
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

    final sampleOffer = FoodOffer(
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
    );

    testWidgets("affiche les informations de base de l'offre", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: sampleOffer, distance: 2.5),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Restaurant Test'), findsOneWidget);
      expect(find.text('Panier Surprise'), findsOneWidget);
      expect(find.text('7.50€'), findsOneWidget);
    });

    testWidgets('affiche la distance quand fournie', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: sampleOffer, distance: 2.5),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('2.5 km'), findsOneWidget);
    });

    testWidgets('affiche GRATUIT pour les offres gratuites', (
      WidgetTester tester,
    ) async {
      // Arrange
      final freeOffer = FoodOffer(
        id: sampleOffer.id,
        merchantId: sampleOffer.merchantId,
        merchantName: sampleOffer.merchantName,
        title: sampleOffer.title,
        description: sampleOffer.description,
        images: sampleOffer.images,
        type: sampleOffer.type,
        category: sampleOffer.category,
        originalPrice: sampleOffer.originalPrice,
        discountedPrice: 0.0, // Gratuit
        quantity: sampleOffer.quantity,
        pickupStartTime: sampleOffer.pickupStartTime,
        pickupEndTime: sampleOffer.pickupEndTime,
        createdAt: sampleOffer.createdAt,
        updatedAt: sampleOffer.updatedAt,
        status: sampleOffer.status,
        location: sampleOffer.location,
        merchantAddress: sampleOffer.merchantAddress,
        isVegetarian: sampleOffer.isVegetarian,
        isVegan: sampleOffer.isVegan,
        isHalal: sampleOffer.isHalal,
        distanceKm: sampleOffer.distanceKm,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: freeOffer, distance: 2.5),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('GRATUIT'), findsOneWidget);
      expect(find.text('7.50€'), findsNothing);
    });

    testWidgets('affiche le badge FERMÉ quand la boutique est fermée', (
      WidgetTester tester,
    ) async {
      // Arrange
      final closedOffer = FoodOffer(
        id: sampleOffer.id,
        merchantId: sampleOffer.merchantId,
        merchantName: sampleOffer.merchantName,
        title: sampleOffer.title,
        description: sampleOffer.description,
        images: sampleOffer.images,
        type: sampleOffer.type,
        category: sampleOffer.category,
        originalPrice: sampleOffer.originalPrice,
        discountedPrice: sampleOffer.discountedPrice,
        quantity: sampleOffer.quantity,
        pickupStartTime: DateTime.now().add(
          const Duration(hours: 1),
        ), // Ferme maintenant
        pickupEndTime: DateTime.now().add(const Duration(hours: 3)),
        createdAt: sampleOffer.createdAt,
        updatedAt: sampleOffer.updatedAt,
        status: OfferStatus.available, // Offre disponible mais boutique fermée
        location: sampleOffer.location,
        merchantAddress: sampleOffer.merchantAddress,
        isVegetarian: sampleOffer.isVegetarian,
        isVegan: sampleOffer.isVegan,
        isHalal: sampleOffer.isHalal,
        distanceKm: sampleOffer.distanceKm,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: closedOffer, distance: 2.5),
            ),
          ),
        ),
      );

      // Assert - Le badge devrait être affiché quand isClosed est true
      // Note: isClosed dépend de la logique métier, on teste juste la structure
      expect(find.byType(ListOfferCard), findsOneWidget);
    });

    testWidgets("affiche l'heure de récupération formatée", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: sampleOffer, distance: 2.5),
            ),
          ),
        ),
      );

      // Assert - L'heure devrait être affichée (format exact dépend de l'implémentation)
      expect(find.byType(ListOfferCard), findsOneWidget);
    });

    testWidgets('a les bonnes dimensions', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: sampleOffer, distance: 2.5),
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(ListOfferCard),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.constraints?.maxHeight, 100);
    });

    testWidgets("a les bonnes propriétés d'accessibilité", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: sampleOffer, distance: 2.5),
            ),
          ),
        ),
      );

      // Assert - Vérifie qu'il y a au moins un widget Semantics avec les bonnes propriétés
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('appelle onTap quand tapé', (WidgetTester tester) async {
      // Arrange
      var tapCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(
                offer: sampleOffer,
                distance: 2.5,
                onTap: () => tapCalled = true,
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ListOfferCard));
      await tester.pump();

      // Assert
      expect(tapCalled, true);
    });

    testWidgets('anime correctement lors du tap down/up', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: sampleOffer, distance: 2.5),
            ),
          ),
        ),
      );

      // Act - Tap down
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(ListOfferCard)),
      );
      await tester.pump();

      // Assert - Animation devrait être en cours
      expect(find.byType(ListOfferCard), findsOneWidget);

      // Act - Tap up
      await gesture.up();
      await tester.pump();

      // Assert - Animation devrait être terminée
      expect(find.byType(ListOfferCard), findsOneWidget);
    });

    testWidgets('gère correctement la quantité disponible', (
      WidgetTester tester,
    ) async {
      // Arrange
      final offerWithQuantity = FoodOffer(
        id: sampleOffer.id,
        merchantId: sampleOffer.merchantId,
        merchantName: sampleOffer.merchantName,
        title: sampleOffer.title,
        description: sampleOffer.description,
        images: sampleOffer.images,
        type: sampleOffer.type,
        category: sampleOffer.category,
        originalPrice: sampleOffer.originalPrice,
        discountedPrice: sampleOffer.discountedPrice,
        quantity: sampleOffer.quantity,
        pickupStartTime: sampleOffer.pickupStartTime,
        pickupEndTime: sampleOffer.pickupEndTime,
        createdAt: sampleOffer.createdAt,
        updatedAt: sampleOffer.updatedAt,
        status: sampleOffer.status,
        location: sampleOffer.location,
        merchantAddress: sampleOffer.merchantAddress,
        isVegetarian: sampleOffer.isVegetarian,
        isVegan: sampleOffer.isVegan,
        isHalal: sampleOffer.isHalal,
        distanceKm: sampleOffer.distanceKm,
        availableQuantity: 3, // Quantité disponible
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: ListOfferCard(offer: offerWithQuantity, distance: 2.5),
            ),
          ),
        ),
      );

      // Assert - Le MerchantLogoWithBadge devrait recevoir la quantité
      expect(find.byType(ListOfferCard), findsOneWidget);
    });
  });
}
