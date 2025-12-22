import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

class CarbonStatusSection extends StatelessWidget {
  const CarbonStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _StatusIndicator(color: carbon.status.statusRed, label: 'Red (Error)'),
        _StatusIndicator(
          color: carbon.status.statusGreen,
          label: 'Green (Success)',
        ),
        _StatusIndicator(
          color: carbon.status.statusOrange,
          label: 'Orange (Warning)',
        ),
        _StatusIndicator(
          color: carbon.status.statusYellow,
          label: 'Yellow (Caution)',
        ),
        _StatusIndicator(color: carbon.status.statusBlue, label: 'Blue (Info)'),
        _StatusIndicator(color: carbon.status.statusPurple, label: 'Purple'),
        _StatusIndicator(color: carbon.status.statusGray, label: 'Gray'),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusIndicator({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: carbon.text.textPrimary, fontSize: 12),
        ),
      ],
    );
  }
}
