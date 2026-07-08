import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

void main() {
  group('CarbonMaterialBridge', () {
    testWidgets('resolves theme data installed by carbonTheme()', (
      tester,
    ) async {
      CarbonThemeData? data;

      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: G10Theme.theme),
          builder: (context, child) => CarbonMaterialBridge(child: child!),
          home: Builder(
            builder: (context) {
              data = context.carbon;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(data, same(G10Theme.theme));
    });

    testWidgets('switching MaterialApp.theme propagates to context.carbon', (
      tester,
    ) async {
      CarbonThemeData? data;

      Widget app(CarbonThemeData carbon) => MaterialApp(
            theme: carbonTheme(carbon: carbon),
            builder: (context, child) => CarbonMaterialBridge(child: child!),
            home: Builder(
              builder: (context) {
                data = context.carbon;
                return const SizedBox();
              },
            ),
          );

      await tester.pumpWidget(app(WhiteTheme.theme));
      expect(data!.layer.background, WhiteTheme.theme.layer.background);

      await tester.pumpWidget(app(G100Theme.theme));
      // MaterialApp animates theme changes; settle through the lerp.
      await tester.pumpAndSettle();
      expect(data!.layer.background, G100Theme.theme.layer.background);
    });

    testWidgets('explicit data overrides the ambient extension', (
      tester,
    ) async {
      CarbonThemeData? data;

      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          builder: (context, child) =>
              CarbonMaterialBridge(data: G90Theme.theme, child: child!),
          home: Builder(
            builder: (context) {
              data = context.carbon;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(data, same(G90Theme.theme));
    });

    testWidgets('throws a descriptive error without carbonTheme()', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => CarbonMaterialBridge(child: child!),
          home: const SizedBox(),
        ),
      );

      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (e) => e.toString(),
          'message',
          contains('carbonTheme'),
        ),
      );
    });
  });
}
