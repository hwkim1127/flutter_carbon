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
