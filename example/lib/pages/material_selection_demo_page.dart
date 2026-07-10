import 'package:flutter/material.dart';

import '../widgets/demo_page_template.dart';

class MaterialSelectionDemoPage extends StatefulWidget {
  const MaterialSelectionDemoPage({super.key});

  @override
  State<MaterialSelectionDemoPage> createState() =>
      _MaterialSelectionDemoPageState();
}

class _MaterialSelectionDemoPageState extends State<MaterialSelectionDemoPage> {
  bool _checkboxValue1 = false;
  bool _checkboxValue2 = true;

  int _radioValue = 1;

  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Material Selection Controls',
      description:
          'Standard Material selection controls (Checkbox, Radio, Switch) automatically themed to match Carbon Design System. For sliders, see the native CarbonSlider demo under Forms.',
      sections: [
        DemoSection(
          title: 'Checkbox',
          description: 'Material Checkbox with Carbon styling',
          builder: (context) => Column(
            children: [
              CheckboxListTile(
                title: const Text('Option 1'),
                value: _checkboxValue1,
                onChanged: (value) => setState(() => _checkboxValue1 = value!),
              ),
              CheckboxListTile(
                title: const Text('Option 2 (Selected)'),
                value: _checkboxValue2,
                onChanged: (value) => setState(() => _checkboxValue2 = value!),
              ),
              CheckboxListTile(
                title: const Text('Option 3 (Disabled, indeterminate)'),
                tristate: true, // value: null asserts without it
                value: null,
                onChanged: null,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Radio Button',
          description: 'Material Radio with Carbon styling',
          builder: (context) => RadioGroup<int>(
            groupValue: _radioValue,
            onChanged: (value) => setState(() => _radioValue = value!),
            child: Column(
              children: [
                RadioListTile<int>(
                  title: const Text('Option 1'),
                  value: 1,
                ),
                RadioListTile<int>(
                  title: const Text('Option 2'),
                  value: 2,
                ),
                RadioListTile<int>(
                  title: const Text('Option 3 (Disabled)'),
                  value: 3,
                  toggleable: false,
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Switch',
          description:
              'Material Switch with Carbon styling (use CarbonToggle for strict compliance)',
          builder: (context) => Column(
            children: [
              SwitchListTile(
                title: const Text('Enable feature'),
                value: _switchValue,
                onChanged: (value) => setState(() => _switchValue = value),
              ),
              SwitchListTile(
                title: const Text('Disabled'),
                value: false,
                onChanged: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
