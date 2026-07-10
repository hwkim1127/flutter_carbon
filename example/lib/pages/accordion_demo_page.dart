import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for the native CarbonAccordion widget.
class AccordionDemoPage extends StatefulWidget {
  const AccordionDemoPage({super.key});

  @override
  State<AccordionDemoPage> createState() => _AccordionDemoPageState();
}

class _AccordionDemoPageState extends State<AccordionDemoPage> {
  int? _expandedIndex = 0;

  static const _body =
      'Accordions help organize content and reduce scrolling when there '
      'are multiple sections. The panel opens with the Carbon 110ms '
      'height-and-fade motion.';

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Accordion',
      description:
          'Accordions are vertically stacked lists of headings that reveal '
          'content when clicked. Native Carbon implementation with sizes, '
          'alignment, flush rules, and controlled sections.',
      sections: [
        DemoSection(
          title: 'Basic',
          description:
              'Uncontrolled sections — each tracks its own open state. '
              'Headings work with Enter and Space too.',
          builder: (context) => const CarbonAccordion(
            items: [
              CarbonAccordionItem(
                title: 'Section 1',
                initiallyOpen: true,
                child: Text(_body),
              ),
              CarbonAccordionItem(title: 'Section 2', child: Text(_body)),
              CarbonAccordionItem(title: 'Section 3', child: Text(_body)),
            ],
          ),
        ),
        DemoSection(
          title: 'Sizes',
          description: 'Heading heights: sm (32px), md (40px), lg (48px).',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final size in CarbonAccordionSize.values) ...[
                Text(
                  '${size.name} — ${size.headingHeight.toInt()}px',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                CarbonAccordion(
                  size: size,
                  items: const [
                    CarbonAccordionItem(title: 'Section', child: Text(_body)),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
        DemoSection(
          title: 'Align start',
          description: 'The chevron sits before the title.',
          builder: (context) => const CarbonAccordion(
            align: CarbonAccordionAlign.start,
            items: [
              CarbonAccordionItem(title: 'Section 1', child: Text(_body)),
              CarbonAccordionItem(title: 'Section 2', child: Text(_body)),
            ],
          ),
        ),
        DemoSection(
          title: 'Flush',
          description: 'The 1px rules are inset 16px on each side.',
          builder: (context) => const CarbonAccordion(
            isFlush: true,
            items: [
              CarbonAccordionItem(title: 'Section 1', child: Text(_body)),
              CarbonAccordionItem(title: 'Section 2', child: Text(_body)),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled',
          description: 'Individual sections or the whole accordion.',
          builder: (context) => const CarbonAccordion(
            items: [
              CarbonAccordionItem(title: 'Enabled section', child: Text(_body)),
              CarbonAccordionItem(
                title: 'Disabled section',
                disabled: true,
                child: Text(_body),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Controlled — single open',
          description:
              'Sections driven by state via open/onHeadingClick: opening '
              'one closes the others.',
          builder: (context) => CarbonAccordion(
            items: [
              for (var i = 0; i < 3; i++)
                CarbonAccordionItem(
                  key: ValueKey('controlled-$i'),
                  title: 'Section ${i + 1}',
                  open: _expandedIndex == i,
                  onHeadingClick: (open) =>
                      setState(() => _expandedIndex = open ? i : null),
                  child: const Text(_body),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
