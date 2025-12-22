import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
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
            code: '''import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  runApp(MyApp());
}''',
            type: CarbonCodeSnippetType.multi,
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
            feedbackMessage: 'Command copied!',
          ),
        ),
        DemoSection(
          title: 'Hide Copy Button',
          description: 'Code snippet without the copy button',
          builder: (context) => const CarbonCodeSnippet(
            code: 'flutter doctor',
            type: CarbonCodeSnippetType.single,
            showCopyButton: false,
          ),
        ),
        DemoSection(
          title: 'Long Code Example',
          description: 'Multi-line code with expand/collapse functionality',
          builder: (context) => const CarbonCodeSnippet(
            code: '''// Complete Flutter app example
import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

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
            maxCollapsedLines: 15,
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
      ],
    );
  }
}
