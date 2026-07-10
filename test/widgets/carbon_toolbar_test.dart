import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

void main() {
  group('CarbonToolbarSearch', () {
    Finder clearOpacity() => find.ancestor(
      of: find.byIcon(CarbonIcons.close),
      matching: find.byType(Opacity),
    );

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

      // Hidden (layout retained) while empty.
      expect(tester.widget<Opacity>(clearOpacity()).opacity, 0);

      await tester.enterText(find.byType(CarbonToolbarSearch), 'abc');
      await tester.pump();
      // Regression: the button must appear from typing alone (the old
      // TextField version only updated on incidental rebuilds).
      expect(tester.widget<Opacity>(clearOpacity()).opacity, 1);

      await tester.tap(find.byIcon(CarbonIcons.close));
      await tester.pump();
      expect(changed, '');
      expect(tester.widget<Opacity>(clearOpacity()).opacity, 0);
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

    testWidgets('persistent search renders the field immediately at 48px', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonToolbarSearch(persistent: true)),
      );

      expect(find.byType(EditableText), findsOneWidget);
      expect(tester.getSize(find.byType(CarbonSearch)).height, 48);
      expect(tester.getSize(find.byType(CarbonSearch)).width, 300);
    });

    testWidgets('focused search draws the 2px focus outline', (tester) async {
      final carbon = WhiteTheme.theme;
      await tester.pumpWidget(
        buildTestApp(child: const CarbonToolbarSearch(persistent: true)),
      );

      await tester.tap(find.byType(EditableText));
      await tester.pump();

      final container = tester.widget<AnimatedContainer>(
        find
            .descendant(
              of: find.byType(CarbonSearch),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      final border =
          (container.foregroundDecoration! as BoxDecoration).border! as Border;
      expect(border.top.color, carbon.layer.focus);
      expect(border.top.width, 2);
    });
  });
}
