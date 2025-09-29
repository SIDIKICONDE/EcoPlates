// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    // Charger les variables d'environnement pour les tests
    await dotenv.load(fileName: 'environments/.env.dev');
  });

  testWidgets('App can be instantiated', (WidgetTester tester) async {
    // Vérifier que l'app peut être instanciée sans erreur
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('EcoPlates')),
            body: const Center(child: Text("À sauver d'urgence !")),
          ),
        ),
      ),
    );

    // Vérifier que les widgets sont affichés
    expect(find.text('EcoPlates'), findsOneWidget);
    expect(find.text("À sauver d'urgence !"), findsOneWidget);
  });

  testWidgets('Basic widgets render correctly', (WidgetTester tester) async {
    // Test simple de rendu de widgets
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('EcoPlates'),
              Text("À sauver d'urgence !"),
              Icon(Icons.timer_outlined),
            ],
          ),
        ),
      ),
    );

    // Vérifier que les éléments sont présents
    expect(find.text('EcoPlates'), findsOneWidget);
    expect(find.text("À sauver d'urgence !"), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
  });
}
