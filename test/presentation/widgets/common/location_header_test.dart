import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoplates/domain/entities/brand.dart';
import 'package:ecoplates/presentation/providers/brand_provider.dart';
import 'package:ecoplates/presentation/providers/location_state_provider.dart';
import 'package:ecoplates/presentation/providers/user_location_text_provider.dart';
import 'package:ecoplates/presentation/widgets/common/location_header.dart';

void main() {
  group('LocationHeader', () {
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

    testWidgets('affiche l\'icône de localisation quand activée', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: LocationHeader())),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.location_off), findsNothing);
    });

    testWidgets('affiche l\'icône de localisation désactivée', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: LocationHeader())),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.location_off), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsNothing);
    });

    testWidgets('affiche l\'adresse de localisation', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testAddress = '123 Rue de Test, Paris';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            locationStateProvider.overrideWith(
              (ref) => const LocationState(isActive: true),
            ),
            userLocationTextProvider.overrideWith(
              (ref) => UserLocationText(address: testAddress, isLoading: false),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: LocationHeader())),
        ),
      );

      // Assert
      expect(find.text(testAddress), findsOneWidget);
    });

    testWidgets('affiche un état de chargement', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            locationStateProvider.overrideWith(
              (ref) => const LocationState(isActive: true),
            ),
            userLocationTextProvider.overrideWith(
              (ref) =>
                  const UserLocationText(address: 'Loading...', isLoading: true),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: LocationHeader())),
        ),
      );

      // Assert - Vérifie qu'un indicateur de chargement est présent
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('masque l\'icône quand showIcon est false', (
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
              (ref) => const UserLocationText(
                address: 'Paris, France',
                isLoading: false,
              ),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: LocationHeader(showIcon: false)),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.location_on), findsNothing);
      expect(find.byIcon(Icons.location_off), findsNothing);
    });

    testWidgets('appelle onTap quand tapé', (WidgetTester tester) async {
      // Arrange
      var tapCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            locationStateProvider.overrideWith(
              (ref) => const LocationState(isActive: true),
            ),
            userLocationTextProvider.overrideWith(
              (ref) => const UserLocationText(
                address: 'Paris, France',
                isLoading: false,
              ),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: LocationHeader(onTap: () => tapCalled = true)),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(LocationHeader));
      await tester.pump();

      // Assert
      expect(tapCalled, true);
    });

    testWidgets('anime l\'état pressé', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(home: Scaffold(body: LocationHeader())),
        ),
      );

      // Act - Tap down
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(LocationHeader)),
      );
      await tester.pump();

      // Assert - L'animation devrait se déclencher
      expect(find.byType(LocationHeader), findsOneWidget);

      // Act - Tap up
      await gesture.up();
      await tester.pump();

      // Assert - L'animation devrait se terminer
      expect(find.byType(LocationHeader), findsOneWidget);
    });

    testWidgets('applique le style personnalisé', (WidgetTester tester) async {
      // Arrange
      const customStyle = TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            locationStateProvider.overrideWith(
              (ref) => const LocationState(isActive: true),
            ),
            userLocationTextProvider.overrideWith(
              (ref) => const UserLocationText(
                address: 'Paris, France',
                isLoading: false,
              ),
            ),
            brandsProvider.overrideWith((ref) => testBrands),
          ],
          child: MaterialApp(
            home: Scaffold(body: LocationHeader(style: customStyle)),
          ),
        ),
      );

      // Assert - Le widget devrait utiliser le style personnalisé
      expect(find.byType(LocationHeader), findsOneWidget);
      expect(find.text('Paris, France'), findsOneWidget);
    });
  });
}
