import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonModal.passive', () {
    testWidgets('shows passive modal', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.passive(
                  context,
                  title: 'Info',
                  content: const Text('Passive modal content'),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Info'), findsOneWidget);
      expect(find.text('Passive modal content'), findsOneWidget);
    });

    testWidgets('Escape dismisses a dismissible modal', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.passive(
                  context,
                  title: 'Info',
                  content: const Text('Passive modal content'),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();
      expect(find.text('Passive modal content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Passive modal content'), findsNothing);
    });

    testWidgets('Escape does NOT dismiss a non-dismissible modal', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.transactional(
                  context,
                  title: 'Decide',
                  content: const Text('Blocking question'),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();
      expect(find.text('Blocking question'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Blocking question'), findsOneWidget);
    });

    testWidgets('shows close button when enabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.passive(
                  context,
                  title: 'Info',
                  content: const Text('Content'),
                  showCloseButton: true,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byIcon(CarbonIcons.close), findsOneWidget);
    });

    testWidgets('dismisses when tapped outside if dismissible', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.passive(
                  context,
                  title: 'Dismissible',
                  content: const Text('Content'),
                  dismissible: true,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Dismissible'), findsOneWidget);

      // Tap outside modal
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Dismissible'), findsNothing);
    });
  });

  group('CarbonModal.transactional', () {
    testWidgets('shows transactional modal with buttons', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.transactional(
                  context,
                  title: 'Confirm',
                  content: const Text('Are you sure?'),
                  primaryButtonText: 'Yes',
                  secondaryButtonText: 'No',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('returns true when primary button pressed', (tester) async {
      bool? result;

      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await CarbonModal.transactional(
                  context,
                  content: const Text('Confirm?'),
                  primaryButtonText: 'Confirm',
                  secondaryButtonText: 'Cancel',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('returns false when secondary button pressed', (tester) async {
      bool? result;

      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await CarbonModal.transactional(
                  context,
                  content: const Text('Confirm?'),
                  primaryButtonText: 'Yes',
                  secondaryButtonText: 'No',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });
  });

  group('CarbonModal.danger', () {
    testWidgets('shows danger modal with a danger-kind primary button', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.danger(
                  context,
                  title: 'Delete item',
                  content: const Text('Cannot be undone'),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Delete item'), findsOneWidget);
      expect(find.text('Cannot be undone'), findsOneWidget);
      // Spec: danger modal = standard modal + danger-kind primary button.
      final primary = tester.widget<CarbonButton>(
        find.widgetWithText(CarbonButton, 'Delete'),
      );
      expect(primary.kind, CarbonButtonKind.danger);
    });

    testWidgets('footer buttons are 64px, equal width, flush bottom', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.danger(
                  context,
                  title: 'Delete item',
                  content: const Text('Cannot be undone'),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      final cancel = find.widgetWithText(CarbonButton, 'Cancel');
      final delete = find.widgetWithText(CarbonButton, 'Delete');
      expect(tester.getSize(cancel).height, 64);
      expect(tester.getSize(delete).height, 64);
      expect(tester.getSize(cancel).width, tester.getSize(delete).width);

      // Flush with the modal container bottom (inside its 1px border).
      final containerRect = tester.getRect(
        find
            .ancestor(
              of: find.text('Cannot be undone'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        tester.getRect(delete).bottom,
        closeTo(containerRect.bottom, 1.5),
      );
    });
  });

  group('CarbonModal.input', () {
    testWidgets('shows input modal with text field', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.input(
                  context,
                  title: 'Enter name',
                  hintText: 'Name',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Enter name'), findsOneWidget);
      expect(find.byType(CarbonTextInput), findsOneWidget);
    });

    testWidgets('returns entered text', (tester) async {
      String? result;

      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await CarbonModal.input(
                  context,
                  title: 'Name',
                  primaryButtonText: 'Submit',
                  secondaryButtonText: 'Cancel',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(CarbonTextInput), 'John Doe');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(result, 'John Doe');
    });
  });

  group('CarbonModal.custom', () {
    testWidgets('shows custom modal with content', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonModal.custom(
                  context,
                  content: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Custom content'),
                  ),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Custom content'), findsOneWidget);
    });
  });
}
