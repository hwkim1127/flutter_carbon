import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonInlineNotification', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Test notification',
          ),
        ),
      );

      expect(find.byType(CarbonInlineNotification), findsOneWidget);
      expect(find.text('Test notification'), findsOneWidget);
    });

    testWidgets('displays title', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Information Title',
          ),
        ),
      );

      expect(find.text('Information Title'), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.success,
            title: 'Success',
            subtitle: 'Operation completed successfully',
          ),
        ),
      );

      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Operation completed successfully'), findsOneWidget);
    });

    testWidgets('shows close button by default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Test',
            onClose: () {},
          ),
        ),
      );

      expect(find.byType(CarbonInlineNotification), findsOneWidget);
    });

    testWidgets('hides close button when showCloseButton is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Test',
            showCloseButton: false,
          ),
        ),
      );

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('calls onClose when close button is tapped', (tester) async {
      bool closeCalled = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Test',
            onClose: () {
              closeCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(closeCalled, isTrue);
    });

    testWidgets('supports error kind', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.error,
            title: 'Error occurred',
          ),
        ),
      );

      final notification = tester.widget<CarbonInlineNotification>(
        find.byType(CarbonInlineNotification),
      );
      expect(notification.kind, CarbonNotificationKind.error);
    });

    testWidgets('supports success kind', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.success,
            title: 'Success',
          ),
        ),
      );

      final notification = tester.widget<CarbonInlineNotification>(
        find.byType(CarbonInlineNotification),
      );
      expect(notification.kind, CarbonNotificationKind.success);
    });

    testWidgets('supports warning kind', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.warning,
            title: 'Warning',
          ),
        ),
      );

      final notification = tester.widget<CarbonInlineNotification>(
        find.byType(CarbonInlineNotification),
      );
      expect(notification.kind, CarbonNotificationKind.warning);
    });

    testWidgets('supports info kind', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Information',
          ),
        ),
      );

      final notification = tester.widget<CarbonInlineNotification>(
        find.byType(CarbonInlineNotification),
      );
      expect(notification.kind, CarbonNotificationKind.info);
    });

    testWidgets('displays actions when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Test',
            actions: [
              TextButton(onPressed: () {}, child: const Text('Action 1')),
              TextButton(onPressed: () {}, child: const Text('Action 2')),
            ],
          ),
        ),
      );

      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
    });

    testWidgets('supports lowContrast variant', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Test',
            lowContrast: true,
          ),
        ),
      );

      final notification = tester.widget<CarbonInlineNotification>(
        find.byType(CarbonInlineNotification),
      );
      expect(notification.lowContrast, isTrue);
    });

    testWidgets('renders icon for each kind', (tester) async {
      for (final kind in CarbonNotificationKind.values) {
        await tester.pumpWidget(
          buildTestApp(
            child: CarbonInlineNotification(
              kind: kind,
              title: 'Test ${kind.name}',
            ),
          ),
        );

        expect(find.byType(Icon), findsOneWidget);
        await tester.pumpWidget(Container());
      }
    });
  });

  group('CarbonNotificationKind', () {
    test('has all severity levels', () {
      expect(CarbonNotificationKind.values.length, 4);
      expect(
        CarbonNotificationKind.values,
        contains(CarbonNotificationKind.error),
      );
      expect(
        CarbonNotificationKind.values,
        contains(CarbonNotificationKind.success),
      );
      expect(
        CarbonNotificationKind.values,
        contains(CarbonNotificationKind.warning),
      );
      expect(
        CarbonNotificationKind.values,
        contains(CarbonNotificationKind.info),
      );
    });
  });
}
