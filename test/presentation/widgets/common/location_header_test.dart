import 'package:ecoplates/presentation/widgets/common/location_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocationHeader', () {
    testWidgets('se construit sans erreur', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: LocationHeader())),
        ),
      );

      // Assert
      expect(find.byType(LocationHeader), findsOneWidget);
    });
  });
}
