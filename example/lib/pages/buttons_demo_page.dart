import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

class ButtonsDemoPage extends StatelessWidget {
  const ButtonsDemoPage({super.key});

  static Widget _buildButtonMapping(
    BuildContext context,
    String carbonType,
    String materialWidget,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: context.carbon.text.textPrimary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: context.carbon.text.textPrimary,
              ),
              children: [
                TextSpan(
                  text: '$carbonType: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: materialWidget,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: context.carbon.text.textSecondary,
                  ),
                ),
                TextSpan(
                  text: ' - $description',
                  style: TextStyle(
                    color: context.carbon.text.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Buttons',
      description:
          'Carbon Design System provides five button variants: primary, secondary, tertiary, ghost, and danger. '
          'These are styled using Material\'s FilledButton (primary), ElevatedButton (secondary), OutlinedButton (tertiary), and TextButton (ghost/danger).',
      sections: [
        DemoSection(
          title: 'Carbon Button Variants',
          description:
              'The five official Carbon button types with their styling applied to Material buttons',
          builder: null,
        ),
        DemoSection(
          title: 'Primary Buttons (FilledButton)',
          description:
              'Primary buttons are used for the main call-to-action. Styled using FilledButton with Carbon theme colors.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(onPressed: () {}, child: const Text('Primary')),
              FilledButton(onPressed: null, child: const Text('Disabled')),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('With Icon'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Secondary Buttons (ElevatedButton)',
          description:
              'Secondary buttons for supporting actions. Uses Material\'s ElevatedButton with Carbon theme styling.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Secondary')),
              ElevatedButton(onPressed: null, child: const Text('Disabled')),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('With Icon'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Tertiary Buttons (OutlinedButton)',
          description:
              'Tertiary buttons with outline style and transparent background.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Tertiary')),
              OutlinedButton(onPressed: null, child: const Text('Disabled')),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('With Icon'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Ghost Buttons (TextButton)',
          description:
              'Ghost buttons are transparent with minimal visual weight. Styled using TextButton.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(onPressed: () {}, child: const Text('Ghost')),
              TextButton(onPressed: null, child: const Text('Disabled')),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('With Icon'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Danger Buttons',
          description:
              'Danger buttons are used for destructive actions like delete. Available in primary, secondary, and ghost variants.',
          builder: (context) {
            final carbon = context.carbon;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: carbon.button.buttonDangerPrimary,
                    foregroundColor: carbon.text.textOnColor,
                  ),
                  child: const Text('Danger Primary'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: carbon.button.buttonDangerSecondary,
                    side: BorderSide(
                      color: carbon.button.buttonDangerSecondary,
                    ),
                  ),
                  child: const Text('Danger Secondary'),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: carbon.button.buttonDangerPrimary,
                  ),
                  child: const Text('Danger Ghost'),
                ),
              ],
            );
          },
        ),
        DemoSection(
          title: 'Button Sizes',
          description:
              'Carbon buttons come in three sizes: small (32px), medium (40px default), and large (48px).',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Small (32px)'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {},
                child: const Text('Medium (40px - Default)'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Large (48px)'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Button Styling Notes',
          description:
              'Understanding how Carbon button styles are applied to Material widgets',
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
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: context.carbon.text.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Carbon button mapping to Material widgets',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.carbon.text.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildButtonMapping(
                  context,
                  'Primary',
                  'FilledButton',
                  'Main call-to-action, solid background',
                ),
                const SizedBox(height: 8),
                _buildButtonMapping(
                  context,
                  'Secondary',
                  'ElevatedButton',
                  'Supporting actions, subtle elevation',
                ),
                const SizedBox(height: 8),
                _buildButtonMapping(
                  context,
                  'Tertiary',
                  'OutlinedButton',
                  'Less prominent actions, outlined style',
                ),
                const SizedBox(height: 8),
                _buildButtonMapping(
                  context,
                  'Ghost',
                  'TextButton',
                  'Minimal visual weight, transparent',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
