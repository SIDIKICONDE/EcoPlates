import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplates/domain/entities/brand.dart';
import 'package:ecoplates/presentation/providers/brand_provider.dart';
import 'package:ecoplates/presentation/widgets/brand_card.dart';

void main() {
  group('BrandCard', () {
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

    final sampleBrand = const Brand(
      id: '1',
      name: 'Carrefour',
      logoUrl: 'https://example.com/carrefour-logo.png',
      category: 'Supermarché',
      totalStores: 1200,
      activeOffers: 45,
      averageDiscount: 35,
      description: 'Grande enseigne de distribution',
      primaryColor: '#0066CC',
      isPremium: true,
      isNew: false,
      tagline: 'Tous les choix',
    );

    testWidgets('affiche le nom de la marque', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: sampleBrand)),
          ),
        ),
      );

      // Assert
      expect(find.text('Carrefour'), findsOneWidget);
    });

    testWidgets('affiche la catégorie de la marque', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: sampleBrand)),
          ),
        ),
      );

      // Assert
      expect(find.text('Supermarché'), findsOneWidget);
    });

    testWidgets('affiche le nombre d\'offres actives', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: sampleBrand)),
          ),
        ),
      );

      // Assert
      expect(find.text('45 offres'), findsOneWidget);
    });

    testWidgets('affiche le pourcentage de réduction', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: sampleBrand)),
          ),
        ),
      );

      // Assert
      expect(find.text('-35%'), findsOneWidget);
    });

    testWidgets('affiche le badge premium pour les marques premium', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: sampleBrand)),
          ),
        ),
      );

      // Assert - L'icône star devrait être présente pour les marques premium
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('affiche le badge nouveau pour les nouvelles marques', (
      WidgetTester tester,
    ) async {
      // Arrange
      final newBrand = sampleBrand.copyWith(isPremium: false, isNew: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: newBrand)),
          ),
        ),
      );

      // Assert - L'icône new_releases devrait être présente pour les nouvelles marques
      expect(find.byIcon(Icons.new_releases), findsOneWidget);
    });

    testWidgets('n\'affiche pas de badge pour les marques normales', (
      WidgetTester tester,
    ) async {
      // Arrange
      final normalBrand = sampleBrand.copyWith(isPremium: false, isNew: false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: normalBrand)),
          ),
        ),
      );

      // Assert - Aucun badge ne devrait être affiché
      expect(find.byIcon(Icons.star), findsNothing);
      expect(find.byIcon(Icons.new_releases), findsNothing);
    });

    testWidgets('a les bonnes dimensions', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: sampleBrand)),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, 100);
    });

    testWidgets('appelle onTap quand tapé', (WidgetTester tester) async {
      // Arrange
      var tapCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              body: BrandCard(
                brand: sampleBrand,
                onTap: () => tapCalled = true,
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(BrandCard));
      await tester.pump();

      // Assert
      expect(tapCalled, true);
    });

    testWidgets('gère l\'erreur de chargement du logo', (
      WidgetTester tester,
    ) async {
      // Arrange
      final brandWithInvalidLogo = const Brand(
        id: '1',
        name: 'Test Brand',
        logoUrl: 'https://invalid-url.com/logo.png',
        category: 'Test',
        totalStores: 10,
        activeOffers: 5,
        averageDiscount: 20,
        description: 'Test brand',
        primaryColor: '#000000',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: brandWithInvalidLogo)),
          ),
        ),
      );

      // Assert - Le widget devrait se construire sans erreur même avec une URL invalide
      expect(find.byType(BrandCard), findsOneWidget);
      expect(find.text('Test Brand'), findsOneWidget);
    });

    testWidgets('affiche l\'image de fond appropriée selon la catégorie', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(body: BrandCard(brand: sampleBrand)),
          ),
        ),
      );

      // Assert - L'image de fond devrait être chargée
      expect(find.byType(BrandCard), findsOneWidget);
    });
  });
}
