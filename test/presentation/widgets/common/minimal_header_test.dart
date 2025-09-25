import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplates/domain/entities/brand.dart';
import 'package:ecoplates/presentation/providers/brand_provider.dart';
import 'package:ecoplates/presentation/providers/location_state_provider.dart';
import 'package:ecoplates/presentation/providers/user_location_text_provider.dart';
import 'package:ecoplates/presentation/widgets/minimal_header.dart';

void main() {
  group('MinimalHeader', () {
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

    testWidgets('affiche le titre centré', (WidgetTester tester) async {
      // Arrange
      const testTitle = 'Titre de Test';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              appBar: MinimalHeader(title: testTitle),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('affiche le widget leading', (WidgetTester tester) async {
      // Arrange
      const testIcon = Icon(Icons.arrow_back);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              appBar: MinimalHeader(title: 'Test', leading: testIcon),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('affiche les actions', (WidgetTester tester) async {
      // Arrange
      final actions = [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              appBar: MinimalHeader(title: 'Test', actions: actions),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('affiche la localisation au lieu du titre', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            locationStateProvider.overrideWith(
              (ref) => const LocationState(isActive: true),
            ),
            userLocationTextProvider.overrideWith(
              (ref) => const LocationText(
                address: 'Paris, France',
                isLoading: false,
              ),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(
              appBar: const MinimalHeader(showLocationInstead: true),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Paris, France'), findsOneWidget);
    });

    testWidgets('a la hauteur préférée correcte', (WidgetTester tester) async {
      // Arrange
      const testHeight = 64.0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              appBar: MinimalHeader(height: testHeight),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert
      final header = tester.widget<MinimalHeader>(find.byType(MinimalHeader));
      expect(header.preferredSize.height, testHeight);
    });

    testWidgets('masque le divider inférieur quand demandé', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              appBar: MinimalHeader(title: 'Test', showBottomDivider: false),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert - Le widget devrait se construire sans erreur
      expect(find.byType(MinimalHeader), findsOneWidget);
    });

    testWidgets('applique la couleur de fond personnalisée', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customColor = Colors.blue;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              appBar: MinimalHeader(
                title: 'Test',
                backgroundColor: customColor,
              ),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert - Le widget devrait se construire sans erreur
      expect(find.byType(MinimalHeader), findsOneWidget);
    });

    testWidgets('gère le padding horizontal personnalisé', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customPadding = 24.0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              appBar: MinimalHeader(
                title: 'Test',
                horizontalPadding: customPadding,
              ),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert - Le widget devrait se construire sans erreur
      expect(find.byType(MinimalHeader), findsOneWidget);
    });

    testWidgets('gère les actions vides correctement', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [brandsProvider.overrideWith((ref) => testBrands)],
          child: MaterialApp(
            home: Scaffold(
              appBar: MinimalHeader(title: 'Test', actions: []),
              body: Container(),
            ),
          ),
        ),
      );

      // Assert - Le widget devrait se construire sans erreur
      expect(find.byType(MinimalHeader), findsOneWidget);
    });
  });
}
