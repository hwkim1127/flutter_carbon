import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../../widgets/demo_page_template.dart';

/// Demo page for Carbon typography styles.
class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return DemoPageTemplate(
      title: 'Typography',
      description:
          'Carbon type styles using IBM Plex font family with different weights and sizes.',
      sections: [
        DemoSection(
          title: 'Headings - Productive',
          description: 'Heading styles for productive use cases',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeStyleItem(
                'Productive Heading 01',
                '14px / Semi-Bold / 0.16ls',
                CarbonTypography.productiveHeading01,
                carbon,
              ),
              _TypeStyleItem(
                'Productive Heading 02',
                '16px / Semi-Bold / 0ls',
                CarbonTypography.productiveHeading02,
                carbon,
              ),
              _TypeStyleItem(
                'Productive Heading 03',
                '20px / Regular / 0ls',
                CarbonTypography.productiveHeading03,
                carbon,
              ),
              _TypeStyleItem(
                'Productive Heading 04',
                '28px / Regular / 0ls',
                CarbonTypography.productiveHeading04,
                carbon,
              ),
              _TypeStyleItem(
                'Productive Heading 05',
                '32px / Regular / 0ls',
                CarbonTypography.productiveHeading05,
                carbon,
              ),
              _TypeStyleItem(
                'Productive Heading 06',
                '42px / Light / 0ls',
                CarbonTypography.productiveHeading06,
                carbon,
              ),
              _TypeStyleItem(
                'Productive Heading 07',
                '54px / Light / 0ls',
                CarbonTypography.productiveHeading07,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Headings - Expressive',
          description: 'Heading styles for expressive use cases',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeStyleItem(
                'Expressive Heading 01',
                '14px / Semi-Bold / 0.16ls',
                CarbonTypography.expressiveHeading01,
                carbon,
              ),
              _TypeStyleItem(
                'Expressive Heading 02',
                '16px / Semi-Bold / 0ls',
                CarbonTypography.expressiveHeading02,
                carbon,
              ),
              _TypeStyleItem(
                'Expressive Heading 03',
                '20px / Regular / 0ls',
                CarbonTypography.expressiveHeading03,
                carbon,
              ),
              _TypeStyleItem(
                'Expressive Heading 04',
                '28px / Regular / 0ls',
                CarbonTypography.expressiveHeading04,
                carbon,
              ),
              _TypeStyleItem(
                'Expressive Heading 05',
                '32px / Regular / 0ls',
                CarbonTypography.expressiveHeading05,
                carbon,
              ),
              _TypeStyleItem(
                'Expressive Heading 06',
                '32px / Semi-Bold / 0ls',
                CarbonTypography.expressiveHeading06,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Body Text',
          description: 'Body text styles for content',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeStyleItem(
                'Body Short 01',
                '14px / Regular / 0.16ls',
                CarbonTypography.bodyShort01,
                carbon,
                sampleText:
                    'This is body short text. Short line height for compact layouts.',
              ),
              _TypeStyleItem(
                'Body Long 01',
                '14px / Regular / 0.16ls',
                CarbonTypography.bodyLong01,
                carbon,
                sampleText:
                    'This is body long text. Increased line height for better readability in longer passages.',
              ),
              _TypeStyleItem(
                'Body Short 02',
                '16px / Regular / 0ls',
                CarbonTypography.bodyShort02,
                carbon,
                sampleText:
                    'This is body short text at 16px. Compact line height.',
              ),
              _TypeStyleItem(
                'Body Long 02',
                '16px / Regular / 0ls',
                CarbonTypography.bodyLong02,
                carbon,
                sampleText:
                    'This is body long text at 16px. Optimized for longer reading passages.',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Labels & Captions',
          description: 'Small text styles for labels and captions',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeStyleItem(
                'Label 01',
                '12px / Regular / 0.32ls',
                CarbonTypography.label01,
                carbon,
              ),
              _TypeStyleItem(
                'Label 02',
                '14px / Regular / 0.16ls',
                CarbonTypography.label02,
                carbon,
              ),
              _TypeStyleItem(
                'Caption 01',
                '12px / Regular / 0.32ls',
                CarbonTypography.caption01,
                carbon,
              ),
              _TypeStyleItem(
                'Caption 02',
                '14px / Regular / 0.32ls',
                CarbonTypography.caption02,
                carbon,
              ),
              _TypeStyleItem(
                'Helper Text 01',
                '12px / Regular / 0.32ls',
                CarbonTypography.helperText01,
                carbon,
              ),
              _TypeStyleItem(
                'Helper Text 02',
                '14px / Regular / 0.16ls',
                CarbonTypography.helperText02,
                carbon,
              ),
              _TypeStyleItem(
                'Legal 01',
                '12px / Regular / 0.32ls',
                CarbonTypography.legal01,
                carbon,
              ),
              _TypeStyleItem(
                'Legal 02',
                '14px / Regular / 0.16ls',
                CarbonTypography.legal02,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Code Styles',
          description: 'Monospace code text styles',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeStyleItem(
                'Code 01',
                '12px / Mono / 0.32ls',
                CarbonTypography.code01,
                carbon,
                sampleText: 'const example = "code";',
              ),
              _TypeStyleItem(
                'Code 02',
                '14px / Mono / 0.32ls',
                CarbonTypography.code02,
                carbon,
                sampleText: 'function example() { return true; }',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Display Styles',
          description: 'Large display text for marketing and hero sections',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeStyleItem(
                'Display 01',
                '42px / Light / 0ls',
                CarbonTypography.display01,
                carbon,
              ),
              _TypeStyleItem(
                'Display 02',
                '42px / Semi-Bold / 0ls',
                CarbonTypography.display02,
                carbon,
              ),
              _TypeStyleItem(
                'Display 03',
                '60px / Light / -0.64ls',
                CarbonTypography.display03,
                carbon,
              ),
              _TypeStyleItem(
                'Display 04',
                '92px / Light / -0.64ls',
                CarbonTypography.display04,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Quotations',
          description: 'Serif styles for quotations',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeStyleItem(
                'Quotation 01',
                '20px / Serif / 0ls',
                CarbonTypography.quotation01,
                carbon,
                sampleText:
                    '"Design is not just what it looks like and feels like."',
              ),
              _TypeStyleItem(
                'Quotation 02',
                '32px / Serif Light / 0ls',
                CarbonTypography.quotation02,
                carbon,
                sampleText: '"Simplicity is the ultimate sophistication."',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypeStyleItem extends StatelessWidget {
  final String name;
  final String specs;
  final TextStyle style;
  final CarbonThemeData carbon;
  final String? sampleText;

  const _TypeStyleItem(
    this.name,
    this.specs,
    this.style,
    this.carbon, {
    this.sampleText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: carbon.text.textPrimary,
                  ),
                ),
              ),
              Text(
                specs,
                style: TextStyle(
                  fontSize: 10,
                  color: carbon.text.textSecondary,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sampleText ?? 'The quick brown fox jumps over the lazy dog',
            style: style.copyWith(color: carbon.text.textPrimary),
          ),
        ],
      ),
    );
  }
}
