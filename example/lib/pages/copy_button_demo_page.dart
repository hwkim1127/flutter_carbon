import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonCopyButton component.
class CopyButtonDemoPage extends StatefulWidget {
  const CopyButtonDemoPage({super.key});

  @override
  State<CopyButtonDemoPage> createState() => _CopyButtonDemoPageState();
}

class _CopyButtonDemoPageState extends State<CopyButtonDemoPage> {
  int _copyCount = 0;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Copy Button',
      description: 'Button that copies text to clipboard with visual feedback.',
      sections: [
        DemoSection(
          title: 'Basic Copy Button',
          description: 'Simple copy button with default labels',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonCopyButton(
                textToCopy: 'pnpm add @carbon/web-components @carbon/styles',
                onCopied: () {
                  setState(() => _copyCount++);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Times copied: $_copyCount',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Custom Feedback',
          description: 'Copy button with custom tooltip texts',
          builder: (context) => CarbonCopyButton(
            textToCopy: 'flutter pub add flutter_carbon',
            iconDescription: 'Copy command',
            feedback: 'Command copied!',
            onCopied: () {},
          ),
        ),
        DemoSection(
          title: 'Sizes',
          description: 'Small (32), medium (40, default), and large (48)',
          builder: (context) => Row(
            children: [
              CarbonCopyButton(
                textToCopy: 'small',
                size: CarbonCopyButtonSize.sm,
                onCopied: () {},
              ),
              const SizedBox(width: 8),
              CarbonCopyButton(
                textToCopy: 'medium',
                onCopied: () {},
              ),
              const SizedBox(width: 8),
              CarbonCopyButton(
                textToCopy: 'large',
                size: CarbonCopyButtonSize.lg,
                onCopied: () {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Custom Feedback Duration',
          description: 'Feedback tooltip stays for 5 seconds',
          builder: (context) => CarbonCopyButton(
            textToCopy: 'Example text',
            feedbackTimeout: const Duration(seconds: 5),
            onCopied: () {},
          ),
        ),
        DemoSection(
          title: 'Disabled State',
          description: 'Copy button when disabled',
          builder: (context) => const CarbonCopyButton(
            textToCopy: 'This cannot be copied',
            enabled: false,
          ),
        ),
        DemoSection(
          title: 'With Code Snippet',
          description: 'Copy button paired with code display',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.carbon.layer.layer02,
                  border: Border.all(
                    color: context.carbon.layer.borderSubtle01,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Installation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.carbon.text.textPrimary,
                          ),
                        ),
                        CarbonCopyButton(
                          textToCopy:
                              'pnpm add @carbon/web-components @carbon/styles',
                          onCopied: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'pnpm add @carbon/web-components @carbon/styles',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: context.carbon.text.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Multiple Copy Buttons',
          description: 'Different content to copy',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CopyItem(
                label: 'API Key',
                value: 'this_is_api_key',
              ),
              const SizedBox(height: 12),
              _CopyItem(
                label: 'Secret Token',
                value: 'this_is_secret_token',
              ),
              const SizedBox(height: 12),
              _CopyItem(
                label: 'Webhook URL',
                value: 'https://api.example.com/webhooks/abc123',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Common Use Cases',
          description: 'Typical copy button scenarios',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.carbon.layer.layer02,
                  border: Border.all(
                    color: context.carbon.layer.borderSubtle01,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repository URL',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.carbon.text.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'https://github.com/hwkim1127/flutter_carbon.git',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: context.carbon.text.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        CarbonCopyButton(
                          textToCopy:
                              'https://github.com/hwkim1127/flutter_carbon.git',
                          iconDescription: 'Copy clone URL',
                          onCopied: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.carbon.layer.layer02,
                  border: Border.all(
                    color: context.carbon.layer.borderSubtle01,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share Link',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.carbon.text.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'https://example.com/share/abc123',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.carbon.text.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        CarbonCopyButton(
                          textToCopy: 'https://example.com/share/abc123',
                          iconDescription: 'Copy link',
                          onCopied: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CopyItem extends StatelessWidget {
  final String label;
  final String value;

  const _CopyItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.carbon.layer.layer02,
        border: Border.all(color: context.carbon.layer.borderSubtle01),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: context.carbon.text.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CarbonCopyButton(textToCopy: value, onCopied: () {}),
        ],
      ),
    );
  }
}
