import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonCodeSnippet', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(code: 'print("Hello World")'),
        ),
      );
      expect(find.byType(CarbonCodeSnippet), findsOneWidget);
    });

    testWidgets('multi variant never soft-wraps (long lines scroll)', (
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

      // 5 logical lines at fontSize 14 × height 1.5 = 105px. Any soft wrap
      // (e.g. the caret margin eating into the measured width) adds a line.
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      final lineHeight =
          editable.style.fontSize! * (editable.style.height ?? 1.0);
      expect(
        tester.getSize(find.byType(EditableText)).height,
        closeTo(5 * lineHeight, 1),
      );
    });

    testWidgets('multi variant is a read-only native editable; expand '
        'updates the visible text', (tester) async {
      final code = List.generate(6, (i) => 'line ${i + 1}').join('\n');
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            maxCollapsedLines: 3,
          ),
        ),
      );

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.readOnly, isTrue);
      expect(editable.controller.text, 'line 1\nline 2\nline 3');

      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .controller
            .text,
        code,
      );
      expect(find.text('Show less'), findsOneWidget);
    });

    testWidgets('displays code', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(code: 'const greeting = "Hello";'),
        ),
      );
      expect(find.textContaining('greeting'), findsOneWidget);
    });

    testWidgets('supports inline type', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'inline code',
            type: CarbonCodeSnippetType.inline,
          ),
        ),
      );

      final snippet = tester.widget<CarbonCodeSnippet>(
        find.byType(CarbonCodeSnippet),
      );
      expect(snippet.type, CarbonCodeSnippetType.inline);
    });

    testWidgets('supports single type', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'single line',
            type: CarbonCodeSnippetType.single,
          ),
        ),
      );

      final snippet = tester.widget<CarbonCodeSnippet>(
        find.byType(CarbonCodeSnippet),
      );
      expect(snippet.type, CarbonCodeSnippetType.single);
    });

    testWidgets('supports multi type', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'line 1\nline 2\nline 3',
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );

      final snippet = tester.widget<CarbonCodeSnippet>(
        find.byType(CarbonCodeSnippet),
      );
      expect(snippet.type, CarbonCodeSnippetType.multi);
    });

    testWidgets('shows copy button by default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'test',
            type: CarbonCodeSnippetType.single,
          ),
        ),
      );

      final snippet = tester.widget<CarbonCodeSnippet>(
        find.byType(CarbonCodeSnippet),
      );
      expect(snippet.showCopyButton, isTrue);
    });

    testWidgets('can hide copy button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(code: 'test', showCopyButton: false),
        ),
      );

      final snippet = tester.widget<CarbonCodeSnippet>(
        find.byType(CarbonCodeSnippet),
      );
      expect(snippet.showCopyButton, isFalse);
    });

    testWidgets('supports custom feedback message', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'test',
            feedbackMessage: 'Code copied!',
          ),
        ),
      );

      final snippet = tester.widget<CarbonCodeSnippet>(
        find.byType(CarbonCodeSnippet),
      );
      expect(snippet.feedbackMessage, 'Code copied!');
    });

    testWidgets('uses monospace font by default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonCodeSnippet(code: 'test')),
      );

      final snippet = tester.widget<CarbonCodeSnippet>(
        find.byType(CarbonCodeSnippet),
      );
      expect(snippet.useMonospace, isTrue);
    });

    testWidgets('supports custom max collapsed lines', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'test',
            type: CarbonCodeSnippetType.multi,
            maxCollapsedLines: 5,
          ),
        ),
      );

      final snippet = tester.widget<CarbonCodeSnippet>(
        find.byType(CarbonCodeSnippet),
      );
      expect(snippet.maxCollapsedLines, 5);
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
