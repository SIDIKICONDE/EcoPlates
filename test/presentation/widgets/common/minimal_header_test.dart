import 'package:ecoplates/presentation/widgets/minimal_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MinimalHeader', () {
    testWidgets('se construit sans erreur', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: MinimalHeader(title: 'Test'),
            body: SizedBox(),
          ),
        ),
      );

      // Assert
      expect(find.byType(MinimalHeader), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });
}
