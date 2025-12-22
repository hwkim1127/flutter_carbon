import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

class MaterialWidgetsSection extends StatefulWidget {
  const MaterialWidgetsSection({super.key});

  @override
  State<MaterialWidgetsSection> createState() => _MaterialWidgetsSectionState();
}

class _MaterialWidgetsSectionState extends State<MaterialWidgetsSection> {
  bool _switch1 = true;
  bool _switch2 = false;
  bool _checkbox1 = true;
  bool _checkbox2 = false;
  int _radioValue = 0;
  String? _dropdownValue = 'Option 1';
  String? _dropdownValue2;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hour:$mm $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Standard Material Widgets (Automatic Theme Integration)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
            FilledButton(onPressed: () {}, child: const Text('Filled')),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            TextButton(onPressed: () {}, child: const Text('Text')),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _switch1,
                  onChanged: (v) => setState(() => _switch1 = v),
                ),
                const SizedBox(width: 8),
                Text(_switch1 ? 'ON' : 'OFF'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: _switch2,
                  onChanged: (v) => setState(() => _switch2 = v),
                ),
                const SizedBox(width: 8),
                Text(_switch2 ? 'ON' : 'OFF'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _checkbox1,
                  onChanged: (v) => setState(() => _checkbox1 = v ?? false),
                ),
                const Text('Option 1'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _checkbox2,
                  onChanged: (v) => setState(() => _checkbox2 = v ?? false),
                ),
                const Text('Option 2'),
              ],
            ),
            RadioGroup<int>(
              groupValue: _radioValue,
              onChanged: (v) => setState(() => _radioValue = v ?? 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Radio<int>(value: 0),
                  Text('Radio 1'),
                  SizedBox(width: 8),
                  Radio<int>(value: 1),
                  Text('Radio 2'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Standard TextField (Underline)',
            hintText: 'Type something...',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: CarbonInputDecorationHelper.filled(
            context: context,
            labelText: 'Filled TextField',
            hintText: 'With background and border',
          ),
        ),
        const SizedBox(height: 16),

        // Dropdown examples
        const Text(
          'Dropdowns (Carbon Style)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CarbonDropdown<String>(
          value: _dropdownValue,
          label: 'Select an option',
          helperText: 'This is a Carbon-styled dropdown',
          items: ['Option 1', 'Option 2', 'Option 3', 'Option 4']
              .map(
                (value) => CarbonDropdownItem(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: (value) {
            setState(() => _dropdownValue = value);
          },
        ),
        const SizedBox(height: 16),
        CarbonDropdown<String>(
          value: _dropdownValue2,
          label: 'With hint text',
          hint: 'Choose an option...',
          items: ['Apple', 'Banana', 'Cherry', 'Date']
              .map(
                (value) => CarbonDropdownItem(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: (value) {
            setState(() => _dropdownValue2 = value);
          },
        ),
        const SizedBox(height: 16),
        CarbonDropdown<String>(
          value: null,
          label: 'Disabled dropdown',
          enabled: false,
          items: ['Cannot', 'Select']
              .map(
                (value) => CarbonDropdownItem(value: value, child: Text(value)),
              )
              .toList(),
          onChanged: null,
        ),
        const SizedBox(height: 24),
        const Text(
          'Date & Time Pickers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilledButton(
                  onPressed: _pickDate,
                  child: const Text('Open date picker'),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedDate != null
                      ? 'Selected: ${_formatDate(_selectedDate!)}'
                      : 'No date chosen',
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilledButton(
                  onPressed: _pickTime,
                  child: const Text('Open time picker'),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedTime != null
                      ? 'Selected: ${_formatTime(_selectedTime!)}'
                      : 'No time chosen',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
