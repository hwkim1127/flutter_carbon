import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonStructuredList', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonStructuredList(
            headers: const [
              CarbonStructuredListHeader(label: 'Column 1'),
              CarbonStructuredListHeader(label: 'Column 2'),
            ],
            rows: const [
              CarbonStructuredListRow(
                cells: [
                  CarbonStructuredListCell(child: Text('Row 1 Col 1')),
                  CarbonStructuredListCell(child: Text('Row 1 Col 2')),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  CarbonStructuredListCell(child: Text('Row 2 Col 1')),
                  CarbonStructuredListCell(child: Text('Row 2 Col 2')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.byType(CarbonStructuredList), findsOneWidget);
    });

    testWidgets('displays headers', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonStructuredList(
            headers: const [
              CarbonStructuredListHeader(label: 'Name'),
              CarbonStructuredListHeader(label: 'Age'),
              CarbonStructuredListHeader(label: 'City'),
            ],
            rows: const [],
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('City'), findsOneWidget);
    });

    testWidgets('displays row data', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonStructuredList(
            headers: const [
              CarbonStructuredListHeader(label: 'A'),
              CarbonStructuredListHeader(label: 'B'),
            ],
            rows: const [
              CarbonStructuredListRow(
                cells: [
                  CarbonStructuredListCell(child: Text('Data 1')),
                  CarbonStructuredListCell(child: Text('Data 2')),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  CarbonStructuredListCell(child: Text('Data 3')),
                  CarbonStructuredListCell(child: Text('Data 4')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Data 1'), findsOneWidget);
      expect(find.text('Data 2'), findsOneWidget);
      expect(find.text('Data 3'), findsOneWidget);
      expect(find.text('Data 4'), findsOneWidget);
    });

    testWidgets('supports selectable rows', (tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return CarbonStructuredList(
                headers: const [CarbonStructuredListHeader(label: 'Column')],
                rows: const [
                  CarbonStructuredListRow(
                    cells: [CarbonStructuredListCell(child: Text('Row 1'))],
                  ),
                  CarbonStructuredListRow(
                    cells: [CarbonStructuredListCell(child: Text('Row 2'))],
                  ),
                ],
                selectable: true,
                selectedIndex: selectedIndex,
                onRowSelected: (index) => setState(() => selectedIndex = index),
              );
            },
          ),
        ),
      );

      expect(selectedIndex, isNull);

      await tester.tap(find.text('Row 1'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
    });

    testWidgets('works in all themes', (tester) async {
      for (final theme in [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: carbonTheme(carbon: theme),
            home: Scaffold(
              body: CarbonStructuredList(
                headers: const [CarbonStructuredListHeader(label: 'Test')],
                rows: const [
                  CarbonStructuredListRow(
                    cells: [CarbonStructuredListCell(child: Text('Data'))],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CarbonStructuredList), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });
}
