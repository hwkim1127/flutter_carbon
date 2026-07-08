import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('CarbonApp', () {
    testWidgets('provides context.carbon without any Material', (
      tester,
    ) async {
      CarbonThemeData? data;

      await tester.pumpWidget(
        CarbonApp(
          theme: G90Theme.theme,
          home: Builder(
            builder: (context) {
              data = context.carbon;
              return const Text('home');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(data, same(G90Theme.theme));
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('pure-Carbon widgets render', (tester) async {
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: Center(
            child: CarbonButton(onPressed: () {}, child: const Text('Save')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('named routes navigate with CarbonPageRoute', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          navigatorKey: navigatorKey,
          routes: {
            '/': (context) => const Text('first'),
            '/second': (context) => const Text('second'),
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('first'), findsOneWidget);

      navigatorKey.currentState!.pushNamed('/second');
      await tester.pumpAndSettle();

      expect(find.text('second'), findsOneWidget);
    });

    testWidgets('CarbonPageRoute can be pushed directly', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          navigatorKey: navigatorKey,
          home: const Text('home'),
        ),
      );
      await tester.pumpAndSettle();

      navigatorKey.currentState!.push(
        CarbonPageRoute<void>(builder: (context) => const Text('pushed')),
      );
      await tester.pumpAndSettle();

      expect(find.text('pushed'), findsOneWidget);
    });

    testWidgets('overlay-based CarbonDropdown works without Material', (
      tester,
    ) async {
      String? selected;

      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: Center(
            child: CarbonDropdown<String>(
              label: 'Pick',
              items: const [
                CarbonDropdownItem(value: 'a', child: Text('Alpha')),
                CarbonDropdownItem(value: 'b', child: Text('Beta')),
              ],
              value: selected,
              onChanged: (v) => selected = v,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CarbonDropdown<String>));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(selected, 'a');
    });
  });
}
