import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  final List<MethodCall> platformLog = [];

  setUp(() {
    platformLog.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      platformLog.add(call);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  List<String> copiedTexts() => platformLog
      .where((call) => call.method == 'Clipboard.setData')
      .map((call) => (call.arguments as Map)['text'] as String)
      .toList();

  group('CarbonCopyButton', () {
    testWidgets('renders as an icon-only square (md 40×40 default)', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonCopyButton(textToCopy: 'Test text')),
      );
      expect(
        tester.getSize(find.byType(CarbonCopyButton)),
        const Size(40, 40),
      );
    });

    testWidgets('sizes: sm 32, lg 48', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCopyButton(
            textToCopy: 'x',
            size: CarbonCopyButtonSize.sm,
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(CarbonCopyButton)),
        const Size(32, 32),
      );

      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCopyButton(
            textToCopy: 'x',
            size: CarbonCopyButtonSize.lg,
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(CarbonCopyButton)),
        const Size(48, 48),
      );
    });

    testWidgets('copies, fires onCopied, and shows timed feedback', (
      tester,
    ) async {
      var copied = false;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCopyButton(
            textToCopy: 'Test',
            onCopied: () => copied = true,
            feedbackTimeout: const Duration(milliseconds: 150),
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCopyButton));
      await tester.pump(); // post-frame overlay insert
      await tester.pump(const Duration(milliseconds: 120)); // fade in

      expect(copied, isTrue);
      expect(copiedTexts(), ['Test']);
      expect(find.text('Copied!'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('Copied!'), findsNothing);
    });

    testWidgets('custom feedback message', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCopyButton(
            textToCopy: 'Test',
            feedback: 'In der Zwischenablage!',
            feedbackTimeout: Duration(milliseconds: 100),
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCopyButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      expect(find.text('In der Zwischenablage!'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
    });

    testWidgets('exposes iconDescription as the semantics label', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestApp(child: const CarbonCopyButton(textToCopy: 'Test')),
      );
      expect(find.bySemanticsLabel('Copy to clipboard'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('disabled button does not copy', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCopyButton(textToCopy: 'Test', enabled: false),
        ),
      );

      await tester.tap(find.byType(CarbonCopyButton), warnIfMissed: false);
      await tester.pump();
      expect(copiedTexts(), isEmpty);
      expect(find.text('Copied!'), findsNothing);
    });
  });
}
