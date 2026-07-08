import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

var dependentBuildCount = 0;

class _CarbonDependent extends StatelessWidget {
  const _CarbonDependent();

  @override
  Widget build(BuildContext context) {
    context.carbon;
    dependentBuildCount++;
    return const SizedBox();
  }
}

void main() {
  group('CarbonTheme', () {
    testWidgets('of/maybeOf resolve the installed data', (tester) async {
      CarbonThemeData? viaOf;
      CarbonThemeData? viaMaybeOf;

      await tester.pumpWidget(
        CarbonTheme(
          data: G100Theme.theme,
          child: Builder(
            builder: (context) {
              viaOf = CarbonTheme.of(context);
              viaMaybeOf = CarbonTheme.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(viaOf, same(G100Theme.theme));
      expect(viaMaybeOf, same(G100Theme.theme));
    });

    testWidgets('of throws a FlutterError mentioning the fixes', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              expect(CarbonTheme.maybeOf(context), isNull);
              expect(
                () => CarbonTheme.of(context),
                throwsA(
                  isA<FlutterError>().having(
                    (e) => e.toString(),
                    'message',
                    allOf(
                      contains('CarbonApp'),
                      contains('CarbonMaterialBridge'),
                    ),
                  ),
                ),
              );
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('dependents rebuild when data changes, not when identical', (
      tester,
    ) async {
      dependentBuildCount = 0;

      // The dependent is const so it only rebuilds when the inherited
      // CarbonTheme notifies.
      Widget app(CarbonThemeData data) =>
          CarbonTheme(data: data, child: const _CarbonDependent());

      await tester.pumpWidget(app(WhiteTheme.theme));
      expect(dependentBuildCount, 1);

      // Same const instance — no notification.
      await tester.pumpWidget(app(WhiteTheme.theme));
      expect(dependentBuildCount, 1);

      // Different theme — dependents rebuild.
      await tester.pumpWidget(app(G100Theme.theme));
      expect(dependentBuildCount, 2);
    });

    testWidgets('installs DefaultTextStyle and IconTheme', (tester) async {
      late TextStyle textStyle;
      late IconThemeData iconTheme;

      await tester.pumpWidget(
        CarbonTheme(
          data: G100Theme.theme,
          child: Builder(
            builder: (context) {
              textStyle = DefaultTextStyle.of(context).style;
              iconTheme = IconTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(textStyle.color, G100Theme.theme.text.textPrimary);
      expect(iconTheme.color, G100Theme.theme.text.textPrimary);
    });
  });

  group('AnimatedCarbonTheme', () {
    testWidgets('interpolates between themes', (tester) async {
      CarbonThemeData read(BuildContext context) => context.carbon;

      late CarbonThemeData current;
      Widget app(CarbonThemeData data) => AnimatedCarbonTheme(
            data: data,
            duration: const Duration(milliseconds: 200),
            child: Builder(
              builder: (context) {
                current = read(context);
                return const SizedBox();
              },
            ),
          );

      await tester.pumpWidget(app(WhiteTheme.theme));
      final start = current.layer.background;

      await tester.pumpWidget(app(G100Theme.theme));
      await tester.pump(const Duration(milliseconds: 100));
      final mid = current.layer.background;

      await tester.pumpAndSettle();
      final end = current.layer.background;

      expect(start, WhiteTheme.theme.layer.background);
      expect(end, G100Theme.theme.layer.background);
      expect(mid, isNot(start));
      expect(mid, isNot(end));
    });
  });
}
