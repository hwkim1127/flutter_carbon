import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

void main() {
  group('CarbonRadio', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonRadio<int>(
            value: 1,
            groupValue: null,
            onChanged: (_) {},
            label: 'Option one',
          ),
        ),
      );

      expect(find.byType(CarbonRadio<int>), findsOneWidget);
      expect(find.text('Option one'), findsOneWidget);
    });

    testWidgets('reports its value when tapped', (tester) async {
      int? selected;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonRadio<int>(
            value: 2,
            groupValue: 1,
            onChanged: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(find.byType(CarbonRadio<int>));
      expect(selected, 2);
    });

    testWidgets('groupValue drives the selected state', (tester) async {
      int group = 1;
      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                CarbonRadio<int>(
                  value: 1,
                  groupValue: group,
                  onChanged: (value) => setState(() => group = value!),
                  label: 'One',
                ),
                CarbonRadio<int>(
                  value: 2,
                  groupValue: group,
                  onChanged: (value) => setState(() => group = value!),
                  label: 'Two',
                ),
              ],
            ),
          ),
        ),
      );

      CarbonRadio<int> radioAt(String label) => tester.widget<CarbonRadio<int>>(
            find.ancestor(
              of: find.text(label),
              matching: find.byType(CarbonRadio<int>),
            ),
          );

      expect(radioAt('One').selected, isTrue);
      expect(radioAt('Two').selected, isFalse);

      await tester.tap(find.text('Two'));
      await tester.pump();

      expect(radioAt('One').selected, isFalse);
      expect(radioAt('Two').selected, isTrue);
    });

    testWidgets('disabled radio ignores taps', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonRadio<int>(
            value: 1,
            groupValue: null,
            onChanged: null,
            label: 'Disabled',
          ),
        ),
      );

      await tester.tap(find.byType(CarbonRadio<int>));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('works in all themes', (tester) async {
      for (final theme in [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ]) {
        await tester.pumpWidget(
          CarbonApp(
            theme: theme,
            home: Center(
              child: CarbonRadio<int>(
                value: 1,
                groupValue: 1,
                onChanged: (_) {},
                label: 'Themed',
              ),
            ),
          ),
        );
        expect(find.byType(CarbonRadio<int>), findsOneWidget);
      }
    });
  });
}
