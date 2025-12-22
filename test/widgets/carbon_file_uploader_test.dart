import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonFileUploader', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFileUploader(
            labelTitle: 'Upload files',
            items: const [],
            child: CarbonFileUploaderButton(
              onPressed: () {},
              child: const Text('Add files'),
            ),
          ),
        ),
      );

      expect(find.byType(CarbonFileUploader), findsOneWidget);
      expect(find.text('Upload files'), findsOneWidget);
    });

    testWidgets('displays label description', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFileUploader(
            labelTitle: 'Upload',
            labelDescription: 'Max size 500mb',
            items: const [],
            child: CarbonFileUploaderButton(
              onPressed: () {},
              child: const Text('Add'),
            ),
          ),
        ),
      );

      expect(find.text('Max size 500mb'), findsOneWidget);
    });

    testWidgets('displays file items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFileUploader(
            labelTitle: 'Files',
            items: [
              CarbonFileUploaderItem(
                filename: 'document.pdf',
                state: CarbonFileUploaderItemState.complete,
                onDelete: () {},
              ),
              CarbonFileUploaderItem(
                filename: 'image.png',
                state: CarbonFileUploaderItemState.uploading,
                onDelete: () {},
              ),
            ],
            child: CarbonFileUploaderButton(
              onPressed: () {},
              child: const Text('Add'),
            ),
          ),
        ),
      );

      expect(find.text('document.pdf'), findsOneWidget);
      expect(find.text('image.png'), findsOneWidget);
    });

    testWidgets('shows upload button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFileUploader(
            labelTitle: 'Upload',
            items: const [],
            child: CarbonFileUploaderButton(
              onPressed: () {},
              child: const Text('Select files'),
            ),
          ),
        ),
      );

      expect(find.text('Select files'), findsOneWidget);
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
              body: CarbonFileUploader(
                labelTitle: 'Test',
                items: const [],
                child: CarbonFileUploaderButton(
                  onPressed: () {},
                  child: const Text('Add'),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(CarbonFileUploader), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });
}
