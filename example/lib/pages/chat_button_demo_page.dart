import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonChatButton component.
class ChatButtonDemoPage extends StatefulWidget {
  const ChatButtonDemoPage({super.key});

  @override
  State<ChatButtonDemoPage> createState() => _ChatButtonDemoPageState();
}

class _ChatButtonDemoPageState extends State<ChatButtonDemoPage> {
  int _selectedQuickAction = 0;
  String _lastAction = 'None';

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Chat Button',
      description:
          'Specialized button component for chat interfaces with quick action support.',
      sections: [
        DemoSection(
          title: 'Button Kinds',
          description:
              'Primary, secondary, tertiary, ghost, and danger variants',
          builder: (context) => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CarbonChatButton(
                kind: CarbonChatButtonKind.primary,
                onPressed: () {},
                child: const Text('Primary'),
              ),
              CarbonChatButton(
                kind: CarbonChatButtonKind.secondary,
                onPressed: () {},
                child: const Text('Secondary'),
              ),
              CarbonChatButton(
                kind: CarbonChatButtonKind.tertiary,
                onPressed: () {},
                child: const Text('Tertiary'),
              ),
              CarbonChatButton(
                kind: CarbonChatButtonKind.ghost,
                onPressed: () {},
                child: const Text('Ghost'),
              ),
              CarbonChatButton(
                kind: CarbonChatButtonKind.danger,
                onPressed: () {},
                child: const Text('Danger'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Button Sizes',
          description: 'Small, medium, and large sizes',
          builder: (context) => Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CarbonChatButton(
                size: CarbonChatButtonSize.sm,
                onPressed: () {},
                child: const Text('Small'),
              ),
              CarbonChatButton(
                size: CarbonChatButtonSize.md,
                onPressed: () {},
                child: const Text('Medium'),
              ),
              CarbonChatButton(
                size: CarbonChatButtonSize.lg,
                onPressed: () {},
                child: const Text('Large'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With Icons',
          description: 'Buttons with leading icons',
          builder: (context) => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CarbonChatButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
                child: const Text('Send'),
              ),
              CarbonChatButton(
                icon: const Icon(Icons.attach_file),
                kind: CarbonChatButtonKind.secondary,
                onPressed: () {},
                child: const Text('Attach'),
              ),
              CarbonChatButton(
                icon: const Icon(Icons.mic),
                kind: CarbonChatButtonKind.tertiary,
                size: CarbonChatButtonSize.md,
                onPressed: () {},
                child: const Text('Record'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Quick Actions',
          description: 'Small ghost buttons for quick actions',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  CarbonChatButton(
                    isQuickAction: true,
                    isSelected: _selectedQuickAction == 0,
                    onPressed: () {
                      setState(() => _selectedQuickAction = 0);
                    },
                    child: const Text('Summarize'),
                  ),
                  CarbonChatButton(
                    isQuickAction: true,
                    isSelected: _selectedQuickAction == 1,
                    onPressed: () {
                      setState(() => _selectedQuickAction = 1);
                    },
                    child: const Text('Translate'),
                  ),
                  CarbonChatButton(
                    isQuickAction: true,
                    isSelected: _selectedQuickAction == 2,
                    onPressed: () {
                      setState(() => _selectedQuickAction = 2);
                    },
                    child: const Text('Simplify'),
                  ),
                  CarbonChatButton(
                    isQuickAction: true,
                    isSelected: _selectedQuickAction == 3,
                    onPressed: () {
                      setState(() => _selectedQuickAction == 3);
                    },
                    child: const Text('Expand'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Selected: $_selectedQuickAction',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled State',
          description: 'Buttons when disabled',
          builder: (context) => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              CarbonChatButton(disabled: true, child: Text('Disabled Primary')),
              CarbonChatButton(
                kind: CarbonChatButtonKind.secondary,
                disabled: true,
                child: Text('Disabled Secondary'),
              ),
              CarbonChatButton(
                kind: CarbonChatButtonKind.tertiary,
                disabled: true,
                child: Text('Disabled Tertiary'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Chat Interface Example',
          description: 'Buttons in a chat UI context',
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.carbon.layer.layer02,
              border: Border.all(color: context.carbon.layer.borderSubtle01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat Message Actions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.carbon.text.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.carbon.layer.layer01,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Can you help me with this code?',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.carbon.text.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          CarbonChatButton(
                            isQuickAction: true,
                            icon: const Icon(Icons.code, size: 14),
                            onPressed: () {
                              setState(() => _lastAction = 'Review code');
                            },
                            child: const Text('Review code'),
                          ),
                          CarbonChatButton(
                            isQuickAction: true,
                            icon: const Icon(Icons.bug_report, size: 14),
                            onPressed: () {
                              setState(() => _lastAction = 'Find bugs');
                            },
                            child: const Text('Find bugs'),
                          ),
                          CarbonChatButton(
                            isQuickAction: true,
                            icon: const Icon(Icons.lightbulb, size: 14),
                            onPressed: () {
                              setState(
                                () => _lastAction = 'Suggest improvements',
                              );
                            },
                            child: const Text('Suggest improvements'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Last action: $_lastAction',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Message Input Example',
          description: 'Chat buttons in a message composer',
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.carbon.layer.layer02,
              border: Border.all(color: context.carbon.layer.borderSubtle01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: CarbonInputDecorationHelper.filled(
                          context: context,
                          hintText: 'Type your message...',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        CarbonChatButton(
                          kind: CarbonChatButtonKind.ghost,
                          size: CarbonChatButtonSize.sm,
                          icon: const Icon(Icons.attach_file, size: 16),
                          onPressed: () {},
                          child: const Text(''),
                        ),
                        CarbonChatButton(
                          kind: CarbonChatButtonKind.ghost,
                          size: CarbonChatButtonSize.sm,
                          icon: const Icon(Icons.emoji_emotions, size: 16),
                          onPressed: () {},
                          child: const Text(''),
                        ),
                        CarbonChatButton(
                          kind: CarbonChatButtonKind.ghost,
                          size: CarbonChatButtonSize.sm,
                          icon: const Icon(Icons.mic, size: 16),
                          onPressed: () {},
                          child: const Text(''),
                        ),
                      ],
                    ),
                    CarbonChatButton(
                      kind: CarbonChatButtonKind.primary,
                      size: CarbonChatButtonSize.md,
                      icon: const Icon(Icons.send, size: 18),
                      onPressed: () {},
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
