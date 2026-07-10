import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonDartHighlighter', () {
    const highlighter = CarbonDartHighlighter();

    CarbonSyntaxSpan? spanAt(
      List<CarbonSyntaxSpan> spans,
      String code,
      String fragment,
    ) {
      final start = code.indexOf(fragment);
      for (final span in spans) {
        if (span.start == start && span.end == start + fragment.length) {
          return span;
        }
      }
      return null;
    }

    test('classifies comments, strings, keywords, types, and numbers', () {
      const code = '''
// a comment
/// a doc comment
import 'dart:async';

class MyApp extends StatelessWidget {
  final int count = 42;
  bool ready = false;
  String? name;

  void run() {
    if (ready) return;
    print('hello \$name');
  }
}
''';
      final spans = highlighter.highlight(code);

      expect(
        spanAt(spans, code, '// a comment')?.kind,
        CarbonSyntaxKind.lineComment,
      );
      expect(
        spanAt(spans, code, '/// a doc comment')?.kind,
        CarbonSyntaxKind.docComment,
      );
      expect(
        spanAt(spans, code, "'dart:async'")?.kind,
        CarbonSyntaxKind.string,
      );
      expect(
        spanAt(spans, code, 'import')?.kind,
        CarbonSyntaxKind.moduleKeyword,
      );
      expect(
        spanAt(spans, code, 'class')?.kind,
        CarbonSyntaxKind.definitionKeyword,
      );
      expect(spanAt(spans, code, 'MyApp')?.kind, CarbonSyntaxKind.typeName);
      expect(
        spanAt(spans, code, 'StatelessWidget')?.kind,
        CarbonSyntaxKind.typeName,
      );
      expect(spanAt(spans, code, '42')?.kind, CarbonSyntaxKind.number);
      expect(spanAt(spans, code, 'false')?.kind, CarbonSyntaxKind.boolean);
      expect(spanAt(spans, code, 'if')?.kind, CarbonSyntaxKind.controlKeyword);
      expect(
        spanAt(spans, code, 'return')?.kind,
        CarbonSyntaxKind.controlKeyword,
      );
      // `hello` lives inside the string — must NOT be a separate span.
      expect(spanAt(spans, code, 'hello'), isNull);
    });

    test('keywords inside comments and strings are not classified', () {
      const code = "// class if return\nfinal s = 'class import';";
      final spans = highlighter.highlight(code);

      // Only: the comment, `final`, and the string. No keyword spans inside.
      expect(spans.map((s) => s.kind), [
        CarbonSyntaxKind.lineComment,
        CarbonSyntaxKind.definitionKeyword,
        CarbonSyntaxKind.string,
      ]);
    });

    test('spans are sorted and non-overlapping', () {
      const code = "void main() { print('x'); } // done";
      final spans = highlighter.highlight(code);
      for (var i = 1; i < spans.length; i++) {
        expect(spans[i].start, greaterThanOrEqualTo(spans[i - 1].end));
      }
    });
  });

  group('CarbonCodeSnippet highlighting', () {
    testWidgets('multi variant paints colored spans via the controller', (
      tester,
    ) async {
      const code = "import 'a.dart';\nclass Foo {}";
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: code,
            type: CarbonCodeSnippetType.multi,
            highlighter: CarbonDartHighlighter(),
          ),
        ),
      );

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      final span = editable.controller.buildTextSpan(
        context: tester.element(find.byType(EditableText)),
        style: editable.style,
        withComposing: false,
      );

      final children = span.children!;
      expect(children.length, greaterThan(3));

      // The keyword span carries the theme's syntax color.
      final carbon = WhiteTheme.theme;
      final importSpan = children.whereType<TextSpan>().firstWhere(
        (child) => child.text == 'import',
      );
      expect(importSpan.style?.color, carbon.syntax.syntaxModuleKeyword);

      // Selection/copy still works: text roundtrip unchanged.
      expect(editable.controller.text, code);
    });

    testWidgets('without a highlighter the span is plain', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'class Foo {}',
            type: CarbonCodeSnippetType.multi,
          ),
        ),
      );

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      final span = editable.controller.buildTextSpan(
        context: tester.element(find.byType(EditableText)),
        style: editable.style,
        withComposing: false,
      );
      expect(span.children, isNull);
      expect(span.text, 'class Foo {}');
    });

    testWidgets('single variant renders rich text when highlighted', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCodeSnippet(
            code: 'final x = 1;',
            type: CarbonCodeSnippetType.single,
            highlighter: CarbonDartHighlighter(),
          ),
        ),
      );

      final rich = tester.widget<Text>(find.byType(Text).first);
      expect(rich.textSpan, isNotNull);
      expect((rich.textSpan! as TextSpan).children, isNotEmpty);
    });

    testWidgets('highlighting stays in sync when the code changes', (
      tester,
    ) async {
      Widget build(String code) => buildTestApp(
            child: CarbonCodeSnippet(
              code: code,
              type: CarbonCodeSnippetType.multi,
              highlighter: const CarbonDartHighlighter(),
            ),
          );

      await tester.pumpWidget(
        build(List.generate(3, (i) => 'class C$i {}').join('\n')),
      );
      await tester.pumpWidget(
        build(List.generate(6, (i) => 'class C$i {}').join('\n')),
      );
      await tester.pumpAndSettle();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      final span = editable.controller.buildTextSpan(
        context: tester.element(find.byType(EditableText)),
        style: editable.style,
        withComposing: false,
      );
      // ALL six class keywords must be classified — spans were recomputed
      // for the new text in didUpdateWidget.
      final classSpans = span.children!.whereType<TextSpan>().where(
        (child) => child.text == 'class',
      );
      expect(classSpans.length, 6);
      expect(tester.takeException(), isNull);
    });
  });
}
