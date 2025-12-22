import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../util/hex_color.dart';

/// Showcase for Layer tokens.
class CarbonLayeringSection extends StatelessWidget {
  const CarbonLayeringSection({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Column(
      children: [
        _LayerBox('Layer 01', carbon.layer.layer01),
        _LayerBox('Layer 02', carbon.layer.layer02),
        _LayerBox('Layer 03', carbon.layer.layer03),
      ],
    );
  }
}

class _LayerBox extends StatelessWidget {
  final String label;
  final Color color;

  const _LayerBox(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Container(
      width: double.infinity,
      height: 60,
      color: color,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: carbon.text.textPrimary)),
          Text(
            color.toHexString(),
            style: TextStyle(
              color: carbon.text.textSecondary,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
