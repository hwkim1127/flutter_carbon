import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

const duration = Duration(milliseconds: 100);

void main() {
  group('CarbonCopyButton', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonCopyButton(textToCopy: 'Test text')),
      );
      expect(find.byType(CarbonCopyButton), findsOneWidget);
    });

    testWidgets('displays default label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonCopyButton(textToCopy: 'Test')),
      );
      expect(find.text('Copy'), findsOneWidget);
    });

    testWidgets('displays custom label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCopyButton(textToCopy: 'Test', label: 'Copy code'),
        ),
      );
      expect(find.text('Copy code'), findsOneWidget);
    });

    testWidgets('calls onCopied when button is tapped', (tester) async {
      bool copied = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCopyButton(
            textToCopy: 'Test',
            onCopied: () => copied = true,
            successDuration: duration,
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCopyButton));
      await tester.pumpAndSettle(duration);

      expect(copied, isTrue);
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCopyButton(textToCopy: 'Test', enabled: false),
        ),
      );

      final button = tester.widget<CarbonCopyButton>(
        find.byType(CarbonCopyButton),
      );
      expect(button.enabled, isFalse);
    });
  });
}
