import 'package:flutter/material.dart';
import 'package:flutter_carbon/material.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonCodeSnippet component.
class CodeSnippetDemoPage extends StatefulWidget {
  const CodeSnippetDemoPage({super.key});

  @override
  State<CodeSnippetDemoPage> createState() => _CodeSnippetDemoPageState();
}

class _CodeSnippetDemoPageState extends State<CodeSnippetDemoPage> {
  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Code Snippet',
      description:
          'Code snippets are small blocks of reusable code that can be copied to the clipboard.',
      sections: [
        DemoSection(
          title: 'Single Line Code Snippet',
          description: 'Inline code snippet with copy functionality',
          builder: (context) => const CarbonCodeSnippet(
            code: 'npm install carbon-components',
            type: CarbonCodeSnippetType.single,
          ),
        ),
        DemoSection(
          title: 'Multi-line Code Snippet',
          description: 'Multiple lines of code with expandable view',
          builder: (context) => const CarbonCodeSnippet(
            code: '''import 'package:flutter_carbon/material.dart';

void main() {
  runApp(MyApp());
}''',
            type: CarbonCodeSnippetType.multi,
            highlighter: CarbonDartHighlighter(),
          ),
        ),
        DemoSection(
          title: 'Inline Code Snippet',
          description: 'Code snippet displayed inline with text',
          builder: (context) => Row(
            children: [
              const Text('Install the package using '),
              const CarbonCodeSnippet(
                code: 'flutter pub add flutter_carbon',
                type: CarbonCodeSnippetType.inline,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Code Snippet with Custom Feedback',
          description: 'Shows custom feedback message when copied',
          builder: (context) => const CarbonCodeSnippet(
            code: 'flutter run',
            type: CarbonCodeSnippetType.single,
            labels: CarbonCodeSnippetLabels(copied: 'Command copied!'),
          ),
        ),
        DemoSection(
          title: 'Hide Copy Button',
          description: 'Code snippet without the copy button',
          builder: (context) => const CarbonCodeSnippet(
            code: 'flutter doctor',
            type: CarbonCodeSnippetType.single,
            hideCopyButton: true,
          ),
        ),
        DemoSection(
          title: 'Long Code Example',
          description: 'Multi-line code with expand/collapse functionality',
          builder: (context) => const CarbonCodeSnippet(
            code: '''// Complete Flutter app example
import 'package:flutter/material.dart';
import 'package:flutter_carbon/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Theme Demo',
      theme: carbonTheme(carbon: WhiteTheme.theme),
      builder: (context, child) => CarbonMaterialBridge(child: child!),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: const Text('Hello Carbon!')),
    );
  }
}''',
            type: CarbonCodeSnippetType.multi,
            highlighter: CarbonDartHighlighter(),
          ),
        ),
        DemoSection(
          title: 'Long Single Line',
          description: 'Horizontally scrollable single line code',
          builder: (context) => const CarbonCodeSnippet(
            code:
                'flutter pub add flutter_carbon provider http dio shared_preferences cached_network_image',
            type: CarbonCodeSnippetType.single,
          ),
        ),
        DemoSection(
          title: 'Line Numbers',
          description: 'Multi-line snippet with a non-selectable gutter',
          builder: (context) => const CarbonCodeSnippet(
            code: '''void main() {
  final items = List.generate(3, (i) => 'item \$i');
  for (final item in items) {
    print(item);
  }
}''',
            type: CarbonCodeSnippetType.multi,
            showLineNumbers: true,
            highlighter: CarbonDartHighlighter(),
          ),
        ),
        DemoSection(
          title: 'Wrap Text',
          description:
              'Long lines soft-wrap instead of scrolling horizontally',
          builder: (context) => const CarbonCodeSnippet(
            code:
                'flutter pub add flutter_carbon provider http dio shared_preferences cached_network_image collection intl path url_launcher',
            type: CarbonCodeSnippetType.multi,
            wrapText: true,
          ),
        ),
        DemoSection(
          title: 'Custom Row Limits',
          description:
              'Collapsed at 5 rows; expanding is capped at 10 rows',
          builder: (context) => CarbonCodeSnippet(
            code: List.generate(20, (i) => 'line ${i + 1}').join('\n'),
            type: CarbonCodeSnippetType.multi,
            maxCollapsedNumberOfRows: 5,
            minCollapsedNumberOfRows: 3,
            maxExpandedNumberOfRows: 10,
            minExpandedNumberOfRows: 8,
          ),
        ),
        DemoSection(
          title: 'Disabled',
          description: 'Copy and expand are inert; text is dimmed',
          builder: (context) => CarbonCodeSnippet(
            code: List.generate(20, (i) => 'secret line ${i + 1}').join('\n'),
            type: CarbonCodeSnippetType.multi,
            disabled: true,
          ),
        ),
        DemoSection(
          title: 'Skeleton',
          description: 'Loading placeholders for single and multi',
          builder: (context) => const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CarbonCodeSnippetSkeleton(),
              SizedBox(height: 16),
              CarbonCodeSnippetSkeleton(type: CarbonCodeSnippetType.multi),
            ],
          ),
        ),
      ],
    );
  }
}
