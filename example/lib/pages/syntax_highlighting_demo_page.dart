import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Carbon syntax highlighting.
class SyntaxHighlightingDemoPage extends StatelessWidget {
  const SyntaxHighlightingDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return DemoPageTemplate(
      title: 'Syntax Highlighting',
      description:
          'Code syntax highlighting using Carbon Design System color tokens for better code readability.',
      sections: [
        DemoSection(
          title: 'Dart Example',
          description: 'Syntax highlighting for Dart/Flutter code',
          builder: (context) => _CodeBlock(
            lines: [
              _CodeLine([
                _Span('import ', carbon.syntax.syntaxKeyword),
                _Span(
                  "'package:flutter/material.dart'",
                  carbon.syntax.syntaxString,
                ),
                _Span(';', carbon.text.textPrimary),
              ]),
              _CodeLine([]),
              _CodeLine([
                _Span(
                  '// Carbon Design System example',
                  carbon.syntax.syntaxComment,
                ),
              ]),
              _CodeLine([
                _Span('class ', carbon.syntax.syntaxKeyword),
                _Span('MyApp ', carbon.syntax.syntaxTag),
                _Span('extends ', carbon.syntax.syntaxKeyword),
                _Span('StatelessWidget ', carbon.syntax.syntaxTag),
                _Span('{', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('  ', carbon.text.textPrimary),
                _Span('@override', carbon.syntax.syntaxAttribute),
              ]),
              _CodeLine([
                _Span('  Widget ', carbon.syntax.syntaxTag),
                _Span('build', carbon.syntax.syntaxName),
                _Span('(BuildContext context) {', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('    ', carbon.text.textPrimary),
                _Span('return ', carbon.syntax.syntaxKeyword),
                _Span('MaterialApp', carbon.syntax.syntaxTag),
                _Span('(', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('      title: ', carbon.text.textPrimary),
                _Span("'Carbon Theme'", carbon.syntax.syntaxString),
                _Span(',', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('      theme: ', carbon.text.textPrimary),
                _Span('carbonTheme', carbon.syntax.syntaxName),
                _Span('(),', carbon.text.textPrimary),
              ]),
              _CodeLine([_Span('    );', carbon.text.textPrimary)]),
              _CodeLine([_Span('  }', carbon.text.textPrimary)]),
              _CodeLine([_Span('}', carbon.text.textPrimary)]),
            ],
          ),
        ),
        DemoSection(
          title: 'JavaScript Example',
          description: 'Syntax highlighting for JavaScript code',
          builder: (context) => _CodeBlock(
            lines: [
              _CodeLine([
                _Span('const ', carbon.syntax.syntaxKeyword),
                _Span('greeting ', carbon.syntax.syntaxName),
                _Span('= ', carbon.text.textPrimary),
                _Span("'Hello, World!'", carbon.syntax.syntaxString),
                _Span(';', carbon.text.textPrimary),
              ]),
              _CodeLine([]),
              _CodeLine([
                _Span('function ', carbon.syntax.syntaxKeyword),
                _Span('sayHello', carbon.syntax.syntaxName),
                _Span('(', carbon.text.textPrimary),
                _Span('name', carbon.syntax.syntaxVariable),
                _Span(') {', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('  console', carbon.syntax.syntaxName),
                _Span('.', carbon.text.textPrimary),
                _Span('log', carbon.syntax.syntaxName),
                _Span('(', carbon.text.textPrimary),
                _Span('`Hello, ', carbon.syntax.syntaxString),
                _Span('\${', carbon.syntax.syntaxOperatorKeyword),
                _Span('name', carbon.syntax.syntaxName),
                _Span('}', carbon.syntax.syntaxOperatorKeyword),
                _Span('!`', carbon.syntax.syntaxString),
                _Span(');', carbon.text.textPrimary),
              ]),
              _CodeLine([_Span('}', carbon.text.textPrimary)]),
            ],
          ),
        ),
        DemoSection(
          title: 'Python Example',
          description: 'Syntax highlighting for Python code',
          builder: (context) => _CodeBlock(
            lines: [
              _CodeLine([
                _Span(
                  '# Python example with Carbon syntax',
                  carbon.syntax.syntaxComment,
                ),
              ]),
              _CodeLine([
                _Span('import ', carbon.syntax.syntaxKeyword),
                _Span('sys', carbon.syntax.syntaxName),
              ]),
              _CodeLine([]),
              _CodeLine([
                _Span('def ', carbon.syntax.syntaxKeyword),
                _Span('calculate_sum', carbon.syntax.syntaxName),
                _Span('(', carbon.text.textPrimary),
                _Span('a', carbon.syntax.syntaxVariable),
                _Span(', ', carbon.text.textPrimary),
                _Span('b', carbon.syntax.syntaxVariable),
                _Span('):', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('    ', carbon.text.textPrimary),
                _Span(
                  '"""Calculate the sum of two numbers"""',
                  carbon.syntax.syntaxString,
                ),
              ]),
              _CodeLine([
                _Span('    ', carbon.text.textPrimary),
                _Span('return ', carbon.syntax.syntaxKeyword),
                _Span('a ', carbon.text.textPrimary),
                _Span('+ ', carbon.syntax.syntaxOperatorKeyword),
                _Span('b', carbon.text.textPrimary),
              ]),
            ],
          ),
        ),
        DemoSection(
          title: 'JSON Example',
          description: 'Syntax highlighting for JSON data',
          builder: (context) => _CodeBlock(
            lines: [
              _CodeLine([_Span('{', carbon.text.textPrimary)]),
              _CodeLine([
                _Span('  ', carbon.text.textPrimary),
                _Span('"name"', carbon.syntax.syntaxTag),
                _Span(': ', carbon.text.textPrimary),
                _Span('"Carbon Design System"', carbon.syntax.syntaxString),
                _Span(',', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('  ', carbon.text.textPrimary),
                _Span('"version"', carbon.syntax.syntaxTag),
                _Span(': ', carbon.text.textPrimary),
                _Span('"1.0.0"', carbon.syntax.syntaxString),
                _Span(',', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('  ', carbon.text.textPrimary),
                _Span('"active"', carbon.syntax.syntaxTag),
                _Span(': ', carbon.text.textPrimary),
                _Span('true', carbon.syntax.syntaxKeyword),
                _Span(',', carbon.text.textPrimary),
              ]),
              _CodeLine([
                _Span('  ', carbon.text.textPrimary),
                _Span('"count"', carbon.syntax.syntaxTag),
                _Span(': ', carbon.text.textPrimary),
                _Span('42', carbon.syntax.syntaxNumber),
              ]),
              _CodeLine([_Span('}', carbon.text.textPrimary)]),
            ],
          ),
        ),
        DemoSection(
          title: 'Syntax Color Reference',
          description: 'All available syntax highlighting colors',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _ColorSwatch('Keyword', carbon.syntax.syntaxKeyword),
              _ColorSwatch('String', carbon.syntax.syntaxString),
              _ColorSwatch('Comment', carbon.syntax.syntaxComment),
              _ColorSwatch('Name/Function', carbon.syntax.syntaxName),
              _ColorSwatch('Tag/Class', carbon.syntax.syntaxTag),
              _ColorSwatch('Operator', carbon.syntax.syntaxOperatorKeyword),
              _ColorSwatch('Number', carbon.syntax.syntaxNumber),
              _ColorSwatch('Attribute', carbon.syntax.syntaxAttribute),
            ],
          ),
        ),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final List<_CodeLine> lines;

  const _CodeBlock({required this.lines});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: carbon.layer.layer02,
        border: Border.all(color: carbon.layer.borderSubtle01),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) => line).toList(),
      ),
    );
  }
}

class _CodeLine extends StatelessWidget {
  final List<_Span> spans;

  const _CodeLine(this.spans);

  @override
  Widget build(BuildContext context) {
    if (spans.isEmpty) {
      return const SizedBox(height: 20);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'IBMPlexMono',
            fontSize: 13,
            height: 1.5,
          ),
          children: spans
              .map(
                (s) => TextSpan(
                  text: s.text,
                  style: TextStyle(color: s.color),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _Span {
  final String text;
  final Color color;

  _Span(this.text, this.color);
}

class _ColorSwatch extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorSwatch(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: carbon.layer.layer02,
        border: Border.all(color: carbon.layer.borderSubtle01),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: carbon.text.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
