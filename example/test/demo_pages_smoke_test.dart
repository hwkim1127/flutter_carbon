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

  group('wave-5 demo interactions', () {
    testWidgets('date picker opens its calendar and picks a day', (
      tester,
    ) async {
      await openRoute(tester, AppRoutes.dateTimePicker);

      // The "Single with calendar" section's input field.
      final picker = find.ancestor(
        of: find.text('Appointment date'),
        matching: find.byType(CarbonDatePicker),
      );
      await tester.scrollUntilVisible(
        picker,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();
      await tester.tap(
        find.descendant(of: picker, matching: find.byType(EditableText)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // The weekday header proves the calendar is open.
      expect(find.text('Su'), findsOneWidget);

      await tester.tap(find.text('15').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull);
      expect(find.text('Su'), findsNothing); // closed on select
    });

    testWidgets('every overlay trigger opens without Material-ancestor '
        'errors', (tester) async {
      // Overlay/route content (side panels, tearsheets, modals, popovers)
      // does NOT inherit the page's Material ancestor — Material widgets
      // placed inside them throw. Route-level smoke can't catch that;
      // every trigger must actually be pressed.
      for (final route in [
        AppRoutes.sidePanel,
        AppRoutes.tearsheet,
        AppRoutes.modal,
        AppRoutes.popover,
      ]) {
        await openRoute(tester, route);
        final triggerCount = tester
            .widgetList(find.byWidgetPredicate((w) => w is ButtonStyleButton))
            .length;

        for (var i = 0; i < triggerCount; i++) {
          await openRoute(tester, route); // fresh app per trigger
          final triggers = find.byWidgetPredicate(
            (w) => w is ButtonStyleButton,
          );
          await tester.scrollUntilVisible(
            triggers.at(i),
            300,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.pump();
          await tester.tap(triggers.at(i), warnIfMissed: false);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 600));
          expect(
            tester.takeException(),
            isNull,
            reason: '$route trigger #$i',
          );
        }
      }
    });

    testWidgets('time picker accepts masked input', (tester) async {
      await openRoute(tester, AppRoutes.dateTimePicker);

      await tester.scrollUntilVisible(
        find.text('Select a time'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();

      final input = find
          .descendant(
            of: find.byType(CarbonTimePicker),
            matching: find.byType(EditableText),
          )
          .first;
      await tester.enterText(input, '4:5x9');
      await tester.pump();
      expect(tester.widget<EditableText>(input).controller.text, '4:59');
      expect(tester.takeException(), isNull);
    });
  });

  group('wave-6 demo interactions', () {
    testWidgets('code snippet copies with feedback and expands', (
      tester,
    ) async {
      await openRoute(tester, AppRoutes.codeSnippet);

      // Copy from the first single-line snippet: feedback bubble appears.
      final copyButton = find.byType(CarbonCopyButton).first;
      await tester.tap(copyButton, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Copied!'), findsWidgets);
      // Let the feedback time out so no timers leak into the next step.
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 200));

      // Expand the long example: viewport grows.
      final showMore = find.text('Show more').first;
      await tester.scrollUntilVisible(
        showMore,
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();
      await tester.tap(showMore, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Show less'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('language gallery renders colored spans per fixture', (
      tester,
    ) async {
      await openRoute(tester, AppRoutes.syntaxHighlighting);

      // Every VISIBLE multi snippet paints at least one colored span (the
      // page is a lazy scrollable, so only the on-screen fixtures build;
      // per-language classification is covered by the package unit tests).
      final editables = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      expect(editables.length, greaterThanOrEqualTo(5));
      for (final editable in editables) {
        final span = editable.controller.buildTextSpan(
          context: tester.element(find.byType(EditableText).first),
          style: editable.style,
          withComposing: false,
        );
        final colored = <TextSpan>[];
        span.visitChildren((child) {
          if (child is TextSpan && child.style?.color != null) {
            colored.add(child);
          }
          return true;
        });
        expect(
          colored,
          isNotEmpty,
          reason: 'a gallery fixture rendered without any highlight spans',
        );
      }
      expect(tester.takeException(), isNull);
    });
  });
}
