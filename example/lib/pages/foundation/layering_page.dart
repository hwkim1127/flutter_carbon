import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../../widgets/demo_page_template.dart';

/// Demo page for Carbon layer tokens.
class LayeringPage extends StatelessWidget {
  const LayeringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return DemoPageTemplate(
      title: 'Layering',
      description:
          'Carbon uses layer tokens to create depth and hierarchy through background colors.',
      sections: [
        DemoSection(
          title: 'Background Layers',
          description: 'Layer tokens from base to elevated',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LayerDemo(
                'Layer 01 (Base)',
                'The first layer is the background level, the foundation of the UI.',
                carbon.layer.layer01,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer 02',
                'The second layer is the first level of elevation.',
                carbon.layer.layer02,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer 03',
                'The third layer is the second level of elevation.',
                carbon.layer.layer03,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Interactive Layers',
          description: 'Layer states for interactive elements',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LayerDemo(
                'Layer Hover 01',
                'Hover state for layer 01 elements.',
                carbon.layer.layerHover01,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Hover 02',
                'Hover state for layer 02 elements.',
                carbon.layer.layerHover02,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Hover 03',
                'Hover state for layer 03 elements.',
                carbon.layer.layerHover03,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Active 01',
                'Active/pressed state for layer 01 elements.',
                carbon.layer.layerActive01,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Active 02',
                'Active/pressed state for layer 02 elements.',
                carbon.layer.layerActive02,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Active 03',
                'Active/pressed state for layer 03 elements.',
                carbon.layer.layerActive03,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Selection Layers',
          description: 'Layers for selected and disabled states',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LayerDemo(
                'Layer Selected 01',
                'Selected state for layer 01 elements.',
                carbon.layer.layerSelected01,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Selected 02',
                'Selected state for layer 02 elements.',
                carbon.layer.layerSelected02,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Selected 03',
                'Selected state for layer 03 elements.',
                carbon.layer.layerSelected03,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Selected Disabled',
                'Disabled state for selected elements.',
                carbon.layer.layerSelectedDisabled,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Specialty Layers',
          description: 'Special purpose layer tokens',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LayerDemo(
                'Layer Accent 01',
                'First accent layer for highlighting.',
                carbon.layer.layerAccent01,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Accent 02',
                'Second accent layer for highlighting.',
                carbon.layer.layerAccent02,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Layer Accent 03',
                'Third accent layer for highlighting.',
                carbon.layer.layerAccent03,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Field 01',
                'Input field background on layer 01.',
                carbon.layer.field01,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Field 02',
                'Input field background on layer 02.',
                carbon.layer.field02,
                carbon,
              ),
              const SizedBox(height: 16),
              _LayerDemo(
                'Field 03',
                'Input field background on layer 03.',
                carbon.layer.field03,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Borders',
          description: 'Border colors at different strengths',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BorderDemo(
                'Border Subtle 00',
                'Subtlest border, barely visible.',
                carbon.layer.borderSubtle00,
                carbon,
              ),
              const SizedBox(height: 16),
              _BorderDemo(
                'Border Subtle 01',
                'Subtle border for layer 01.',
                carbon.layer.borderSubtle01,
                carbon,
              ),
              const SizedBox(height: 16),
              _BorderDemo(
                'Border Subtle 02',
                'Subtle border for layer 02.',
                carbon.layer.borderSubtle02,
                carbon,
              ),
              const SizedBox(height: 16),
              _BorderDemo(
                'Border Subtle 03',
                'Subtle border for layer 03.',
                carbon.layer.borderSubtle03,
                carbon,
              ),
              const SizedBox(height: 16),
              _BorderDemo(
                'Border Strong 01',
                'Strong border for more emphasis.',
                carbon.layer.borderStrong01,
                carbon,
              ),
              const SizedBox(height: 16),
              _BorderDemo(
                'Border Strong 02',
                'Stronger border for layer 02.',
                carbon.layer.borderStrong02,
                carbon,
              ),
              const SizedBox(height: 16),
              _BorderDemo(
                'Border Strong 03',
                'Strongest border for layer 03.',
                carbon.layer.borderStrong03,
                carbon,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Layering Example',
          description: 'Practical example showing layers stacked',
          builder: (context) => Container(
            padding: const EdgeInsets.all(32),
            color: carbon.layer.layer01,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layer 01 (Background)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: carbon.text.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  color: carbon.layer.layer02,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Layer 02 (First Elevation)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: carbon.text.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: carbon.layer.layer03,
                        child: Text(
                          'Layer 03 (Second Elevation)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: carbon.text.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LayerDemo extends StatelessWidget {
  final String name;
  final String description;
  final Color color;
  final CarbonThemeData carbon;

  const _LayerDemo(this.name, this.description, this.color, this.carbon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: carbon.layer.borderSubtle01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: carbon.text.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: carbon.layer.layer01,
                  border: Border.all(color: carbon.layer.borderSubtle01),
                ),
                child: Text(
                  '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: carbon.text.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: carbon.text.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _BorderDemo extends StatelessWidget {
  final String name;
  final String description;
  final Color borderColor;
  final CarbonThemeData carbon;

  const _BorderDemo(this.name, this.description, this.borderColor, this.carbon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: carbon.layer.layer01,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: carbon.text.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: carbon.layer.layer02,
                  border: Border.all(color: carbon.layer.borderSubtle01),
                ),
                child: Text(
                  '#${borderColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: carbon.text.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: carbon.text.textSecondary),
          ),
        ],
      ),
    );
  }
}
