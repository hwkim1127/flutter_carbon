import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

class CarbonContentSwitcherSection extends StatelessWidget {
  const CarbonContentSwitcherSection({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SwitcherItem(
              label: 'Selected',
              bg: carbon.contentSwitcher.contentSwitcherSelected,
              text: carbon.contentSwitcher.contentSwitcherTextOnColor,
              isSelected: true,
            ),
            Container(
              width: 1,
              height: 40,
              color: carbon.contentSwitcher.contentSwitcherDivider,
            ),
            _SwitcherItem(
              label: 'Unselected',
              bg: carbon.contentSwitcher.contentSwitcherBackground,
              text: carbon.text.textPrimary,
              isSelected: false,
            ),
            Container(
              width: 1,
              height: 40,
              color: carbon.contentSwitcher.contentSwitcherDivider,
            ),
            _SwitcherItem(
              label: 'Hover',
              bg: carbon.contentSwitcher.contentSwitcherBackgroundHover,
              text: carbon.text.textPrimary,
              isSelected: false,
            ),
          ],
        ),
      ],
    );
  }
}

class _SwitcherItem extends StatelessWidget {
  final String label;
  final Color bg;
  final Color text;
  final bool isSelected;

  const _SwitcherItem({
    required this.label,
    required this.bg,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: bg,
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
