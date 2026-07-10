import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import 'package:flutter_carbon/src/widgets/carbon_menu.dart'
    show CarbonMenuPanel;

import '../shared/build.dart';

void main() {
  group('CarbonMenuPanel', () {
    testWidgets('renders items and divider', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: const [
              CarbonMenuItem(label: 'Edit', value: 'edit'),
              CarbonMenuItemDivider(),
              CarbonMenuItem(label: 'Delete', value: 'delete',
                  kind: CarbonMenuItemKind.danger),
            ],
            onClose: () {},
          ),
        ),
      );

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('tap fires onTap, onSelected, and onClose in order', (
      tester,
    ) async {
      final calls = <String>[];
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: [
              CarbonMenuItem(
                label: 'Edit',
                value: 'edit',
                onTap: () => calls.add('onTap'),
              ),
            ],
            onSelected: (value) => calls.add('onSelected:$value'),
            onClose: () => calls.add('onClose'),
          ),
        ),
      );

      await tester.tap(find.text('Edit'));
      expect(calls, ['onTap', 'onSelected:edit', 'onClose']);
    });

    testWidgets('null-value item fires onTap but not onSelected', (
      tester,
    ) async {
      final calls = <String>[];
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: [
              CarbonMenuItem(label: 'Action', onTap: () => calls.add('onTap')),
            ],
            onSelected: (value) => calls.add('onSelected'),
            onClose: () => calls.add('onClose'),
          ),
        ),
      );

      await tester.tap(find.text('Action'));
      expect(calls, ['onTap', 'onClose']);
    });

    testWidgets('disabled item is inert', (tester) async {
      final calls = <String>[];
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: [
              CarbonMenuItem(
                label: 'Off',
                value: 'off',
                disabled: true,
                onTap: () => calls.add('onTap'),
              ),
            ],
            onSelected: (value) => calls.add('onSelected'),
            onClose: () => calls.add('onClose'),
          ),
        ),
      );

      await tester.tap(find.text('Off'));
      expect(calls, isEmpty);
    });

    testWidgets('Escape closes', (tester) async {
      var closed = 0;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: const [CarbonMenuItem(label: 'Edit', value: 'e')],
            onClose: () => closed++,
          ),
        ),
      );
      await tester.pump(); // autofocus

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(closed, 1);
    });

    testWidgets('arrow keys skip disabled items; Enter activates', (
      tester,
    ) async {
      String? selected;
      var closed = 0;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: const [
              CarbonMenuItem(label: 'One', value: 'one'),
              CarbonMenuItem(label: 'Two', value: 'two', disabled: true),
              CarbonMenuItem(label: 'Three', value: 'three'),
            ],
            onSelected: (value) => selected = value,
            onClose: () => closed++,
          ),
        ),
      );
      await tester.pump(); // autofocus

      // Down twice: One → (skip disabled Two) → Three.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(selected, 'three');
      expect(closed, 1);
    });

    testWidgets('selectedValue renders checkmark and selected background', (
      tester,
    ) async {
      final carbon = WhiteTheme.theme;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: const [
              CarbonMenuItem(label: 'One', value: 'one'),
              CarbonMenuItem(label: 'Two', value: 'two'),
            ],
            selectedValue: 'two',
            onClose: () {},
          ),
        ),
      );

      expect(find.byIcon(CarbonIcons.checkmark), findsOneWidget);
      final container = tester.widget<AnimatedContainer>(
        find.ancestor(
          of: find.text('Two'),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect(
        (container.decoration! as BoxDecoration).color,
        carbon.layer.layerSelected01,
      );
    });

    testWidgets('keyboard highlight starts on the selected item', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: const [
              CarbonMenuItem(label: 'One', value: 'one'),
              CarbonMenuItem(label: 'Two', value: 'two'),
              CarbonMenuItem(label: 'Three', value: 'three'),
            ],
            selectedValue: 'two',
            onSelected: (value) => selected = value,
            onClose: () {},
          ),
        ),
      );
      await tester.pump(); // focus capture

      // ArrowDown continues from the selection (Two → Three).
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(selected, 'three');
    });

    testWidgets('maxHeight constrains and scrolls the panel', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<int>(
            entries: [
              for (var i = 0; i < 30; i++)
                CarbonMenuItem(label: 'Item $i', value: i),
            ],
            maxHeight: 200,
            onClose: () {},
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(CarbonMenuPanel<int>)).height,
        lessThanOrEqualTo(200),
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // End jumps to the last item and keeps it in view.
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(
        tester.getRect(find.text('Item 29')).bottom,
        lessThanOrEqualTo(
          tester.getRect(find.byType(CarbonMenuPanel<int>)).bottom,
        ),
      );
    });

    testWidgets('Home/End jump to first/last enabled item', (tester) async {
      String? selected;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMenuPanel<String>(
            entries: const [
              CarbonMenuItem(label: 'One', value: 'one'),
              CarbonMenuItem(label: 'Two', value: 'two'),
              CarbonMenuItem(label: 'Three', value: 'three', disabled: true),
            ],
            onSelected: (value) => selected = value,
            onClose: () {},
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      // Last ENABLED item is Two (Three is disabled).
      expect(selected, 'two');
    });
  });
}
