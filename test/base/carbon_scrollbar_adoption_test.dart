import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

/// One light presence test per CarbonScrollbar adopter: with overflowing
/// content the wired RawScrollbar exists in the (menu) tree and no
/// controller-attachment assert fires. Deep gating/paint behavior is
/// covered by test/base/carbon_scrollbar_test.dart.
void main() {
  group('CarbonScrollbar adoption', () {
    testWidgets('dropdown menu', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDropdown<int>(
            label: 'Pick',
            items: [
              for (var i = 0; i < 30; i++)
                CarbonDropdownItem(value: i, child: Text('Option $i')),
            ],
            value: null,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CarbonDropdown<int>));
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multi-select menu', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<int>(
            label: 'Pick many',
            items: [
              for (var i = 0; i < 30; i++)
                CarbonMultiSelectItem(value: i, child: Text('Option $i')),
            ],
            values: const [],
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CarbonMultiSelect<int>));
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('combo box menu', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboBox<int>(
            value: null,
            items: [
              for (var i = 0; i < 30; i++)
                CarbonComboBoxItem(value: i, label: 'Option $i'),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CarbonComboBox<int>));
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('select menu (menu panel maxHeight)', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonSelect<int>(
            labelText: 'Pick',
            items: [
              for (var i = 0; i < 30; i++)
                CarbonSelectItem(value: i, label: 'Option $i'),
            ],
            value: null,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CarbonSelect<int>));
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('data table horizontal scroll (minWidth)', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDataTable(
            minWidth: 2000, // wider than the 800px test surface
            headers: const [
              CarbonDataTableHeader(key: 'a', label: 'A'),
              CarbonDataTableHeader(key: 'b', label: 'B'),
            ],
            rows: const [
              CarbonDataTableRow(
                cells: [
                  CarbonDataTableCell(child: Text('1')),
                  CarbonDataTableCell(child: Text('2')),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tearsheet content', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => CarbonButton(
              child: const Text('Open'),
              onPressed: () => CarbonTearsheet.show(
                context: context,
                title: 'Long',
                builder: (context) => Column(
                  children: [
                    for (var i = 0; i < 60; i++)
                      SizedBox(height: 40, child: Text('row $i')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tree view (bounded parent)', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SizedBox(
            height: 150,
            child: CarbonTreeView(
              nodes: [
                for (var i = 0; i < 20; i++) CarbonTreeNode(label: 'Node $i'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('UI shell side nav', (tester) async {
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonUIShell(
            appName: 'Test',
            collapseMode: CarbonSideNavCollapseMode.fixed,
            sideNavItems: [
              for (var i = 0; i < 30; i++)
                CarbonNavItem(label: 'Item $i', onTap: () {}),
            ],
            child: const SizedBox(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
