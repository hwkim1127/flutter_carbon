import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonProgressIndicator component.
class ProgressIndicatorDemoPage extends StatefulWidget {
  const ProgressIndicatorDemoPage({super.key});

  @override
  State<ProgressIndicatorDemoPage> createState() =>
      _ProgressIndicatorDemoPageState();
}

class _ProgressIndicatorDemoPageState extends State<ProgressIndicatorDemoPage> {
  int _basicIndex = 1;
  int _tapIndex = 2;
  int _verticalIndex = 1;

  static const _checkoutSteps = [
    CarbonProgressStep(label: 'Cart'),
    CarbonProgressStep(label: 'Shipping'),
    CarbonProgressStep(label: 'Payment'),
    CarbonProgressStep(label: 'Review'),
  ];

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Progress Indicator',
      description:
          'Progress indicators guide users through a multi-step process. '
          'Step states (complete, current, incomplete) are derived automatically '
          'from currentIndex, or can be overridden per step.',
      sections: [
        DemoSection(
          title: 'Basic (Horizontal)',
          description:
              'States derive from currentIndex: steps before it are complete, '
              'the step at it is current, steps after it are incomplete.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonProgressIndicator(
                steps: _checkoutSteps,
                currentIndex: _basicIndex,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CarbonButton(
                    kind: CarbonButtonKind.tertiary,
                    size: CarbonButtonSize.sm,
                    onPressed: _basicIndex > 0
                        ? () => setState(() => _basicIndex--)
                        : null,
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 8),
                  CarbonButton(
                    size: CarbonButtonSize.sm,
                    onPressed: _basicIndex < _checkoutSteps.length - 1
                        ? () => setState(() => _basicIndex++)
                        : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Secondary Labels',
          description: 'Each step can show optional helper text below its label.',
          builder: (context) => const CarbonProgressIndicator(
            currentIndex: 1,
            steps: [
              CarbonProgressStep(
                label: 'Upload',
                secondaryLabel: 'Select your files',
              ),
              CarbonProgressStep(
                label: 'Validate',
                secondaryLabel: 'Checking format',
              ),
              CarbonProgressStep(
                label: 'Process',
                secondaryLabel: 'Waiting',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Tap to Navigate',
          description:
              'When onStepTap is provided, steps become clickable. The current '
              'step and disabled steps stay non-interactive.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonProgressIndicator(
                steps: _checkoutSteps,
                currentIndex: _tapIndex,
                onStepTap: (i) => setState(() => _tapIndex = i),
              ),
              const SizedBox(height: 16),
              Text(
                'Current step: ${_checkoutSteps[_tapIndex].label}',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Invalid State',
          description:
              'A step can override its automatic state, e.g. to flag an error.',
          builder: (context) => const CarbonProgressIndicator(
            currentIndex: 2,
            steps: [
              CarbonProgressStep(label: 'Account'),
              CarbonProgressStep(
                label: 'Billing',
                secondaryLabel: 'Card declined',
                state: CarbonProgressStepState.invalid,
              ),
              CarbonProgressStep(label: 'Confirm'),
              CarbonProgressStep(label: 'Done'),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled Step',
          description:
              'Disabled steps are grayed out and never tappable, even with '
              'onStepTap set.',
          builder: (context) => CarbonProgressIndicator(
            currentIndex: 0,
            onStepTap: (_) {},
            steps: const [
              CarbonProgressStep(label: 'Basics'),
              CarbonProgressStep(label: 'Details'),
              CarbonProgressStep(
                label: 'Add-ons',
                secondaryLabel: 'Unavailable',
                disabled: true,
              ),
              CarbonProgressStep(label: 'Finish'),
            ],
          ),
        ),
        DemoSection(
          title: 'Vertical Orientation',
          description:
              'Set vertical: true to stack steps with the connector line '
              'running downward.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonProgressIndicator(
                vertical: true,
                currentIndex: _verticalIndex,
                onStepTap: (i) => setState(() => _verticalIndex = i),
                steps: const [
                  CarbonProgressStep(
                    label: 'Order placed',
                    secondaryLabel: 'Confirmation sent',
                  ),
                  CarbonProgressStep(label: 'Packed'),
                  CarbonProgressStep(label: 'Shipped'),
                  CarbonProgressStep(label: 'Delivered'),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Natural Width',
          description:
              'By default (spaceEqually: true) steps share width equally. '
              'Set spaceEqually: false to size each step to its content.',
          builder: (context) => const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: CarbonProgressIndicator(
              spaceEqually: false,
              currentIndex: 1,
              steps: [
                CarbonProgressStep(label: 'Start'),
                CarbonProgressStep(label: 'A much longer step label'),
                CarbonProgressStep(label: 'End'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
