import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../../widgets/demo_page_template.dart';

/// Demo page for Carbon color palette.
class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Colors',
      description:
          'Carbon color palette with all available colors from the design system.',
      sections: [
        DemoSection(
          title: 'Grayscale',
          description: 'Neutral gray scale from light to dark',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Gray 10', CarbonPalette.gray10),
              _ColorItem('Gray 20', CarbonPalette.gray20),
              _ColorItem('Gray 30', CarbonPalette.gray30),
              _ColorItem('Gray 40', CarbonPalette.gray40),
              _ColorItem('Gray 50', CarbonPalette.gray50),
              _ColorItem('Gray 60', CarbonPalette.gray60),
              _ColorItem('Gray 70', CarbonPalette.gray70),
              _ColorItem('Gray 80', CarbonPalette.gray80),
              _ColorItem('Gray 90', CarbonPalette.gray90),
              _ColorItem('Gray 100', CarbonPalette.gray100),
            ],
          ),
        ),
        DemoSection(
          title: 'Cool Gray',
          description: 'Cool gray scale with subtle blue undertones',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Cool Gray 10', CarbonPalette.coolGray10),
              _ColorItem('Cool Gray 20', CarbonPalette.coolGray20),
              _ColorItem('Cool Gray 30', CarbonPalette.coolGray30),
              _ColorItem('Cool Gray 40', CarbonPalette.coolGray40),
              _ColorItem('Cool Gray 50', CarbonPalette.coolGray50),
              _ColorItem('Cool Gray 60', CarbonPalette.coolGray60),
              _ColorItem('Cool Gray 70', CarbonPalette.coolGray70),
              _ColorItem('Cool Gray 80', CarbonPalette.coolGray80),
              _ColorItem('Cool Gray 90', CarbonPalette.coolGray90),
              _ColorItem('Cool Gray 100', CarbonPalette.coolGray100),
            ],
          ),
        ),
        DemoSection(
          title: 'Warm Gray',
          description: 'Warm gray scale with subtle brown undertones',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Warm Gray 10', CarbonPalette.warmGray10),
              _ColorItem('Warm Gray 20', CarbonPalette.warmGray20),
              _ColorItem('Warm Gray 30', CarbonPalette.warmGray30),
              _ColorItem('Warm Gray 40', CarbonPalette.warmGray40),
              _ColorItem('Warm Gray 50', CarbonPalette.warmGray50),
              _ColorItem('Warm Gray 60', CarbonPalette.warmGray60),
              _ColorItem('Warm Gray 70', CarbonPalette.warmGray70),
              _ColorItem('Warm Gray 80', CarbonPalette.warmGray80),
              _ColorItem('Warm Gray 90', CarbonPalette.warmGray90),
              _ColorItem('Warm Gray 100', CarbonPalette.warmGray100),
            ],
          ),
        ),
        DemoSection(
          title: 'Blue',
          description: 'Primary blue color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Blue 10', CarbonPalette.blue10),
              _ColorItem('Blue 20', CarbonPalette.blue20),
              _ColorItem('Blue 30', CarbonPalette.blue30),
              _ColorItem('Blue 40', CarbonPalette.blue40),
              _ColorItem('Blue 50', CarbonPalette.blue50),
              _ColorItem('Blue 60', CarbonPalette.blue60),
              _ColorItem('Blue 70', CarbonPalette.blue70),
              _ColorItem('Blue 80', CarbonPalette.blue80),
              _ColorItem('Blue 90', CarbonPalette.blue90),
              _ColorItem('Blue 100', CarbonPalette.blue100),
            ],
          ),
        ),
        DemoSection(
          title: 'Green',
          description: 'Success and positive state color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Green 10', CarbonPalette.green10),
              _ColorItem('Green 20', CarbonPalette.green20),
              _ColorItem('Green 30', CarbonPalette.green30),
              _ColorItem('Green 40', CarbonPalette.green40),
              _ColorItem('Green 50', CarbonPalette.green50),
              _ColorItem('Green 60', CarbonPalette.green60),
              _ColorItem('Green 70', CarbonPalette.green70),
              _ColorItem('Green 80', CarbonPalette.green80),
              _ColorItem('Green 90', CarbonPalette.green90),
              _ColorItem('Green 100', CarbonPalette.green100),
            ],
          ),
        ),
        DemoSection(
          title: 'Red',
          description: 'Error and danger state color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Red 10', CarbonPalette.red10),
              _ColorItem('Red 20', CarbonPalette.red20),
              _ColorItem('Red 30', CarbonPalette.red30),
              _ColorItem('Red 40', CarbonPalette.red40),
              _ColorItem('Red 50', CarbonPalette.red50),
              _ColorItem('Red 60', CarbonPalette.red60),
              _ColorItem('Red 70', CarbonPalette.red70),
              _ColorItem('Red 80', CarbonPalette.red80),
              _ColorItem('Red 90', CarbonPalette.red90),
              _ColorItem('Red 100', CarbonPalette.red100),
            ],
          ),
        ),
        DemoSection(
          title: 'Yellow',
          description: 'Warning and caution color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Yellow 10', CarbonPalette.yellow10),
              _ColorItem('Yellow 20', CarbonPalette.yellow20),
              _ColorItem('Yellow 30', CarbonPalette.yellow30),
              _ColorItem('Yellow 40', CarbonPalette.yellow40),
              _ColorItem('Yellow 50', CarbonPalette.yellow50),
              _ColorItem('Yellow 60', CarbonPalette.yellow60),
              _ColorItem('Yellow 70', CarbonPalette.yellow70),
              _ColorItem('Yellow 80', CarbonPalette.yellow80),
              _ColorItem('Yellow 90', CarbonPalette.yellow90),
              _ColorItem('Yellow 100', CarbonPalette.yellow100),
            ],
          ),
        ),
        DemoSection(
          title: 'Cyan',
          description: 'Information and secondary accent color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Cyan 10', CarbonPalette.cyan10),
              _ColorItem('Cyan 20', CarbonPalette.cyan20),
              _ColorItem('Cyan 30', CarbonPalette.cyan30),
              _ColorItem('Cyan 40', CarbonPalette.cyan40),
              _ColorItem('Cyan 50', CarbonPalette.cyan50),
              _ColorItem('Cyan 60', CarbonPalette.cyan60),
              _ColorItem('Cyan 70', CarbonPalette.cyan70),
              _ColorItem('Cyan 80', CarbonPalette.cyan80),
              _ColorItem('Cyan 90', CarbonPalette.cyan90),
              _ColorItem('Cyan 100', CarbonPalette.cyan100),
            ],
          ),
        ),
        DemoSection(
          title: 'Purple',
          description: 'Accent color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Purple 10', CarbonPalette.purple10),
              _ColorItem('Purple 20', CarbonPalette.purple20),
              _ColorItem('Purple 30', CarbonPalette.purple30),
              _ColorItem('Purple 40', CarbonPalette.purple40),
              _ColorItem('Purple 50', CarbonPalette.purple50),
              _ColorItem('Purple 60', CarbonPalette.purple60),
              _ColorItem('Purple 70', CarbonPalette.purple70),
              _ColorItem('Purple 80', CarbonPalette.purple80),
              _ColorItem('Purple 90', CarbonPalette.purple90),
              _ColorItem('Purple 100', CarbonPalette.purple100),
            ],
          ),
        ),
        DemoSection(
          title: 'Magenta',
          description: 'Accent color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Magenta 10', CarbonPalette.magenta10),
              _ColorItem('Magenta 20', CarbonPalette.magenta20),
              _ColorItem('Magenta 30', CarbonPalette.magenta30),
              _ColorItem('Magenta 40', CarbonPalette.magenta40),
              _ColorItem('Magenta 50', CarbonPalette.magenta50),
              _ColorItem('Magenta 60', CarbonPalette.magenta60),
              _ColorItem('Magenta 70', CarbonPalette.magenta70),
              _ColorItem('Magenta 80', CarbonPalette.magenta80),
              _ColorItem('Magenta 90', CarbonPalette.magenta90),
              _ColorItem('Magenta 100', CarbonPalette.magenta100),
            ],
          ),
        ),
        DemoSection(
          title: 'Teal',
          description: 'Accent color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Teal 10', CarbonPalette.teal10),
              _ColorItem('Teal 20', CarbonPalette.teal20),
              _ColorItem('Teal 30', CarbonPalette.teal30),
              _ColorItem('Teal 40', CarbonPalette.teal40),
              _ColorItem('Teal 50', CarbonPalette.teal50),
              _ColorItem('Teal 60', CarbonPalette.teal60),
              _ColorItem('Teal 70', CarbonPalette.teal70),
              _ColorItem('Teal 80', CarbonPalette.teal80),
              _ColorItem('Teal 90', CarbonPalette.teal90),
              _ColorItem('Teal 100', CarbonPalette.teal100),
            ],
          ),
        ),
        DemoSection(
          title: 'Orange',
          description: 'Accent color scale',
          builder: (context) => _ColorPaletteGrid(
            colors: const [
              _ColorItem('Orange 10', CarbonPalette.orange10),
              _ColorItem('Orange 20', CarbonPalette.orange20),
              _ColorItem('Orange 30', CarbonPalette.orange30),
              _ColorItem('Orange 40', CarbonPalette.orange40),
              _ColorItem('Orange 50', CarbonPalette.orange50),
              _ColorItem('Orange 60', CarbonPalette.orange60),
              _ColorItem('Orange 70', CarbonPalette.orange70),
              _ColorItem('Orange 80', CarbonPalette.orange80),
              _ColorItem('Orange 90', CarbonPalette.orange90),
              _ColorItem('Orange 100', CarbonPalette.orange100),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorItem {
  final String name;
  final Color color;

  const _ColorItem(this.name, this.color);
}

class _ColorPaletteGrid extends StatelessWidget {
  final List<_ColorItem> colors;

  const _ColorPaletteGrid({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((item) {
        // Determine if text should be white or black based on color brightness
        final luminance = item.color.computeLuminance();
        final textColor = luminance > 0.5 ? Colors.black : Colors.white;

        return Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            color: item.color,
            border: Border.all(
              color: context.carbon.layer.borderSubtle01,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '#${item.color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
