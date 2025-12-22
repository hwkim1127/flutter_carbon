import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page showcasing Material date & time pickers themed by Carbon.
class DateTimePickerDemoPage extends StatefulWidget {
  const DateTimePickerDemoPage({super.key});

  @override
  State<DateTimePickerDemoPage> createState() => _DateTimePickerDemoPageState();
}

class _DateTimePickerDemoPageState extends State<DateTimePickerDemoPage> {
  DateTime? _selectedDate;
  DateTimeRange? _selectedRange;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate() async {
    final current = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? current,
      firstDate: DateTime(current.year - 1),
      lastDate: DateTime(current.year + 2),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickDateRange() async {
    final current = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(current.year - 1),
      lastDate: DateTime(current.year + 2),
      initialDateRange:
          _selectedRange ??
          DateTimeRange(
            start: current,
            end: current.add(const Duration(days: 7)),
          ),
    );

    if (picked != null) {
      setState(() => _selectedRange = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  String _formatRange(DateTimeRange range) {
    return '${_formatDate(range.start)} → ${_formatDate(range.end)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hour:$mm $period';
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Date & Time Pickers',
      description:
          'Material date/time pickers adopt the active Carbon theme through the carbonTheme bridge.',
      sections: [
        DemoSection(
          title: 'Date Picker',
          description:
              'Standard Material date picker themed automatically from Carbon tokens.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton(
                onPressed: _pickDate,
                child: const Text('Choose date'),
              ),
              const SizedBox(height: 12),
              Text(
                _selectedDate != null
                    ? 'Selected date: ${_formatDate(_selectedDate!)}'
                    : 'No date selected',
                style: TextStyle(color: context.carbon.text.textSecondary),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Date Range Picker',
          description: 'Example using Material’s built-in date range dialog.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton(
                onPressed: _pickDateRange,
                child: const Text('Choose range'),
              ),
              const SizedBox(height: 12),
              Text(
                _selectedRange != null
                    ? 'Selected range: ${_formatRange(_selectedRange!)}'
                    : 'No range selected',
                style: TextStyle(color: context.carbon.text.textSecondary),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Time Picker',
          description:
              'Material time picker inherits Carbon colors via the Material theme bridge.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton(
                onPressed: _pickTime,
                child: const Text('Choose time'),
              ),
              const SizedBox(height: 12),
              Text(
                _selectedTime != null
                    ? 'Selected time: ${_formatTime(_selectedTime!)}'
                    : 'No time selected',
                style: TextStyle(color: context.carbon.text.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
