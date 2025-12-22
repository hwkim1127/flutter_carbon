import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonAILabel component.
class AILabelDemoPage extends StatefulWidget {
  const AILabelDemoPage({super.key});

  @override
  State<AILabelDemoPage> createState() => _AILabelDemoPageState();
}

class _AILabelDemoPageState extends State<AILabelDemoPage> {
  bool _revertActive1 = false;
  bool _revertActive2 = false;
  int _clickCount = 0;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'AI Label',
      description:
          'AI indicator badge showing content is AI-generated with gradient styling.',
      sections: [
        DemoSection(
          title: 'Basic AI Label',
          description: 'Default AI badge',
          builder: (context) => CarbonAILabel(
            onTap: () {
              setState(() => _clickCount++);
            },
          ),
        ),
        DemoSection(
          title: 'Label Sizes',
          description: 'All available AI label sizes',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                children: [
                  const CarbonAILabel(size: CarbonAILabelSize.mini),
                  const SizedBox(height: 4),
                  Text(
                    'Mini (16px)',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.carbon.text.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const CarbonAILabel(size: CarbonAILabelSize.xs2),
                  const SizedBox(height: 4),
                  Text(
                    'XS2 (20px)',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.carbon.text.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const CarbonAILabel(size: CarbonAILabelSize.xs),
                  const SizedBox(height: 4),
                  Text(
                    'XS (24px)',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.carbon.text.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const CarbonAILabel(size: CarbonAILabelSize.sm),
                  const SizedBox(height: 4),
                  Text(
                    'SM (28px)',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.carbon.text.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const CarbonAILabel(size: CarbonAILabelSize.md),
                  const SizedBox(height: 4),
                  Text(
                    'MD (32px)',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.carbon.text.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const CarbonAILabel(size: CarbonAILabelSize.lg),
                  const SizedBox(height: 4),
                  Text(
                    'LG (36px)',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.carbon.text.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const CarbonAILabel(size: CarbonAILabelSize.xl),
                  const SizedBox(height: 4),
                  Text(
                    'XL (40px)',
                    style: TextStyle(
                      fontSize: 10,
                      color: context.carbon.text.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Inline Label',
          description: 'AI label with additional text',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              CarbonAILabel(
                kind: CarbonAILabelKind.inline,
                aiTextLabel: 'Generated',
                size: CarbonAILabelSize.sm,
              ),
              CarbonAILabel(
                kind: CarbonAILabelKind.inline,
                aiTextLabel: 'Suggested',
                size: CarbonAILabelSize.md,
              ),
              CarbonAILabel(
                kind: CarbonAILabelKind.inline,
                aiTextLabel: 'Content',
                size: CarbonAILabelSize.lg,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Interactive States',
          description: 'AI label with click interaction',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonAILabel(
                size: CarbonAILabelSize.md,
                onTap: () {
                  setState(() => _clickCount++);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Click count: $_clickCount',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Revert Button',
          description: 'AI label with revert functionality',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Revert state: ${_revertActive1 ? "Active" : "Inactive"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.carbon.text.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      setState(() => _revertActive1 = !_revertActive1);
                    },
                    child: Text(_revertActive1 ? 'Deactivate' : 'Activate'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CarbonAILabel(
                size: CarbonAILabelSize.md,
                revertActive: _revertActive1,
                onTap: () {},
                onRevert: () {
                  setState(() => _revertActive1 = false);
                },
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'In Context',
          description: 'AI label used with content',
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
                      children: [
                        Text(
                          'Generated Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.carbon.text.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const CarbonAILabel(size: CarbonAILabelSize.sm),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This summary was automatically generated by AI based on the provided content. '
                      'It highlights the key points and main takeaways from the document.',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.carbon.text.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With Revert Example',
          description: 'Complete AI content with revert option',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'AI Suggestion',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.carbon.text.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const CarbonAILabel(
                          kind: CarbonAILabelKind.inline,
                          aiTextLabel: 'Suggested',
                          size: CarbonAILabelSize.xs,
                        ),
                      ],
                    ),
                    CarbonAILabel(
                      size: CarbonAILabelSize.sm,
                      revertActive: _revertActive2,
                      onRevert: () {
                        setState(() => _revertActive2 = false);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'AI-generated content suggestion appears here...',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.carbon.text.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() => _revertActive2 = false);
                      },
                      child: const Text('Accept'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _revertActive2 = true);
                      },
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Different Contexts',
          description: 'AI labels in various UI scenarios',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('AI-generated title'),
                trailing: const CarbonAILabel(size: CarbonAILabelSize.xs),
                contentPadding: const EdgeInsets.all(12),
                tileColor: context.carbon.layer.layer02,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Smart suggestions'),
                subtitle: const Text('Powered by AI'),
                trailing: const CarbonAILabel(
                  kind: CarbonAILabelKind.inline,
                  aiTextLabel: 'Beta',
                  size: CarbonAILabelSize.xs,
                ),
                contentPadding: const EdgeInsets.all(12),
                tileColor: context.carbon.layer.layer02,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
