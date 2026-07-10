import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  final List<MethodCall> platformLog = [];

  setUp(() {
    platformLog.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      platformLog.add(call);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  List<String> copiedTexts() => platformLog
      .where((call) => call.method == 'Clipboard.setData')
      .map((call) => (call.arguments as Map)['text'] as String)
      .toList();

  /// The multi variant's animated viewport (the height-clipped code area).
  Finder viewport() => find.byWidgetPredicate(
        (w) => w is AnimatedContainer && w.child is ClipRect,
      );

  /// The gradient overflow fades.
  Finder fades() => find.byWidgetPredicate(
        (w) =>
            w is DecoratedBox &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).gradient is LinearGradient,
      );

  group('CarbonCodeSnippet', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(code: 'print("Hello World")'),
        ),
      );
      expect(find.byType(CarbonCodeSnippet), findsOneWidget);
    });

    testWidgets('displays code', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(code: 'const greeting = "Hello";'),
        ),
      );
      expect(find.textContaining('greeting'), findsOneWidget);
    });

    // ------------------------------------------------------------ geometry

    testWidgets('single variant is 40px tall with a 40×40 copy button', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'npm install',
            type: CarbonCodeSnippetType.single,
          ),
        ),
      );

      expect(tester.getSize(find.byType(CarbonCodeSnippet)).height, 40);
      expect(
        tester.getSize(find.byType(CarbonCopyButton)),
        const Size(40, 40),
      );
    });

    testWidgets('inline variant is a 20px chip with the 4px Carbon radius', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const Center(
            child: CarbonCodeSnippet(
              code: 'var x',
              type: CarbonCodeSnippetType.inline,
            ),
          ),
        ),
      );

      final chip = tester.widget<Container>(
        find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).borderRadius ==
                  BorderRadius.circular(4),
        ),
      );
      expect(chip, isNotNull);
      expect(tester.getSize(find.byType(CarbonCodeSnippet)).height, 20);
    });

    testWidgets('multi copy button is 32×32 at inset top-end 8,8', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'line 1\nline 2',
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(CarbonCopyButton)),
        const Size(32, 32),
      );
      final snippetRect = tester.getRect(find.byType(CarbonCodeSnippet));
      final buttonRect = tester.getRect(find.byType(CarbonCopyButton));
      expect(buttonRect.top - snippetRect.top, 8);
      expect(snippetRect.right - buttonRect.right, 8);
    });

    testWidgets('multi copy button mirrors to top-left in RTL', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const Directionality(
            textDirection: TextDirection.rtl,
            child: CarbonCodeSnippet(
              code: 'line 1\nline 2',
              type: CarbonCodeSnippetType.multi,
            ),
          ),
        ),
      );

      final snippetRect = tester.getRect(find.byType(CarbonCodeSnippet));
      final buttonRect = tester.getRect(find.byType(CarbonCopyButton));
      expect(buttonRect.left - snippetRect.left, 8);
    });

    // ------------------------------------------------------------ row math

    testWidgets('collapsed viewport is maxCollapsedNumberOfRows × 16', (
      tester,
    ) async {
      final code = List.generate(20, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );

      expect(tester.getSize(viewport()).height, 15 * 16.0); // default 15 rows
    });

    testWidgets('short content clamps to minCollapsedNumberOfRows', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'one line',
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );

      expect(tester.getSize(viewport()).height, 3 * 16.0); // default min 3
      expect(find.text('Show more'), findsNothing);
    });

    testWidgets('expanding grows the viewport; content stays full text', (
      tester,
    ) async {
      final code = List.generate(20, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );

      // Collapse clips the viewport, never the text.
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.readOnly, isTrue);
      expect(editable.controller.text, code);

      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();

      expect(tester.getSize(viewport()).height, 20 * 16.0); // > minExpanded 16
      expect(find.text('Show less'), findsOneWidget);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        code,
      );
    });

    testWidgets('maxExpandedNumberOfRows caps the expanded viewport', (
      tester,
    ) async {
      final code = List.generate(30, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            maxExpandedNumberOfRows: 18,
          ),
        ),
      );

      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();
      expect(tester.getSize(viewport()).height, 18 * 16.0);
    });

    testWidgets('no Show more when maxExpanded <= maxCollapsed', (
      tester,
    ) async {
      final code = List.generate(30, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            maxExpandedNumberOfRows: 10,
          ),
        ),
      );

      expect(find.text('Show more'), findsNothing);
    });

    testWidgets('auto-collapses when content shrinks below minExpanded', (
      tester,
    ) async {
      Widget build(String code) => buildTestApp(
            child: CarbonCodeSnippet(
              code: code,
              type: CarbonCodeSnippetType.multi,
            ),
          );

      await tester.pumpWidget(
        build(List.generate(20, (i) => 'line ${i + 1}').join('\n')),
      );
      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        build(List.generate(5, (i) => 'line ${i + 1}').join('\n')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Show less'), findsNothing);
      expect(tester.getSize(viewport()).height, 5 * 16.0);
    });

    testWidgets('multi fills the available width (capped at 768)', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const Center(
            child: CarbonCodeSnippet(
              code: 'x = 1', // much narrower than the container
              type: CarbonCodeSnippetType.multi,
            ),
          ),
        ),
      );

      // Spec inline-size 100% — the snippet must not shrink-wrap the code.
      expect(
        tester.getSize(find.byType(CarbonCodeSnippet)).width,
        768, // test surface is 800 wide; the spec cap wins
      );
    });

    testWidgets('multi never soft-wraps by default (16px code-01 rows)', (
      tester,
    ) async {
      const code =
          "import 'package:flutter_carbon/material.dart';\n\nvoid main() {\n  runApp(MyApp());\n}";
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );

      // 5 logical lines × 16px. Any soft wrap adds a row.
      expect(
        tester.getSize(find.byType(EditableText)).height,
        closeTo(5 * 16.0, 1),
      );
    });

    testWidgets('wrapText soft-wraps instead of scrolling horizontally', (
      tester,
    ) async {
      final code = List.filled(40, 'word').join(' '); // one very long line
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            wrapText: true,
          ),
        ),
      );

      // No horizontal scroll view inside the snippet.
      final horizontal = find.descendant(
        of: find.byType(CarbonCodeSnippet),
        matching: find.byWidgetPredicate(
          (w) =>
              w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
        ),
      );
      expect(horizontal, findsNothing);
      // The single logical line wraps to multiple 16px rows.
      expect(
        tester.getSize(find.byType(EditableText)).height,
        greaterThan(16.0),
      );
    });

    // --------------------------------------------------------------- fades

    testWidgets('fades show unfocused and disappear on focus-within', (
      tester,
    ) async {
      final code = List.generate(20, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );

      // Right + bottom fades while collapsed and unfocused.
      expect(fades(), findsNWidgets(2));

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(fades(), findsNothing);
    });

    // ---------------------------------------------------------------- copy

    testWidgets('copy button writes the code and shows timed feedback', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      var copied = false;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: 'npm install',
            type: CarbonCodeSnippetType.single,
            feedbackTimeout: const Duration(milliseconds: 200),
            onCopy: () => copied = true,
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCopyButton));
      await tester.pump(); // post-frame overlay insert
      await tester.pump(const Duration(milliseconds: 120)); // fade in

      expect(copiedTexts(), ['npm install']);
      expect(copied, isTrue);
      expect(find.text('Copied!'), findsOneWidget);

      // Announced to assistive tech.
      final feedbackSemantics = tester.getSemantics(find.text('Copied!'));
      expect(feedbackSemantics.flagsCollection.isLiveRegion, isTrue);

      // Gone after the timeout + fade out.
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(find.text('Copied!'), findsNothing);
      semantics.dispose();
    });

    testWidgets('copyText overrides what is copied', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: r'$ npm install',
            copyText: 'npm install',
            type: CarbonCodeSnippetType.single,
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCopyButton));
      await tester.pump();
      expect(copiedTexts(), ['npm install']);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('inline chip itself copies on tap', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const Center(
            child: CarbonCodeSnippet(
              code: 'var x = 1;',
              type: CarbonCodeSnippetType.inline,
              feedbackTimeout: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCodeSnippet));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));

      expect(copiedTexts(), ['var x = 1;']);
      expect(find.text('Copied!'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Copied!'), findsNothing);
    });

    testWidgets('hideCopyButton removes the button / chip interactivity', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'secret',
            type: CarbonCodeSnippetType.single,
            hideCopyButton: true,
          ),
        ),
      );
      expect(find.byType(CarbonCopyButton), findsNothing);

      await tester.pumpWidget(
        buildTestApp(
          child: const Center(
            child: CarbonCodeSnippet(
              code: 'secret',
              type: CarbonCodeSnippetType.inline,
              hideCopyButton: true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(CarbonCodeSnippet), warnIfMissed: false);
      await tester.pump();
      expect(copiedTexts(), isEmpty);
    });

    testWidgets('disabled snippet is inert', (tester) async {
      final code = List.generate(20, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            disabled: true,
          ),
        ),
      );

      final collapsedHeight = tester.getSize(viewport()).height;
      await tester.tap(find.byType(CarbonCopyButton), warnIfMissed: false);
      await tester.tap(find.text('Show more'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(copiedTexts(), isEmpty);
      expect(tester.getSize(viewport()).height, collapsedHeight);
    });

    // -------------------------------------------------------- line numbers

    testWidgets('showLineNumbers renders a pointer-transparent gutter', (
      tester,
    ) async {
      final code = List.generate(4, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            showLineNumbers: true,
          ),
        ),
      );

      for (var n = 1; n <= 4; n++) {
        expect(find.text('$n'), findsOneWidget);
      }
      // Numbers are outside the editable — the controller has code only.
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        code,
      );
      // The gutter never intercepts pointers.
      expect(
        find.ancestor(
          of: find.text('1'),
          matching: find.byType(IgnorePointer),
        ),
        findsWidgets,
      );
    });

    testWidgets('gutter rows align to the 16px grid', (tester) async {
      final code = List.generate(6, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            showLineNumbers: true,
          ),
        ),
      );

      final first = tester.getTopLeft(find.text('1'));
      final fourth = tester.getTopLeft(find.text('4'));
      expect(fourth.dy - first.dy, 3 * 16.0);
      // Number rows start level with the editable's first line.
      expect(first.dy, tester.getTopLeft(find.byType(EditableText)).dy);
    });

    testWidgets('wrap mode numbers one logical line across visual rows', (
      tester,
    ) async {
      final longLine = List.filled(60, 'word').join(' ');
      final code = '$longLine\nshort';
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            wrapText: true,
            showLineNumbers: true,
          ),
        ),
      );

      final first = tester.getTopLeft(find.text('1'));
      final second = tester.getTopLeft(find.text('2'));
      final rowsForLongLine = (second.dy - first.dy) / 16.0;
      // The long line wraps to several rows; '2' sits below all of them.
      expect(rowsForLongLine, greaterThan(1));
      expect(rowsForLongLine, equals(rowsForLongLine.roundToDouble()));
    });

    testWidgets('gutter width grows with the digit count', (tester) async {
      Widget build(int lineCount) => buildTestApp(
            child: CarbonCodeSnippet(
              code: List.generate(lineCount, (i) => 'x').join('\n'),
              type: CarbonCodeSnippetType.multi,
              showLineNumbers: true,
            ),
          );

      await tester.pumpWidget(build(9));
      final oneDigit = tester.getTopLeft(find.byType(EditableText)).dx;
      await tester.pumpWidget(build(100));
      final threeDigits = tester.getTopLeft(find.byType(EditableText)).dx;
      expect(threeDigits, greaterThan(oneDigit));
    });

    testWidgets('showLineNumbers is a no-op for inline and single', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'one liner',
            type: CarbonCodeSnippetType.single,
            showLineNumbers: true,
          ),
        ),
      );
      expect(find.text('1'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    // ------------------------------------------------------------ a11y

    testWidgets('copy button and container expose semantics labels', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'npm install',
            type: CarbonCodeSnippetType.single,
          ),
        ),
      );

      expect(find.bySemanticsLabel('Copy to clipboard'), findsOneWidget);
      expect(find.bySemanticsLabel('code-snippet'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('labels are overridable', (tester) async {
      final semantics = tester.ensureSemantics();
      final code = List.generate(20, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            labels: const CarbonCodeSnippetLabels(
              showMore: 'Mehr anzeigen',
              copyToClipboard: 'Kopieren',
            ),
          ),
        ),
      );

      expect(find.text('Mehr anzeigen'), findsOneWidget);
      expect(find.bySemanticsLabel('Kopieren'), findsOneWidget);
      semantics.dispose();
    });
  });

  group('CarbonCodeSnippetSkeleton', () {
    testWidgets('single skeleton is 56px with one bar', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonCodeSnippetSkeleton()),
      );
      await tester.pump();

      expect(
        tester.getSize(find.byType(CarbonCodeSnippetSkeleton)).height,
        56,
      );
      expect(find.byType(CarbonSkeleton), findsOneWidget);
    });

    testWidgets('multi skeleton is 98px with three bars', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippetSkeleton(
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );
      await tester.pump();

      expect(
        tester.getSize(find.byType(CarbonCodeSnippetSkeleton)).height,
        98,
      );
      expect(find.byType(CarbonSkeleton), findsNWidgets(3));
    });
  });

  group('CarbonCodeSnippetType', () {
    test('has correct enum values', () {
      expect(CarbonCodeSnippetType.values.length, 3);
      expect(
        CarbonCodeSnippetType.values,
        contains(CarbonCodeSnippetType.inline),
      );
      expect(
        CarbonCodeSnippetType.values,
        contains(CarbonCodeSnippetType.single),
      );
      expect(
        CarbonCodeSnippetType.values,
        contains(CarbonCodeSnippetType.multi),
      );
    });
  });
}
