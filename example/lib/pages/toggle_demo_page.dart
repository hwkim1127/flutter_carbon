import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonToggle component.
class ToggleDemoPage extends StatefulWidget {
  const ToggleDemoPage({super.key});

  @override
  State<ToggleDemoPage> createState() => _ToggleDemoPageState();
}

class _ToggleDemoPageState extends State<ToggleDemoPage> {
  bool _basicToggle = false;
  bool _withLabelToggle = true;
  bool _customTextToggle = false;
  bool _smallToggle = false;
  bool _hideLabelToggle = true;
  bool _setting1 = false;
  bool _setting2 = true;
  bool _setting3 = false;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Toggle',
      description:
          'Toggle switches are used for binary on/off states. Carbon toggles are smaller than Material switches.',
      sections: [
        DemoSection(
          title: 'Basic Toggle',
          description: 'Simple toggle with default on/off text',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonToggle(
                value: _basicToggle,
                onChanged: (value) {
                  setState(() {
                    _basicToggle = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${_basicToggle ? "On" : "Off"}',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Toggle with Label',
          description: 'Toggle with label text',
          builder: (context) => CarbonToggle(
            value: _withLabelToggle,
            labelText: 'Enable notifications',
            onChanged: (value) {
              setState(() {
                _withLabelToggle = value;
              });
            },
          ),
        ),
        DemoSection(
          title: 'Toggle with Custom Text',
          description: 'Toggle with custom on/off text',
          builder: (context) => CarbonToggle(
            value: _customTextToggle,
            labelText: 'Dark mode',
            onText: 'Dark',
            offText: 'Light',
            onChanged: (value) {
              setState(() {
                _customTextToggle = value;
              });
            },
          ),
        ),
        DemoSection(
          title: 'Small Toggle',
          description: 'Compact toggle size (32×16px with checkmark)',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonToggle(
                value: _smallToggle,
                labelText: 'Enable feature',
                size: CarbonToggleSize.small,
                onChanged: (value) {
                  setState(() {
                    _smallToggle = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Small toggles (32×16px) show a checkmark when enabled.',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Toggle Without Label',
          description: 'Hide label but keep on/off text',
          builder: (context) => CarbonToggle(
            value: _hideLabelToggle,
            labelText: 'This label is hidden',
            hideLabel: true,
            onChanged: (value) {
              setState(() {
                _hideLabelToggle = value;
              });
            },
          ),
        ),
        DemoSection(
          title: 'Disabled Toggle',
          description: 'Toggle in disabled state',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonToggle(
                value: false,
                labelText: 'Disabled (off)',
                onChanged: null,
              ),
              const SizedBox(height: 16),
              CarbonToggle(
                value: true,
                labelText: 'Disabled (on)',
                onChanged: null,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Read-only Toggle',
          description: 'Toggle in read-only state',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonToggle(
                value: false,
                labelText: 'Read-only (off)',
                readOnly: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              CarbonToggle(
                value: true,
                labelText: 'Read-only (on)',
                readOnly: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Settings Example',
          description: 'Multiple toggles in a settings panel',
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: context.carbon.layer.borderSubtle01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.carbon.text.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                CarbonToggle(
                  value: _setting1,
                  labelText: 'Email notifications',
                  onChanged: (value) {
                    setState(() {
                      _setting1 = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                CarbonToggle(
                  value: _setting2,
                  labelText: 'Push notifications',
                  onChanged: (value) {
                    setState(() {
                      _setting2 = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                CarbonToggle(
                  value: _setting3,
                  labelText: 'SMS notifications',
                  onChanged: (value) {
                    setState(() {
                      _setting3 = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Size Comparison',
          description: 'Regular (48×24px) vs Small (32×16px)',
          builder: (context) => Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Regular',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CarbonToggle(
                    value: true,
                    hideLabel: true,
                    onChanged: (value) {},
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Small',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  CarbonToggle(
                    value: true,
                    hideLabel: true,
                    size: CarbonToggleSize.small,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
