import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../util/hex_color.dart'; // I should probably create this utility first.

/// Showcase for Typography tokens.
class CarbonTypographySection extends StatelessWidget {
  const CarbonTypographySection({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextRow('Text Primary', carbon.text.textPrimary, fontSize: 16),
        _buildTextRow(
          'Text Secondary',
          carbon.text.textSecondary,
          fontSize: 14,
        ),
        _buildTextRow(
          'Text Placeholder',
          carbon.text.textPlaceholder,
          fontSize: 14,
        ),
        _buildTextRow('Text Helper', carbon.text.textHelper, fontSize: 12),
        _buildTextRow('Text Error', carbon.text.textError, fontSize: 14),
        Text(
          'Link Primary',
          style: TextStyle(
            color: carbon.text.linkPrimary,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Widget _buildTextRow(String label, Color color, {required double fontSize}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: color, fontSize: fontSize),
            ),
          ),
          Text(
            color.toHexString(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
