import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for the native CarbonSlider widget.
class SliderDemoPage extends StatefulWidget {
  const SliderDemoPage({super.key});

  @override
  State<SliderDemoPage> createState() => _SliderDemoPageState();
}

class _SliderDemoPageState extends State<SliderDemoPage> {
  double _basic = 50;
  double _noInput = 30;
  double _stepped = 40;
  double _rangeLower = 20;
  double _rangeUpper = 80;
  CarbonSliderChange? _lastRelease;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Slider',
      description:
          'Sliders let users select a value from a range. Native Carbon '
          'implementation with drag, keyboard (arrows, Shift for larger '
          'steps, Home/End), an embedded number input, and a two-handle '
          'range mode.',
      sections: [
        DemoSection(
          title: 'Basic',
          description:
              'Default slider with the number input. Type a value and press '
              'Enter to commit (out-of-range values clamp).',
          builder: (context) => CarbonSlider(
            labelText: 'Value',
            min: 0,
            max: 100,
            value: _basic,
            onChanged: (change) => setState(() => _basic = change.value),
          ),
        ),
        DemoSection(
          title: 'Without text input',
          description: 'hideTextInput removes the number field.',
          builder: (context) => CarbonSlider(
            labelText: 'Volume',
            min: 0,
            max: 100,
            value: _noInput,
            hideTextInput: true,
            onChanged: (change) => setState(() => _noInput = change.value),
          ),
        ),
        DemoSection(
          title: 'Steps and onRelease',
          description:
              'step: 10 snaps values; Shift+arrow moves by step × '
              'stepMultiplier. onRelease fires at the end of an interaction.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonSlider(
                labelText: 'Stepped (10s)',
                min: 0,
                max: 100,
                step: 10,
                value: _stepped,
                onChanged: (change) => setState(() => _stepped = change.value),
                onRelease: (change) => setState(() => _lastRelease = change),
              ),
              const SizedBox(height: 12),
              Text(
                _lastRelease == null
                    ? 'No release yet'
                    : 'Last release: ${_lastRelease!.value.round()}',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Range (two handles)',
          description:
              'valueUpper enables range mode: track taps move the nearest '
              'handle and the handles cannot cross.',
          builder: (context) => CarbonSlider(
            labelText: 'Price range',
            min: 0,
            max: 100,
            value: _rangeLower,
            valueUpper: _rangeUpper,
            onChanged: (change) => setState(() {
              _rangeLower = change.value;
              _rangeUpper = change.valueUpper!;
            }),
          ),
        ),
        DemoSection(
          title: 'Validation',
          description: 'invalid and warn widen the input and add an icon.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonSlider(
                labelText: 'Invalid',
                min: 0,
                max: 100,
                value: 90,
                invalid: true,
                invalidText: 'The value exceeds the safe threshold',
                onChanged: (_) {},
              ),
              const SizedBox(height: 24),
              CarbonSlider(
                labelText: 'Warning',
                min: 0,
                max: 100,
                value: 75,
                warn: true,
                warnText: 'Approaching the limit',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Read-only and disabled',
          description:
              'Read-only handles stay focusable but nothing changes the '
              'value; disabled is inert.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarbonSlider(
                labelText: 'Read-only',
                min: 0,
                max: 100,
                value: 60,
                readOnly: true,
              ),
              const SizedBox(height: 24),
              const CarbonSlider(
                labelText: 'Disabled',
                min: 0,
                max: 100,
                value: 40,
                disabled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
