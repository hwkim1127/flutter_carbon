import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  Widget tabs({
    int count = 10,
    double width = 300,
    CarbonTabsType type = CarbonTabsType.line,
    ValueChanged<int>? onTabChanged,
  }) {
    return buildTestApp(
      child: Center(
        child: SizedBox(
          width: width,
          child: CarbonTabs(
            type: type,
            onTabChanged: onTabChanged,
            tabs: [
              for (var i = 0; i < count; i++) CarbonTab(label: 'Tab $i'),
            ],
          ),
        ),
      ),
    );
  }

  /// The overflow nav buttons are the only chevron icons in the bar.
  Finder navButtons() => find.byWidgetPredicate(
        (w) =>
            w is Icon &&
            (w.icon == CarbonIcons.chevronLeft ||
                w.icon == CarbonIcons.chevronRight),
      );

  group('CarbonTabs', () {
    testWidgets('renders tabs and selects on tap', (tester) async {
      var selected = -1;
      await tester.pumpWidget(
        tabs(count: 3, width: 600, onTabChanged: (i) => selected = i),
      );

      expect(find.text('Tab 0'), findsOneWidget);
      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();
      expect(selected, 2);
    });
  });

  group('CarbonTabs overflow nav buttons', () {
    testWidgets('no buttons when the tabs fit', (tester) async {
      await tester.pumpWidget(tabs(count: 3, width: 600));
      await tester.pumpAndSettle();

      expect(navButtons(), findsNothing);
    });

    testWidgets('only next at the start; both mid-scroll; only previous at '
        'the end', (tester) async {
      await tester.pumpWidget(tabs());
      await tester.pumpAndSettle();

      // At offset 0: next only.
      expect(navButtons(), findsOneWidget);
      expect(find.byIcon(CarbonIcons.chevronRight), findsOneWidget);
      expect(find.byIcon(CarbonIcons.chevronLeft), findsNothing);

      // Step once: both.
      await tester.tap(find.byIcon(CarbonIcons.chevronRight));
      await tester.pumpAndSettle();
      expect(find.byIcon(CarbonIcons.chevronRight), findsOneWidget);
      expect(find.byIcon(CarbonIcons.chevronLeft), findsOneWidget);

      // Step to the far end: previous only.
      for (var i = 0; i < 20; i++) {
        final next = find.byIcon(CarbonIcons.chevronRight);
        if (next.evaluate().isEmpty) break;
        await tester.tap(next);
        await tester.pumpAndSettle();
      }
      expect(find.byIcon(CarbonIcons.chevronRight), findsNothing);
      expect(find.byIcon(CarbonIcons.chevronLeft), findsOneWidget);
    });

    testWidgets('click steps the scroll by ~1.5 average tab widths', (
      tester,
    ) async {
      await tester.pumpWidget(tabs());
      await tester.pumpAndSettle();

      final scrollable = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      final controller = scrollable.controller!;
      expect(controller.offset, 0);

      await tester.tap(find.byIcon(CarbonIcons.chevronRight));
      await tester.pumpAndSettle();

      final position = controller.position;
      final contentWidth =
          position.maxScrollExtent + position.viewportDimension;
      expect(
        controller.offset,
        moreOrLessEquals(contentWidth / 10 * 1.5, epsilon: 1),
      );
    });

    testWidgets('buttons are semantics-excluded and not focusable', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(tabs());
      await tester.pumpAndSettle();

      // The chevron never appears in the semantics tree (aria-hidden).
      expect(
        find.ancestor(
          of: find.byIcon(CarbonIcons.chevronRight),
          matching: find.byType(ExcludeSemantics),
        ),
        findsWidgets,
      );
      // And there is no focusable node inside the button.
      expect(
        find.descendant(
          of: find.ancestor(
            of: find.byIcon(CarbonIcons.chevronRight),
            matching: find.byType(GestureDetector),
          ),
          matching: find.byType(Focus),
        ),
        findsNothing,
      );
      semantics.dispose();
    });

    testWidgets('overflowing bar lays out under unbounded height', (
      tester,
    ) async {
      // Regression: the flanked Row's `stretch` must resolve against the
      // tab bar's intrinsic height, not an unbounded incoming constraint
      // (tabs inside scrollable demo pages).
      await tester.pumpWidget(
        buildTestApp(
          child: ListView(
            children: [
              SizedBox(
                width: 300,
                child: CarbonTabs(
                  tabs: [
                    for (var i = 0; i < 10; i++) CarbonTab(label: 'Tab $i'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byIcon(CarbonIcons.chevronRight), findsOneWidget);
    });

    testWidgets('contained variant uses layer-accent buttons', (
      tester,
    ) async {
      await tester.pumpWidget(tabs(type: CarbonTabsType.contained));
      await tester.pumpAndSettle();

      final button = tester.widget<Container>(
        find.ancestor(
          of: find.byIcon(CarbonIcons.chevronRight),
          matching: find.byType(Container),
        ).first,
      );
      expect(button.color, WhiteTheme.theme.layer.layerAccent01);
      expect(button.constraints?.maxWidth ?? 48, 48);
    });
  });
}
