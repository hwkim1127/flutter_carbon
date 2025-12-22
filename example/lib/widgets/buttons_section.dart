import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

/// Showcase for Button tokens.
class CarbonButtonsSection extends StatelessWidget {
  const CarbonButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _CarbonButton(
          label: 'Primary',
          textColor: carbon.text.textOnColor,
          backgroundColor: carbon.button.buttonPrimary,
        ),
        _CarbonButton(
          label: 'Secondary',
          textColor: carbon.text.textOnColor,
          backgroundColor: carbon.button.buttonSecondary,
        ),
        _CarbonButton(
          label: 'Tertiary',
          textColor: carbon.text.textPrimary,
          backgroundColor: Colors.transparent,
          borderColor: carbon.button.buttonTertiary,
        ),
        _CarbonButton(
          label: 'Danger',
          textColor: carbon.text.textOnColor,
          backgroundColor: carbon.button.buttonDangerPrimary,
        ),
        _CarbonButton(
          label: 'Disabled',
          textColor: carbon.text.textDisabled,
          backgroundColor: carbon.button.buttonDisabled,
        ),
      ],
    );
  }
}

class _CarbonButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color? backgroundColor;
  final Color? borderColor;

  const _CarbonButton({
    required this.label,
    required this.textColor,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
