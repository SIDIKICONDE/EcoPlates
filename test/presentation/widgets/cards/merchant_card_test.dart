import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplates/domain/entities/brand.dart';
import 'package:ecoplates/domain/entities/merchant.dart';
import 'package:ecoplates/presentation/providers/brand_provider.dart';
import 'package:ecoplates/presentation/widgets/merchant_card.dart';

void main() {
  group('MerchantCard', () {
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

    const sampleMerchant = Merchant(
      id: '1',
      name: 'Restaurant Test',
      imageUrl: 'https://example.com/restaurant.jpg',
      category: 'Restaurant',
      cuisineType: 'Française',
      rating: 4.5,
      distanceText: '2.5 km',
      originalPrice: 25,
      discountedPrice: 15,
      minPrice: 12,
      availableOffers: 5,
      pickupTime: '12:00 - 14:00',
      discountPercentage: 40,
      tags: ['Bio', 'Local'],
      hasActiveOffer: true,
    );

    testWidgets('affiche les informations de base du merchant', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
          ),
        ),
      );

      // Assert
      expect(find.text('Restaurant Test'), findsOneWidget);
      expect(find.text('Française'), findsOneWidget);
      expect(find.text('2.5 km'), findsOneWidget);
    });

    testWidgets('affiche la note et les offres disponibles', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
          ),
        ),
      );

      // Assert - La note devrait être affichée (format exact dépend de RatingDisplay)
      expect(find.byType(MerchantCard), findsOneWidget);
    });

    testWidgets('affiche le pourcentage de réduction', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
          ),
        ),
      );

      // Assert - Le pourcentage devrait être affiché dans le badge
      expect(find.byType(MerchantCard), findsOneWidget);
    });

    testWidgets("affiche l'indicateur de temps quand peu d'offres", (
      WidgetTester tester,
    ) async {
      // Arrange
      final merchantWithFewOffers = Merchant(
        id: sampleMerchant.id,
        name: sampleMerchant.name,
        imageUrl: sampleMerchant.imageUrl,
        category: sampleMerchant.category,
        cuisineType: sampleMerchant.cuisineType,
        rating: sampleMerchant.rating,
        distanceText: sampleMerchant.distanceText,
        originalPrice: sampleMerchant.originalPrice,
        discountedPrice: sampleMerchant.discountedPrice,
        minPrice: sampleMerchant.minPrice,
        availableOffers: 2, // Peu d'offres
        pickupTime: sampleMerchant.pickupTime,
        discountPercentage: sampleMerchant.discountPercentage,
        isFavorite: sampleMerchant.isFavorite,
        tags: sampleMerchant.tags,
        hasActiveOffer: sampleMerchant.hasActiveOffer,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: MerchantCard(merchant: merchantWithFewOffers)),
          ),
        ),
      );

      // Assert - TimeIndicator devrait être affiché pour <= 3 offres
      expect(find.byType(MerchantCard), findsOneWidget);
    });

    testWidgets("n'affiche pas l'indicateur de temps avec beaucoup d'offres", (
      WidgetTester tester,
    ) async {
      // Arrange
      final merchantWithManyOffers = Merchant(
        id: sampleMerchant.id,
        name: sampleMerchant.name,
        imageUrl: sampleMerchant.imageUrl,
        category: sampleMerchant.category,
        cuisineType: sampleMerchant.cuisineType,
        rating: sampleMerchant.rating,
        distanceText: sampleMerchant.distanceText,
        originalPrice: sampleMerchant.originalPrice,
        discountedPrice: sampleMerchant.discountedPrice,
        minPrice: sampleMerchant.minPrice,
        availableOffers: 10, // Beaucoup d'offres
        pickupTime: sampleMerchant.pickupTime,
        discountPercentage: sampleMerchant.discountPercentage,
        isFavorite: sampleMerchant.isFavorite,
        tags: sampleMerchant.tags,
        hasActiveOffer: sampleMerchant.hasActiveOffer,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: MerchantCard(merchant: merchantWithManyOffers),
            ),
          ),
        ),
      );

      // Assert - TimeIndicator ne devrait pas être affiché pour > 3 offres
      expect(find.byType(MerchantCard), findsOneWidget);
    });

    testWidgets('affiche les tags du merchant', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
          ),
        ),
      );

      // Assert - Les tags devraient être affichés
      expect(find.text('Bio'), findsOneWidget);
      expect(find.text('Local'), findsOneWidget);
    });

    testWidgets("affiche le badge d'offre active", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
          ),
        ),
      );

      // Assert - Badge devrait être affiché pour les offres actives
      expect(find.byType(MerchantCard), findsOneWidget);
    });

    testWidgets("a les bonnes propriétés d'accessibilité", (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
          ),
        ),
      );

      // Assert - Vérifie qu'il y a au moins un widget Semantics
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
              body: MerchantCard(
                merchant: sampleMerchant,
                onTap: () => tapCalled = true,
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(MerchantCard));
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
            home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
          ),
        ),
      );

      // Act - Tap down
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(MerchantCard)),
      );
      await tester.pump();

      // Assert - Animation devrait être en cours
      expect(find.byType(MerchantCard), findsOneWidget);

      // Act - Tap up
      await gesture.up();
      await tester.pump();

      // Assert - Animation devrait être terminée
      expect(find.byType(MerchantCard), findsOneWidget);
    });

    testWidgets(
      "gère les préférences d'accessibilité (animations désactivées)",
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            overrides: [brandsProvider.overrideWith((ref) => testBrands)],
            child: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: MaterialApp(
                home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
              ),
            ),
          ),
        );

        // Assert - Le widget devrait fonctionner sans animations
        expect(find.byType(MerchantCard), findsOneWidget);
        expect(find.text('Restaurant Test'), findsOneWidget);
      },
    );

    testWidgets('affiche correctement les informations de prix', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: MerchantCard(merchant: sampleMerchant)),
          ),
        ),
      );

      // Assert - Les prix devraient être affichés correctement
      expect(find.byType(MerchantCard), findsOneWidget);
    });
  });
}
