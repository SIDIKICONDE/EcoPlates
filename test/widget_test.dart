// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ecoplates/main.dart';

void main() {
  setUpAll(() async {
    // Charger les variables d'environnement pour les tests
    await dotenv.load(fileName: 'environments/.env.dev');
  });
  
  testWidgets('Home screen displays EcoPlates title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: EcoPlatesApp(),
      ),
    );
    
    // Attendre que l'écran se charge
    await tester.pumpAndSettle();

    // Vérifier que le titre EcoPlates est affiché
    expect(find.text('EcoPlates'), findsOneWidget);
    
    // Vérifier la présence du score écologique
    expect(find.text('Votre Score Écologique'), findsOneWidget);
  });
  
  testWidgets('Bottom navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EcoPlatesApp(),
      ),
    );
    
    await tester.pumpAndSettle();
    
    // Vérifier que nous sommes sur l'écran d'accueil
    expect(find.text('Actions rapides'), findsOneWidget);
    
    // Naviguer vers l'écran Scanner
    await tester.tap(find.byIcon(Icons.qr_code_scanner));
    await tester.pumpAndSettle();
    
    // Vérifier que nous sommes sur l'écran Scanner
    expect(find.text('Scanner une assiette'), findsOneWidget);
  });
}
