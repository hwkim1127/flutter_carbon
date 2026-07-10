import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  Finder clearOpacity() => find.ancestor(
    of: find.byIcon(CarbonIcons.close),
    matching: find.byType(Opacity),
  );

  group('CarbonSearch basics', () {
    testWidgets('typing fires onChanged', (tester) async {
      String? changed;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonSearch(onChanged: (value) => changed = value),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'carbon');
      expect(changed, 'carbon');
    });

    testWidgets('submit fires onSubmitted', (tester) async {
      String? submitted;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonSearch(onSubmitted: (value) => submitted = value),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'query');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      expect(submitted, 'query');
    });

    testWidgets('sizes set the field height', (tester) async {
      for (final size in CarbonSearchSize.values) {
        await tester.pumpWidget(
          buildTestApp(child: CarbonSearch(size: size)),
        );
        // The chrome animates height changes between pumps.
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byType(CarbonSearch)).height,
          size.height,
        );
      }
    });

    testWidgets('focus draws the 2px focus outline', (tester) async {
      final carbon = WhiteTheme.theme;
      await tester.pumpWidget(buildTestApp(child: const CarbonSearch()));

      BoxDecoration foreground() {
        final container = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: find.byType(CarbonSearch),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        return container.foregroundDecoration! as BoxDecoration;
      }

      expect(
        (foreground().border! as Border).top.color,
        CarbonPalette.transparent,
      );

      await tester.tap(find.byType(EditableText));
      await tester.pump();

      final border = foreground().border! as Border;
      expect(border.top.color, carbon.layer.focus);
      expect(border.top.width, 2);
    });

    testWidgets('disabled field takes no focus and no text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSearch(disabled: true)),
      );

      await tester.tap(find.byType(CarbonSearch), warnIfMissed: false);
      await tester.pump();
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isFalse);
    });

    testWidgets('renders under a pure CarbonApp', (tester) async {
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: const Center(child: CarbonSearch()),
        ),
      );
      expect(find.byType(CarbonSearch), findsOneWidget);
    });
  });

  group('CarbonSearch clear button', () {
    testWidgets('hidden while empty, visible with text', (tester) async {
      await tester.pumpWidget(buildTestApp(child: const CarbonSearch()));

      expect(tester.widget<Opacity>(clearOpacity()).opacity, 0);

      await tester.enterText(find.byType(EditableText), 'x');
      await tester.pump();
      expect(tester.widget<Opacity>(clearOpacity()).opacity, 1);
    });

    testWidgets('tap clears, fires onClear + onChanged, refocuses', (
      tester,
    ) async {
      final log = <String>[];
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonSearch(
            onChanged: (value) => log.add('changed:$value'),
            onClear: () => log.add('clear'),
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'abc');
      await tester.pump();
      log.clear();

      await tester.tap(find.byIcon(CarbonIcons.close));
      await tester.pump();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, isEmpty);
      expect(log, ['clear', 'changed:']);
      expect(editable.focusNode.hasFocus, isTrue);
    });
  });

  group('CarbonSearch Escape', () {
    testWidgets('clears text without dismissing an enclosing route', (
      tester,
    ) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          navigatorKey: navigatorKey,
          home: const Center(child: Text('home')),
        ),
      );
      navigatorKey.currentState!.push(
        CarbonPageRoute<void>(
          builder: (_) => const Center(child: CarbonSearch()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'abc');
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, isEmpty);
      // The route with the search field is still on top.
      expect(find.byType(CarbonSearch), findsOneWidget);
      expect(find.text('home'), findsNothing);
    });

    testWidgets('while empty collapses the expandable variant', (
      tester,
    ) async {
      final expansions = <bool>[];
      await tester.pumpWidget(
        buildTestApp(
          child: SizedBox(
            width: 300,
            child: CarbonSearch(
              expandable: true,
              onExpandedChanged: expansions.add,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(CarbonIcons.search));
      await tester.pumpAndSettle();
      expect(find.byType(EditableText), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(EditableText), findsNothing);
      expect(expansions, [true, false]);
    });
  });

  group('CarbonSearch expandable', () {
    testWidgets('starts as a square button and expands on tap with focus', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          // Loose bounded constraints: collapsed the search is an intrinsic
          // square; expanded it fills the available width.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: const CarbonSearch(expandable: true),
          ),
        ),
      );

      expect(find.byType(EditableText), findsNothing);
      expect(
        tester.getSize(find.byType(CarbonSearch)).width,
        CarbonSearchSize.md.height,
      );

      await tester.tap(find.byIcon(CarbonIcons.search));
      await tester.pumpAndSettle();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isTrue);
      expect(tester.getSize(find.byType(CarbonSearch)).width, 300);
    });

    testWidgets('expands when the collapsed button gains keyboard focus', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SizedBox(
            width: 300,
            child: CarbonSearch(expandable: true),
          ),
        ),
      );

      // Traverse onto the collapsed button.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(find.byType(EditableText), findsOneWidget);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isTrue);
    });

    testWidgets('collapses on blur while empty, stays with text', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SizedBox(
            width: 300,
            child: CarbonSearch(expandable: true),
          ),
        ),
      );

      await tester.tap(find.byIcon(CarbonIcons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'keep');
      tester
          .widget<EditableText>(find.byType(EditableText))
          .focusNode
          .unfocus();
      await tester.pumpAndSettle();
      expect(find.byType(EditableText), findsOneWidget);

      await tester.enterText(find.byType(EditableText), '');
      tester
          .widget<EditableText>(find.byType(EditableText))
          .focusNode
          .unfocus();
      await tester.pumpAndSettle();
      expect(find.byType(EditableText), findsNothing);
    });

    testWidgets('expanded field lays out inside a scrollable '
        '(unbounded height)', (tester) async {
      // Regression: the expanded state uses an OverflowBox, which sizes to
      // the BIGGEST incoming constraints — without a fixed height it
      // demanded infinite height inside scrollables and broke layout.
      await tester.pumpWidget(
        buildTestApp(
          child: ListView(
            children: const [
              SizedBox(
                width: 300,
                child: CarbonSearch(expandable: true),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byIcon(CarbonIcons.search));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(EditableText), findsOneWidget);
      expect(
        tester.getSize(find.byType(CarbonSearch)).height,
        CarbonSearchSize.md.height,
      );
    });

    testWidgets('initiallyExpanded renders the field from the start', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const SizedBox(
            width: 300,
            child: CarbonSearch(expandable: true, initiallyExpanded: true),
          ),
        ),
      );
      expect(find.byType(EditableText), findsOneWidget);
    });
  });
}
