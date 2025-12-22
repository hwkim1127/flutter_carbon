import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('CarbonIcons', () {
    test('icon data is defined', () {
      // Test a few key icons to ensure they're defined
      expect(CarbonIcons.add, isA<IconData>());
      expect(CarbonIcons.close, isA<IconData>());
      expect(CarbonIcons.search, isA<IconData>());
    });

    test('icon data uses correct font family', () {
      expect(CarbonIcons.add.fontFamily, 'CarbonIcons');
      expect(CarbonIcons.close.fontFamily, 'CarbonIcons');
      expect(CarbonIcons.search.fontFamily, 'CarbonIcons');
    });

    test('different icons have different codepoints', () {
      expect(
        CarbonIcons.add.codePoint,
        isNot(equals(CarbonIcons.close.codePoint)),
      );
      expect(
        CarbonIcons.close.codePoint,
        isNot(equals(CarbonIcons.search.codePoint)),
      );
      expect(
        CarbonIcons.search.codePoint,
        isNot(equals(CarbonIcons.add.codePoint)),
      );
    });

    testWidgets('can be rendered in Icon widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Icon(CarbonIcons.add))),
      );

      expect(find.byIcon(CarbonIcons.add), findsOneWidget);
    });

    testWidgets('can be rendered with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Icon(CarbonIcons.add, size: 32)),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(CarbonIcons.add));
      expect(icon.size, 32);
    });

    testWidgets('can be rendered with custom color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Icon(CarbonIcons.add, color: Colors.blue)),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(CarbonIcons.add));
      expect(icon.color, Colors.blue);
    });

    testWidgets('multiple icons can be rendered together', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Icon(CarbonIcons.add),
                Icon(CarbonIcons.close),
                Icon(CarbonIcons.search),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(CarbonIcons.add), findsOneWidget);
      expect(find.byIcon(CarbonIcons.close), findsOneWidget);
      expect(find.byIcon(CarbonIcons.search), findsOneWidget);
    });
  });
}
