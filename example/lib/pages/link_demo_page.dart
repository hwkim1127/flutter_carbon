import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonLink component.
class LinkDemoPage extends StatefulWidget {
  const LinkDemoPage({super.key});

  @override
  State<LinkDemoPage> createState() => _LinkDemoPageState();
}

class _LinkDemoPageState extends State<LinkDemoPage> {
  String _lastClicked = 'None';
  final Set<int> _visitedLinks = {};

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Link',
      description: 'Styled hyperlinks that follow Carbon design patterns.',
      sections: [
        DemoSection(
          title: 'Basic Link',
          description: 'Simple link with default styling',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonLink(
                text: 'Learn more',
                onTap: () {
                  setState(() => _lastClicked = 'Learn more');
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Last clicked: $_lastClicked',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Link Sizes',
          description: 'Small, medium, and large link sizes',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonLink(
                text: 'Small link (12px)',
                size: CarbonLinkSize.small,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              CarbonLink(
                text: 'Medium link (14px)',
                size: CarbonLinkSize.medium,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              CarbonLink(
                text: 'Large link (16px)',
                size: CarbonLinkSize.large,
                onTap: () {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Link with Icon',
          description: 'Links with inline icons',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonLink(
                text: 'External link',
                icon: const Icon(Icons.open_in_new, size: 16),
                onTap: () {},
              ),
              const SizedBox(height: 12),
              CarbonLink(
                text: 'Download file',
                icon: const Icon(Icons.download, size: 16),
                onTap: () {},
              ),
              const SizedBox(height: 12),
              CarbonLink(
                text: 'Share',
                icon: const Icon(Icons.share, size: 16),
                size: CarbonLinkSize.large,
                onTap: () {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Visited State',
          description: 'Links with visited state',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonLink(
                text: 'Unvisited link',
                visited: _visitedLinks.contains(0),
                onTap: () {
                  setState(() => _visitedLinks.add(0));
                },
              ),
              const SizedBox(height: 12),
              CarbonLink(
                text: 'Click to mark as visited',
                visited: _visitedLinks.contains(1),
                onTap: () {
                  setState(() => _visitedLinks.add(1));
                },
              ),
              const SizedBox(height: 12),
              const CarbonLink(text: 'Already visited', visited: true),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled State',
          description: 'Links when disabled',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarbonLink(
                text: 'Disabled link',
                disabled: true,
                onTap: null,
              ),
              const SizedBox(height: 12),
              const CarbonLink(
                text: 'Disabled with icon',
                disabled: true,
                icon: Icon(Icons.lock, size: 16),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Inline Links',
          description: 'Links within text content',
          builder: (context) => Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: context.carbon.text.textPrimary,
              ),
              children: [
                const TextSpan(text: 'For more information, please visit our '),
                WidgetSpan(
                  child: CarbonLink(text: 'documentation', onTap: () {}),
                ),
                const TextSpan(text: ' or '),
                WidgetSpan(
                  child: CarbonLink(text: 'contact support', onTap: () {}),
                ),
                const TextSpan(text: ' for assistance.'),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Common Use Cases',
          description: 'Examples of typical link usage',
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
                      'Navigation Links',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.carbon.text.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CarbonLink(text: 'Home', onTap: () {}),
                    const SizedBox(height: 8),
                    CarbonLink(text: 'Products', onTap: () {}),
                    const SizedBox(height: 8),
                    CarbonLink(text: 'About Us', onTap: () {}),
                    const SizedBox(height: 8),
                    CarbonLink(text: 'Contact', onTap: () {}),
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
                      'Action Links',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.carbon.text.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CarbonLink(
                      text: 'View details',
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    CarbonLink(
                      text: 'Download report',
                      icon: const Icon(Icons.download, size: 16),
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    CarbonLink(
                      text: 'Open in new tab',
                      icon: const Icon(Icons.open_in_new, size: 16),
                      onTap: () {},
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
