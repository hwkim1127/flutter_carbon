import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

/// Template for consistent component demo pages.
class DemoPageTemplate extends StatelessWidget {
  final String title;
  final String? description;
  final List<DemoSection> sections;

  const DemoPageTemplate({
    super.key,
    required this.title,
    this.description,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        backgroundColor: carbon.layer.layer01,
        foregroundColor: carbon.text.textPrimary,
      ),
      backgroundColor: carbon.layer.layer01,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length + (description != null ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          if (description != null && index == 0) {
            return _buildDescriptionCard(carbon);
          }

          final sectionIndex = description != null ? index - 1 : index;
          return _buildSection(context, sections[sectionIndex], carbon);
        },
      ),
    );
  }

  Widget _buildDescriptionCard(CarbonThemeData carbon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: carbon.layer.layer01,
        border: Border.all(color: carbon.layer.borderSubtle01),
      ),
      child: Text(
        description!,
        style: TextStyle(
          fontSize: 14,
          height: 1.43,
          color: carbon.text.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    DemoSection section,
    CarbonThemeData carbon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          section.title,
          style: TextStyle(
            fontSize: 20,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: carbon.text.textPrimary,
          ),
        ),
        if (section.description != null) ...[
          const SizedBox(height: 4),
          Text(
            section.description!,
            style: TextStyle(
              fontSize: 14,
              height: 1.43,
              color: carbon.text.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Section content
        section.builder == null
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: carbon.layer.layer01,
                  border: Border.all(color: carbon.layer.borderSubtle01),
                ),
                child: section.builder!(context),
              ),
      ],
    );
  }
}

/// A section within a demo page.
class DemoSection {
  final String title;
  final String? description;
  final WidgetBuilder? builder;

  const DemoSection({required this.title, this.description, this.builder});
}
