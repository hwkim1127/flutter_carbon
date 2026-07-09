import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonComboBox', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboBox<String>(
            value: null,
            items: const [
              CarbonComboBoxItem(value: '1', label: 'Option 1'),
              CarbonComboBoxItem(value: '2', label: 'Option 2'),
            ],
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(CarbonComboBox<String>), findsOneWidget);
    });

    testWidgets('tap opens the menu; typing filters; selection closes', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => CarbonComboBox<String>(
              value: selected,
              items: const [
                CarbonComboBoxItem(value: 'apple', label: 'Apple'),
                CarbonComboBoxItem(value: 'banana', label: 'Banana'),
                CarbonComboBoxItem(value: 'cherry', label: 'Cherry'),
              ],
              onChanged: (value) => setState(() => selected = value),
            ),
          ),
        ),
      );

      // Tap on the field text area opens the menu (core onTap path).
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);

      // Typing filters the menu.
      await tester.enterText(find.byType(EditableText), 'ban');
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);

      // Selecting an item reports the value, closes, and fills the field.
      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();
      expect(selected, 'banana');
      expect(find.text('Cherry'), findsNothing);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .controller
            .text,
        'Banana',
      );
    });

    testWidgets('displays label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboBox<String>(
            value: null,
            label: 'Select option',
            items: const [CarbonComboBoxItem(value: '1', label: 'Option 1')],
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Select option'), findsOneWidget);
    });

    testWidgets('displays placeholder when no value selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboBox<String>(
            value: null,
            placeholder: 'Choose...',
            items: const [CarbonComboBoxItem(value: '1', label: 'Option 1')],
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Choose...'), findsOneWidget);
    });

    testWidgets('displays helper text when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboBox<String>(
            value: null,
            helperText: 'Select from dropdown',
            items: const [CarbonComboBoxItem(value: '1', label: 'Option 1')],
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Select from dropdown'), findsOneWidget);
    });

    testWidgets('displays error text when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboBox<String>(
            value: null,
            errorText: 'Required field',
            items: const [CarbonComboBoxItem(value: '1', label: 'Option 1')],
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Required field'), findsOneWidget);
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboBox<String>(
            value: null,
            enabled: false,
            items: const [CarbonComboBoxItem(value: '1', label: 'Option 1')],
            onChanged: (_) {},
          ),
        ),
      );

      final comboBox = tester.widget<CarbonComboBox<String>>(
        find.byType(CarbonComboBox<String>),
      );
      expect(comboBox.enabled, isFalse);
    });

    testWidgets('supports allowClear option', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboBox<String>(
            value: '1',
            allowClear: true,
            items: const [CarbonComboBoxItem(value: '1', label: 'Option 1')],
            onChanged: (_) {},
          ),
        ),
      );

      final comboBox = tester.widget<CarbonComboBox<String>>(
        find.byType(CarbonComboBox<String>),
      );
      expect(comboBox.allowClear, isTrue);
    });
  });

  group('CarbonComboBoxItem', () {
    test('creates item with value and label', () {
      const item = CarbonComboBoxItem<String>(
        value: 'test',
        label: 'Test Label',
      );
      expect(item.value, 'test');
      expect(item.label, 'Test Label');
    });
  });
}
