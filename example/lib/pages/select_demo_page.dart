import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for the native CarbonSelect widget.
class SelectDemoPage extends StatefulWidget {
  const SelectDemoPage({super.key});

  @override
  State<SelectDemoPage> createState() => _SelectDemoPageState();
}

class _SelectDemoPageState extends State<SelectDemoPage> {
  static const _fruits = [
    CarbonSelectItem(value: 'apple', label: 'Apple'),
    CarbonSelectItem(value: 'banana', label: 'Banana'),
    CarbonSelectItem(value: 'cherry', label: 'Cherry'),
    CarbonSelectItem(value: 'date', label: 'Date'),
    CarbonSelectItem(value: 'elderberry', label: 'Elderberry'),
  ];

  static const _countries = [
    CarbonSelectItem(value: 'kr', label: 'South Korea'),
    CarbonSelectItem(value: 'us', label: 'United States'),
    CarbonSelectItem(value: 'ca', label: 'Canada'),
    CarbonSelectItem(value: 'au', label: 'Australia'),
    CarbonSelectItem(value: 'jp', label: 'Japan (unavailable)', disabled: true),
  ];

  String? _selectedFruit;
  String? _selectedCountry;
  String? _sizedSelection = 'apple';
  String? _invalidSelection;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Select',
      description:
          'Select allows users to choose one option from a list. Native '
          'Carbon implementation with form states and a Carbon menu.',
      sections: [
        DemoSection(
          title: 'Basic',
          description:
              'Default (md) select with a placeholder. Keyboard: Enter, '
              'Space or arrows open the menu; arrows continue from the '
              'selection.',
          builder: (context) => CarbonSelect<String>(
            labelText: 'Fruit',
            placeholder: 'Choose an option',
            items: _fruits,
            value: _selectedFruit,
            onChanged: (value) => setState(() => _selectedFruit = value),
          ),
        ),
        DemoSection(
          title: 'Helper text and disabled option',
          description: 'Guidance below the field; one option is disabled.',
          builder: (context) => CarbonSelect<String>(
            labelText: 'Country',
            placeholder: 'Select your country',
            helperText: 'Choose the country where you reside',
            items: _countries,
            value: _selectedCountry,
            onChanged: (value) => setState(() => _selectedCountry = value),
          ),
        ),
        DemoSection(
          title: 'Sizes',
          description: 'Extra small (24px) to large (48px).',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final size in CarbonSelectSize.values) ...[
                CarbonSelect<String>(
                  labelText: '${size.name} — ${size.height.toInt()}px',
                  items: _fruits,
                  value: _sizedSelection,
                  size: size,
                  onChanged: (value) =>
                      setState(() => _sizedSelection = value),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        DemoSection(
          title: 'Invalid and warning',
          description: 'Validation states with status icons and text.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonSelect<String>(
                labelText: 'Required field',
                placeholder: 'Choose an option',
                items: _fruits,
                value: _invalidSelection,
                invalid: _invalidSelection == null,
                invalidText: 'A selection is required',
                onChanged: (value) =>
                    setState(() => _invalidSelection = value),
              ),
              const SizedBox(height: 16),
              CarbonSelect<String>(
                labelText: 'With warning',
                items: _fruits,
                value: 'banana',
                warn: true,
                warnText: 'Bananas are almost sold out',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Read-only and disabled',
          description:
              'Read-only stays focusable but the menu does not open; '
              'disabled is inert.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarbonSelect<String>(
                labelText: 'Read-only',
                items: _fruits,
                value: 'cherry',
                readOnly: true,
              ),
              const SizedBox(height: 16),
              const CarbonSelect<String>(
                labelText: 'Disabled',
                items: _fruits,
                value: 'apple',
                disabled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
