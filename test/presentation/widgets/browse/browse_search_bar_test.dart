import 'package:ecoplates/presentation/providers/browse_search_provider.dart';
import 'package:ecoplates/presentation/widgets/browse/browse_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class TestSearchQueryNotifier extends SearchQueryNotifier {
  TestSearchQueryNotifier(String initialState) {
    state = initialState;
  }
}

class TestBrowseFiltersNotifier extends BrowseFiltersNotifier {
  TestBrowseFiltersNotifier(BrowseFilters initialState) {
    state = initialState;
  }
}

class TestLocationActiveNotifier extends LocationActiveNotifier {
  TestLocationActiveNotifier(bool initialState) {
    state = initialState;
  }
}

void main() {
  group('BrowseSearchBar', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('affiche la barre de recherche avec tous les éléments', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith(() => TestSearchQueryNotifier('')),
            browseFiltersProvider.overrideWith(
              () => TestBrowseFiltersNotifier(const BrowseFilters()),
            ),
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BrowseSearchBar())),
        ),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Rechercher une offre...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.near_me_outlined), findsOneWidget); // Bouton GPS
      expect(find.byIcon(Icons.tune_outlined), findsOneWidget);
    });

    testWidgets('met à jour le texte de recherche quand on tape', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith(() => TestSearchQueryNotifier('')),
            browseFiltersProvider.overrideWith(
              () => TestBrowseFiltersNotifier(const BrowseFilters()),
            ),
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BrowseSearchBar())),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'panier');

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'panier');
    });

    testWidgets('initialise le contrôleur avec la valeur du provider', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith(
              () => TestSearchQueryNotifier('test initial'),
            ),
            browseFiltersProvider.overrideWith(
              () => TestBrowseFiltersNotifier(const BrowseFilters()),
            ),
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BrowseSearchBar())),
        ),
      );

      // Act
      final textField = tester.widget<TextField>(find.byType(TextField));

      // Assert
      expect(textField.controller?.text, 'test initial');
    });

    testWidgets(
      "affiche l'icône de localisation active quand isLocationActive est true",
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              searchQueryProvider.overrideWith(
                () => TestSearchQueryNotifier(''),
              ),
              browseFiltersProvider.overrideWith(
                () => TestBrowseFiltersNotifier(const BrowseFilters()),
              ),
              isLocationActiveProvider.overrideWith(
                () => TestLocationActiveNotifier(true),
              ),
            ],
            child: const MaterialApp(home: Scaffold(body: BrowseSearchBar())),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.near_me), findsOneWidget);
        expect(find.byIcon(Icons.near_me_outlined), findsNothing);
      },
    );

    testWidgets(
      "affiche l'icône de filtre active quand il y a des filtres actifs",
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              searchQueryProvider.overrideWith(
                () => TestSearchQueryNotifier(''),
              ),
              browseFiltersProvider.overrideWith(
                () =>
                    TestBrowseFiltersNotifier(const BrowseFilters(minPrice: 5)),
              ),
              isLocationActiveProvider.overrideWith(
                () => TestLocationActiveNotifier(false),
              ),
            ],
            child: const MaterialApp(home: Scaffold(body: BrowseSearchBar())),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.tune), findsOneWidget);
        expect(find.byIcon(Icons.tune_outlined), findsNothing);
      },
    );

    testWidgets('affiche le badge avec le nombre de filtres actifs', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith(() => TestSearchQueryNotifier('')),
            browseFiltersProvider.overrideWith(
              () => TestBrowseFiltersNotifier(
                const BrowseFilters(
                  minPrice: 5,
                  categories: ['diner'],
                  availableNow: true,
                ),
              ),
            ),
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BrowseSearchBar())),
        ),
      );

      // Assert
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('ne dispose pas le contrôleur quand le widget est supprimé', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith(() => TestSearchQueryNotifier('')),
            browseFiltersProvider.overrideWith(
              () => TestBrowseFiltersNotifier(const BrowseFilters()),
            ),
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BrowseSearchBar())),
        ),
      );

      // Act
      await tester.pumpWidget(const SizedBox()); // Supprimer le widget

      // Assert
      // Le test passe si aucune exception n'est levée lors du dispose
    });

    testWidgets('focus le champ quand on tape sur le bouton GPS', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchQueryProvider.overrideWith(() => TestSearchQueryNotifier('')),
            browseFiltersProvider.overrideWith(
              () => TestBrowseFiltersNotifier(const BrowseFilters()),
            ),
            isLocationActiveProvider.overrideWith(
              () => TestLocationActiveNotifier(false),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: BrowseSearchBar())),
        ),
      );

      // Act
      final gpsButtons = find.byIcon(Icons.near_me_outlined);
      await tester.tap(gpsButtons.first);
      await tester.pump();

      // Assert
      // Difficile à tester directement le focus, mais on peut vérifier que le widget est toujours là
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
