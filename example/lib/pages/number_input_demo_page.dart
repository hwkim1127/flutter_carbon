import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonNumberInput component.
class NumberInputDemoPage extends StatefulWidget {
  const NumberInputDemoPage({super.key});

  @override
  State<NumberInputDemoPage> createState() => _NumberInputDemoPageState();
}

class _NumberInputDemoPageState extends State<NumberInputDemoPage> {
  double _basicValue = 0;
  double _rangeValue = 5;
  double _stepValue = 10;
  double _decimalValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Number Input',
      description:
          'Number inputs allow users to enter numeric values with increment/decrement controls.',
      sections: [
        DemoSection(
          title: 'Basic Number Input',
          description: 'Simple number input with default settings',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonNumberInput(
                label: 'Quantity',
                value: _basicValue,
                onChanged: (value) {
                  setState(() {
                    _basicValue = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Current value: $_basicValue',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Number Input with Range',
          description: 'Number input with minimum and maximum values',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonNumberInput(
                label: 'Select a number (0-10)',
                helperText: 'Value must be between 0 and 10',
                value: _rangeValue,
                min: 0,
                max: 10,
                onChanged: (value) {
                  setState(() {
                    _rangeValue = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Current value: $_rangeValue',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Number Input with Custom Step',
          description: 'Number input that increments by a custom step value',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonNumberInput(
                label: 'Count by tens',
                helperText: 'Increments/decrements by 10',
                value: _stepValue,
                step: 10,
                onChanged: (value) {
                  setState(() {
                    _stepValue = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Current value: $_stepValue',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Number Input with Decimals',
          description: 'Number input supporting decimal values',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonNumberInput(
                label: 'Decimal value',
                helperText: 'Supports decimal increments',
                value: _decimalValue,
                step: 0.5,
                min: 0,
                max: 10,
                onChanged: (value) {
                  setState(() {
                    _decimalValue = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Current value: $_decimalValue',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled Number Input',
          description: 'Number input in disabled state',
          builder: (context) => const CarbonNumberInput(
            label: 'Disabled input',
            helperText: 'This input is disabled',
            value: 5,
            disabled: true,
          ),
        ),
        DemoSection(
          title: 'Invalid Number Input',
          description: 'Number input with validation error',
          builder: (context) => const CarbonNumberInput(
            label: 'Invalid input',
            value: 15,
            min: 0,
            max: 10,
            invalid: true,
            invalidText: 'Value must be between 0 and 10',
          ),
        ),
        DemoSection(
          title: 'Number Input without Steppers',
          description: 'Number input with hidden increment/decrement buttons',
          builder: (context) => const CarbonNumberInput(
            label: 'No steppers',
            helperText: 'Type the value directly',
            value: 42,
            hideSteppers: true,
          ),
        ),
      ],
    );
  }
}
