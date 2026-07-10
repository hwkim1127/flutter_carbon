import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonAccordion basics', () {
    testWidgets('renders titles; closed content is absent', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAccordion(
            items: [
              CarbonAccordionItem(title: 'Section 1', child: Text('Body 1')),
              CarbonAccordionItem(title: 'Section 2', child: Text('Body 2')),
            ],
          ),
        ),
      );

      expect(find.text('Section 1'), findsOneWidget);
      expect(find.text('Section 2'), findsOneWidget);
      expect(find.text('Body 1'), findsNothing);
      expect(find.text('Body 2'), findsNothing);
    });

    testWidgets('tap opens with the 110ms animation, tap again closes', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAccordion(
            items: [
              CarbonAccordionItem(
                title: 'Section',
                child: SizedBox(height: 100, child: Text('Body')),
              ),
            ],
          ),
        ),
      );

      Finder panelClip() => find
          .descendant(
            of: find.byType(CarbonAccordion),
            matching: find.byType(ClipRect),
          )
          .first;

      await tester.tap(find.text('Section'));
      await tester.pump();
      // Mid-animation: the panel exists but is not at full height yet.
      await tester.pump(const Duration(milliseconds: 55));
      final midHeight = tester.getSize(panelClip()).height;
      expect(midHeight, greaterThan(0));

      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);
      expect(midHeight, lessThan(tester.getSize(panelClip()).height));

      await tester.tap(find.text('Section'));
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('initiallyOpen renders instantly with no pending timers', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAccordion(
            items: [
              CarbonAccordionItem(
                title: 'Section',
                initiallyOpen: true,
                child: Text('Body'),
              ),
            ],
          ),
        ),
      );

      // Visible on the very first frame — no animation ran.
      expect(find.text('Body'), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('divider count is items + 1', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAccordion(
            items: [
              CarbonAccordionItem(title: 'A', child: Text('a')),
              CarbonAccordionItem(title: 'B', child: Text('b')),
              CarbonAccordionItem(title: 'C', child: Text('c')),
            ],
          ),
        ),
      );

      // The rules are 1px-high ColoredBoxes inside the accordion.
      final dividers = find.descendant(
        of: find.byType(CarbonAccordion),
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 1,
        ),
      );
      expect(dividers, findsNWidgets(4));
    });

    testWidgets('heading honors the size min-height and centers the title', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAccordion(
            size: CarbonAccordionSize.lg,
            items: [
              CarbonAccordionItem(title: 'Section', child: Text('Body')),
            ],
          ),
        ),
      );

      final heading = tester.getRect(
        find
            .ancestor(
              of: find.text('Section'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(heading.height, 48);
      expect(
        tester.getCenter(find.text('Section')).dy,
        moreOrLessEquals(heading.center.dy, epsilon: 1),
      );
    });

    testWidgets('align start puts the chevron before the title', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAccordion(
            align: CarbonAccordionAlign.start,
            items: [
              CarbonAccordionItem(title: 'Section', child: Text('Body')),
            ],
          ),
        ),
      );

      final chevronX = tester
          .getTopLeft(find.byIcon(CarbonIcons.chevronDown))
          .dx;
      final titleX = tester.getTopLeft(find.text('Section')).dx;
      expect(chevronX, lessThan(titleX));
    });

    testWidgets('renders under a pure CarbonApp', (tester) async {
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: const Center(
            child: CarbonAccordion(
              items: [
                CarbonAccordionItem(title: 'Section', child: Text('Body')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Section'), findsOneWidget);
    });
  });

  group('CarbonAccordion states', () {
    testWidgets('disabled item is inert', (tester) async {
      final clicks = <bool>[];
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonAccordion(
            items: [
              CarbonAccordionItem(
                title: 'Section',
                disabled: true,
                onHeadingClick: clicks.add,
                child: const Text('Body'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Section'));
      await tester.pumpAndSettle();
      expect(clicks, isEmpty);
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('accordion-level disabled disables every item', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAccordion(
            disabled: true,
            items: [
              CarbonAccordionItem(title: 'Section', child: Text('Body')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Section'));
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('Enter and Space toggle the focused heading', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAccordion(
            items: [
              CarbonAccordionItem(title: 'Section', child: Text('Body')),
            ],
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('controlled item follows the parent, not the tap', (
      tester,
    ) async {
      final clicks = <bool>[];
      var open = false;
      late StateSetter setOuterState;
      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              setOuterState = setState;
              return CarbonAccordion(
                items: [
                  CarbonAccordionItem(
                    title: 'Section',
                    open: open,
                    onHeadingClick: clicks.add,
                    child: const Text('Body'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Tap reports the target state but does NOT open by itself.
      await tester.tap(find.text('Section'));
      await tester.pumpAndSettle();
      expect(clicks, [true]);
      expect(find.text('Body'), findsNothing);

      // The parent applying the state opens the panel.
      setOuterState(() => open = true);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);

      setOuterState(() => open = false);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
    });
  });
}
