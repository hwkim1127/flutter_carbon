import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import 'package:flutter_carbon/src/base/carbon_scrollbar.dart';

void main() {
  final thumbColor = WhiteTheme.theme.layer.borderStrong01;

  /// Matches the painted thumb: a drawRect whose cross-axis extent is the
  /// 6px thickness, painted in the theme thumb color (ARGB compare - the
  /// painter's opacity math introduces float noise that defeats the exact
  /// color matcher). PaintPattern's static type is not Matcher; the
  /// object is - hence the cast.
  Matcher paintsThumb({bool horizontal = false}) => (paints
        ..something((method, args) {
          if (method != #drawRect) return false;
          final rect = args[0] as Rect;
          final paint = args[1] as Paint;
          final crossExtent = horizontal ? rect.height : rect.width;
          return crossExtent == 6 &&
              paint.color.toARGB32() == thumbColor.toARGB32();
        }))
      as Matcher;

  Widget app({
    required Widget child,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    return CarbonApp(
      theme: WhiteTheme.theme,
      home: Directionality(
        textDirection: textDirection,
        child: Center(
          child: SizedBox(width: 200, height: 200, child: child),
        ),
      ),
    );
  }

  Widget list({
    required int itemCount,
    ScrollController? controller,
    void Function(int index)? onTap,
  }) {
    return CarbonScrollbar(
      controller: controller,
      builder: (context, effective) => ListView(
        controller: effective,
        children: [
          for (var i = 0; i < itemCount; i++)
            GestureDetector(
              onTap: onTap == null ? null : () => onTap(i),
              child: SizedBox(height: 50, child: Text('item $i')),
            ),
        ],
      ),
    );
  }

  group('CarbonScrollbar', () {
    testWidgets('no thumb when the content fits', (tester) async {
      await tester.pumpWidget(app(child: list(itemCount: 2)));
      await tester.pumpAndSettle();

      expect(
        find.byType(RawScrollbar),
        isNot(paintsThumb()),
      );
    });

    testWidgets('thumb visible while the content overflows', (tester) async {
      await tester.pumpWidget(app(child: list(itemCount: 10)));
      await tester.pumpAndSettle(); // metrics microtask + fade-in

      expect(find.byType(RawScrollbar), paintsThumb());
    });

    testWidgets('thumb appears when content grows and hides when it shrinks',
        (tester) async {
      await tester.pumpWidget(app(child: list(itemCount: 2)));
      await tester.pumpAndSettle();
      expect(
        find.byType(RawScrollbar),
        isNot(paintsThumb()),
      );

      await tester.pumpWidget(app(child: list(itemCount: 10)));
      await tester.pumpAndSettle();
      expect(find.byType(RawScrollbar), paintsThumb());

      await tester.pumpWidget(app(child: list(itemCount: 2)));
      await tester.pumpAndSettle();
      expect(
        find.byType(RawScrollbar),
        isNot(paintsThumb()),
      );
    });

    testWidgets('thumb drag scrolls; content taps still land', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final taps = <int>[];

      await tester.pumpWidget(
        app(
          child: list(
            itemCount: 10,
            controller: controller,
            onTap: taps.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Drag the thumb (right edge of the 200x200 box, LTR).
      final box = tester.getRect(find.byType(RawScrollbar));
      await tester.dragFrom(
        Offset(box.right - 4, box.top + 10),
        const Offset(0, 60),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(0));

      // Content interaction passes through where there is no thumb
      // ('item 5' is on-screen after the drag; earlier items scrolled off).
      await tester.tap(find.text('item 5'));
      expect(taps, isNotEmpty);
    });

    testWidgets('suppresses the default desktop scrollbar (one bar only)', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      await tester.pumpWidget(app(child: list(itemCount: 10)));
      await tester.pumpAndSettle();

      expect(find.byType(RawScrollbar), findsOneWidget);

      // Must be reset inline — the binding checks foundation debug vars
      // before teardown callbacks run.
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('RTL places the vertical thumb on the left', (tester) async {
      await tester.pumpWidget(
        app(child: list(itemCount: 10), textDirection: TextDirection.rtl),
      );
      await tester.pumpAndSettle();

      final box = tester.getRect(find.byType(RawScrollbar));
      expect(
        find.byType(RawScrollbar),
        (paints
              ..something((method, args) {
                if (method != #drawRect) return false;
                final rect = args[0] as Rect;
                final paint = args[1] as Paint;
                // The THUMB (6px wide, thumb-colored — not the transparent
                // track), painted in the local space of the 200-wide box.
                return rect.width == 6 &&
                    paint.color.toARGB32() == thumbColor.toARGB32() &&
                    rect.left < box.width / 2;
              }))
            as Matcher,
      );
    });
  });
}
