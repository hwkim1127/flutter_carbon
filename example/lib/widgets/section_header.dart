import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

/// A standard section header.
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: carbon.text.textSecondary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
