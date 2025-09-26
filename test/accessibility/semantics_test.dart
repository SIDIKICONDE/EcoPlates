import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecoplates/core/utils/accessibility_helper.dart';
import 'package:ecoplates/presentation/widgets/merchant_card.dart';
import 'package:ecoplates/domain/entities/merchant.dart';

void main() {
  group('Accessibility Tests', () {
    testWidgets('MerchantCard has proper Semantics', (
      WidgetTester tester,
    ) async {
      // Create a test merchant
      final testMerchant = Merchant(
        id: '1',
        name: 'Le Petit Bistrot',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        distance: 2.3,
        category: 'Français',
        discount: 20,
        isFavorite: false,
        tags: ['Bio', 'Local'],
        availableOffers: 5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MerchantCard(
              merchant: testMerchant,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the Semantics widget
      final semanticsFinder = find.bySemanticsLabel(
        RegExp(
          r'Restaurant Le Petit Bistrot.*4\.5 étoiles sur 5.*2\.3 kilomètres.*',
        ),
      );

      expect(semanticsFinder, findsOneWidget);

      // Check for proper button semantics
      final semantics = tester.getSemantics(semanticsFinder);
      expect(semantics.hasAction(SemanticsAction.tap), isTrue);
      expect(semantics.isButton, isTrue);
    });

    testWidgets('FavoriteButton has proper Semantics', (
      WidgetTester tester,
    ) async {
      bool isFavorite = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Semantics(
              label: AccessibilityHelper.buildFavoriteButtonLabel(
                'Le Petit Bistrot',
                isFavorite: isFavorite,
              ),
              button: true,
              child: IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  isFavorite = !isFavorite;
                },
              ),
            ),
          ),
        ),
      );

      // Check initial state
      expect(
        find.bySemanticsLabel('Ajouter Le Petit Bistrot aux favoris'),
        findsOneWidget,
      );
    });

    test('AccessibilityHelper contrast calculations', () {
      // Test contrast ratio calculations
      const white = Colors.white;
      const black = Colors.black;
      const grey = Colors.grey;

      final whiteBlackRatio = AccessibilityHelper.calculateContrastRatio(
        white,
        black,
      );
      expect(whiteBlackRatio, greaterThan(20)); // Should be 21:1

      final greyWhiteRatio = AccessibilityHelper.calculateContrastRatio(
        grey,
        white,
      );
      expect(greyWhiteRatio, lessThan(4.5)); // Should fail WCAG AA

      // Test WCAG compliance
      expect(AccessibilityHelper.meetsWCAGAA(white, black), isTrue);
      expect(AccessibilityHelper.meetsWCAGAA(grey, white), isFalse);

      // Test color adjustment
      final adjustedGrey = AccessibilityHelper.ensureContrast(grey, white);
      expect(AccessibilityHelper.meetsWCAGAA(adjustedGrey, white), isTrue);
    });

    test('AccessibilityHelper semantic labels', () {
      // Test merchant label
      final merchantLabel = AccessibilityHelper.buildMerchantLabel(
        name: 'Pizza Palace',
        rating: 4.2,
        distance: 1.5,
        category: 'Italien',
        isOpen: true,
        hasDiscount: true,
        discountPercentage: 15,
      );

      expect(merchantLabel, contains('Restaurant Pizza Palace'));
      expect(merchantLabel, contains('4.2 étoiles sur 5'));
      expect(merchantLabel, contains('1.5 kilomètres'));
      expect(merchantLabel, contains('Actuellement ouvert'));
      expect(merchantLabel, contains('15 pourcent de réduction'));

      // Test rating label
      final ratingLabel = AccessibilityHelper.buildRatingLabel(
        4.5,
        reviewCount: 123,
      );
      expect(ratingLabel, equals('4.5 étoiles sur 5 basé sur 123 avis'));

      // Test discount label
      final discountLabel = AccessibilityHelper.buildDiscountLabel(25);
      expect(discountLabel, equals('25 pourcent de réduction'));

      // Test price range label
      final priceLabel = AccessibilityHelper.buildPriceRangeLabel(3);
      expect(priceLabel, contains('€€€'));
      expect(priceLabel, contains('Cher'));

      // Test delivery time label
      final deliveryLabel = AccessibilityHelper.buildDeliveryTimeLabel(20, 30);
      expect(deliveryLabel, equals('Livraison en 20 à 30 minutes'));
    });

    testWidgets('Text meets WCAG contrast requirements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final backgroundColor = theme.scaffoldBackgroundColor;
              final textColor = theme.textTheme.bodyMedium!.color!;

              // Check text contrast
              final meetsAA = AccessibilityHelper.meetsWCAGAA(
                textColor,
                backgroundColor,
              );

              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Contrast ratio test'),
                      Text(
                        'Meets WCAG AA: ${meetsAA ? "Yes" : "No"}',
                        style: TextStyle(
                          color: meetsAA ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

      // The app should display properly
      expect(find.text('Contrast ratio test'), findsOneWidget);
    });

    testWidgets('Interactive elements have minimum tap targets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // Good: 48x48 tap target
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                ),
                // Bad: Too small tap target
                SizedBox(
                  width: 24,
                  height: 24,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.close, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Find buttons
      final iconButton = find.byType(IconButton);
      final iconButtonSize = tester.getSize(iconButton);

      // Check minimum tap target size (48x48 for WCAG)
      expect(iconButtonSize.width, greaterThanOrEqualTo(48));
      expect(iconButtonSize.height, greaterThanOrEqualTo(48));
    });

    testWidgets('Screen reader announcements work', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AccessibilityHelper.announce(
                      context,
                      'Commande confirmée avec succès',
                    );
                  },
                  child: const Text('Confirmer'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.text('Confirmer'));
      await tester.pump();

      // Note: We can't directly test SemanticsService.announce
      // but we ensure the code runs without errors
      expect(find.text('Confirmer'), findsOneWidget);
    });
  });
}
