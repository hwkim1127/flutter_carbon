import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for the native CarbonDatePicker and CarbonTimePicker.
class DateTimePickerDemoPage extends StatefulWidget {
  const DateTimePickerDemoPage({super.key});

  @override
  State<DateTimePickerDemoPage> createState() => _DateTimePickerDemoPageState();
}

class _DateTimePickerDemoPageState extends State<DateTimePickerDemoPage> {
  DateTime? _simpleDate;
  DateTime? _singleDate;
  DateTime? _boundedDate = DateTime.now();
  DateTime? _stayOpenDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? _time = '10:30';
  String? _period = 'AM';
  String? _timezone = 'utc';

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Date & Time Picker',
      description:
          'Native CarbonDatePicker: simple, single, and range variants '
          'with a fully keyboard-navigable calendar (arrows, PageUp/Down, '
          'Home/End, Escape). Dates are typed as mm/dd/yyyy or picked.',
      sections: [
        DemoSection(
          title: 'Simple',
          description:
              'A plain masked input — no calendar. Commit with Enter or by '
              'leaving the field.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonDatePicker(
                variant: CarbonDatePickerVariant.simple,
                labelText: 'Date',
                value: _simpleDate,
                onChanged: (value) => setState(() => _simpleDate = value),
              ),
              const SizedBox(height: 12),
              Text(
                _simpleDate == null
                    ? 'No date committed'
                    : 'Committed: $_simpleDate',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Single with calendar',
          description:
              'Tap the field to open the calendar; ArrowDown moves focus '
              'into the day grid.',
          builder: (context) => CarbonDatePicker(
            labelText: 'Appointment date',
            value: _singleDate,
            onChanged: (value) => setState(() => _singleDate = value),
          ),
        ),
        DemoSection(
          title: 'Min/max bounds',
          description:
              'Days outside ±7 days from today are disabled; the chevrons '
              'stop at the bound months.',
          builder: (context) => CarbonDatePicker(
            labelText: 'Delivery date',
            value: _boundedDate,
            minDate: DateTime.now().subtract(const Duration(days: 7)),
            maxDate: DateTime.now().add(const Duration(days: 7)),
            onChanged: (value) => setState(() => _boundedDate = value),
          ),
        ),
        DemoSection(
          title: 'closeOnSelect: false',
          description: 'The calendar stays open after picking.',
          builder: (context) => CarbonDatePicker(
            labelText: 'Date',
            value: _stayOpenDate,
            closeOnSelect: false,
            onChanged: (value) => setState(() => _stayOpenDate = value),
          ),
        ),
        DemoSection(
          title: 'Range',
          description:
              'Two inputs share one calendar. Pick the start, then the end; '
              'picking before the start restarts the range.',
          builder: (context) => CarbonDatePicker(
            variant: CarbonDatePickerVariant.range,
            labelText: 'Start date',
            endLabelText: 'End date',
            value: _rangeStart,
            endValue: _rangeEnd,
            onRangeChanged: (start, end) => setState(() {
              _rangeStart = start;
              _rangeEnd = end;
            }),
          ),
        ),
        DemoSection(
          title: 'States',
          description: 'Invalid, warning, read-only, and disabled.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonDatePicker(
                labelText: 'Invalid',
                invalid: true,
                invalidText: 'A valid date is required',
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              CarbonDatePicker(
                labelText: 'Warning',
                value: DateTime(2026, 12, 25),
                warn: true,
                warnText: 'Holiday schedules may apply',
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              CarbonDatePicker(
                labelText: 'Read-only',
                value: DateTime(2026, 7, 4),
                readOnly: true,
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              CarbonDatePicker(
                labelText: 'Disabled',
                disabled: true,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Sizes',
          description: 'sm (32px), md (40px), lg (48px).',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final size in CarbonDatePickerSize.values) ...[
                CarbonDatePicker(
                  labelText: '${size.name} — ${size.height.toInt()}px',
                  size: size,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        DemoSection(
          title: 'Time Picker',
          description:
              'A masked hh:mm input with companion selects (AM/PM, '
              'timezone) — the Carbon time picker is not a clock dial. '
              'Validation is consumer-driven: this demo flags anything '
              'that fails the 12-hour pattern.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonTimePicker(
                labelText: 'Select a time',
                value: _time,
                invalid:
                    _time != null &&
                    _time!.isNotEmpty &&
                    !CarbonTimePicker.time12h.hasMatch(_time!),
                invalidText: 'Use hh:mm (12-hour)',
                onChanged: (value) => setState(() => _time = value),
                selects: [
                  CarbonTimePickerSelect<String>(
                    labelText: 'AM/PM',
                    items: const [
                      CarbonSelectItem(value: 'AM', label: 'AM'),
                      CarbonSelectItem(value: 'PM', label: 'PM'),
                    ],
                    value: _period,
                    onChanged: (value) => setState(() => _period = value),
                  ),
                  CarbonTimePickerSelect<String>(
                    labelText: 'Timezone',
                    items: const [
                      CarbonSelectItem(value: 'utc', label: 'UTC'),
                      CarbonSelectItem(value: 'kst', label: 'KST'),
                      CarbonSelectItem(value: 'pst', label: 'PST'),
                    ],
                    value: _timezone,
                    onChanged: (value) => setState(() => _timezone = value),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const CarbonTimePicker(
                labelText: 'Disabled',
                value: '09:00',
                disabled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
