import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:example/routes.dart';

/// Pumps every demo route through the real app and fails on any build or
/// layout exception — the widget-test harnesses in the package suite use
/// bounded constraints, which can mask layout bugs that only trigger inside
/// the demo pages' scrollables.
void main() {
  Future<void> openRoute(WidgetTester tester, String route) async {
    // Large surface so pages are exercised at a realistic desktop size.
    tester.view.physicalSize = const Size(1280, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const CarbonExampleApp());
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .pushNamed(route);
    // Fixed pumps instead of pumpAndSettle: some pages animate forever
    // (loading spinners, skeletons).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull, reason: route);
  }

  group('every demo route builds and lays out', () {
    for (final category in componentCategories) {
      for (final item in category.items) {
        testWidgets('${category.title} → ${item.title} (${item.route})', (
          tester,
        ) async {
          await openRoute(tester, item.route);
        });
      }
    }
  });

  group('wave-4 demo interactions', () {
    testWidgets('expandable search expands without breaking layout', (
      tester,
    ) async {
      await openRoute(tester, AppRoutes.search);

      // The expandable variant is the only collapsed search on the page.
      final expandable = find.byWidgetPredicate(
        (widget) => widget is CarbonSearch && widget.expandable,
      );
      // Explicit scrollable: the page ListView (every EditableText contains
      // its own Scrollable, so the default lookup is ambiguous).
      await tester.scrollUntilVisible(
        expandable,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();

      await tester.tap(
        find.descendant(
          of: expandable,
          matching: find.byIcon(CarbonIcons.search),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(expandable).height,
        CarbonSearchSize.md.height,
      );
    });

    testWidgets('select opens its menu and picks an option', (tester) async {
      await openRoute(tester, AppRoutes.select);

      // One 'Banana' is always visible (the warning demo's fixed value).
      final before = tester.widgetList(find.text('Banana')).length;

      await tester.tap(find.text('Choose an option').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(
        tester.widgetList(find.text('Banana')).length,
        greaterThan(before), // the open menu adds its option row
      );

      await tester.tap(find.text('Banana').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
      // Menu closed; the basic select's field now shows the choice.
      expect(tester.widgetList(find.text('Banana')).length, before + 1);
    });

    testWidgets('slider drags and updates its value', (tester) async {
      await openRoute(tester, AppRoutes.slider);

      final body = find
          .descendant(
            of: find.byType(CarbonSlider).first,
            matching: find.byType(GestureDetector),
          )
          .first;
      final rect = tester.getRect(body);
      await tester.tapAt(Offset(rect.left + rect.width * 0.9, rect.center.dy));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
      expect(find.text('90'), findsWidgets);
    });

    testWidgets('accordion section opens on tap', (tester) async {
      await openRoute(tester, AppRoutes.accordion);

      await tester.tap(find.text('Section 2').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
    });
  });
}
