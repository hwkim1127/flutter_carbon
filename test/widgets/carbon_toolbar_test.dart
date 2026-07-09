import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

void main() {
  group('CarbonToolbarSearch', () {
    testWidgets('persistent search accepts text and fires onChanged', (
      tester,
    ) async {
      String? changed;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToolbarSearch(
            persistent: true,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      expect(find.text('Search'), findsOneWidget); // placeholder
      await tester.enterText(find.byType(CarbonToolbarSearch), 'query');
      expect(changed, 'query');
    });

    testWidgets('clear button appears while typing and clears the field', (
      tester,
    ) async {
      String? changed;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToolbarSearch(
            persistent: true,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      // No clear button while empty.
      expect(find.byIcon(CarbonIcons.close), findsNothing);

      await tester.enterText(find.byType(CarbonToolbarSearch), 'abc');
      await tester.pump();
      // Regression: the button must appear from typing alone (the old
      // TextField version only updated on incidental rebuilds).
      expect(find.byIcon(CarbonIcons.close), findsOneWidget);

      await tester.tap(find.byIcon(CarbonIcons.close));
      await tester.pump();
      expect(changed, '');
      expect(find.byIcon(CarbonIcons.close), findsNothing);
    });

    testWidgets('collapsed search expands on tap and focuses the field', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(child: const CarbonToolbarSearch()));

      // Collapsed: only the search icon, no editable.
      expect(find.byType(EditableText), findsNothing);

      await tester.tap(find.byIcon(CarbonIcons.search));
      await tester.pumpAndSettle();

      expect(find.byType(EditableText), findsOneWidget);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isTrue);
    });
  });
}
