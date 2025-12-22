import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

class CarbonSyntaxSection extends StatelessWidget {
  const CarbonSyntaxSection({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Container(
      padding: const EdgeInsets.all(16),
      color: carbon.layer.layer01,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CodeLine([
            _Span('import ', carbon.syntax.syntaxKeyword),
            _Span('package:flutter/material.dart', carbon.syntax.syntaxString),
            _Span(';', carbon.text.textPrimary),
          ]),
          const SizedBox(height: 4),
          _CodeLine([
            _Span('// Syntax Highlighting Demo', carbon.syntax.syntaxComment),
          ]),
          const SizedBox(height: 4),
          _CodeLine([
            _Span('void ', carbon.syntax.syntaxKeyword),
            _Span('main', carbon.syntax.syntaxName),
            _Span('() {', carbon.text.textPrimary),
          ]),
          const SizedBox(height: 4),
          _CodeLine([
            _Span('  print', carbon.syntax.syntaxName),
            _Span('(', carbon.text.textPrimary),
            _Span("'Hello Carbon!'", carbon.syntax.syntaxString),
            _Span(');', carbon.text.textPrimary),
          ]),
          const SizedBox(height: 4),
          _CodeLine([_Span('}', carbon.text.textPrimary)]),
        ],
      ),
    );
  }
}

class _CodeLine extends StatelessWidget {
  final List<_Span> spans;
  const _CodeLine(this.spans);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        children: spans
            .map(
              (s) => TextSpan(
                text: s.text,
                style: TextStyle(color: s.color),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Span {
  final String text;
  final Color color;
  _Span(this.text, this.color);
}
