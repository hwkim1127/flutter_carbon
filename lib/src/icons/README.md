# Carbon Icons

Carbon Design System icons converted to Flutter IconFont with **2,575 icons**.

## Usage

Import the package and use icons just like Material Icons:

```dart
import 'package:flutter_carbon/flutter_carbon.dart';

// Use in an Icon widget
Icon(CarbonIcons.add)
Icon(CarbonIcons.checkmark, size: 24.0, color: Colors.blue)
Icon(CarbonIcons.settings, size: 32.0)

// Use in IconButton
IconButton(
  icon: Icon(CarbonIcons.menu),
  onPressed: () {},
)

// Use in any widget that accepts IconData
ListTile(
  leading: Icon(CarbonIcons.user),
  title: Text('User Profile'),
)
```

## Available Icons

All 2,575 Carbon icons are available as static constants in the `CarbonIcons` class. Icon names are converted from kebab-case to camelCase:

- `add` → `CarbonIcons.add`
- `arrow--right` → `CarbonIcons.arrowRight`
- `checkmark--filled` → `CarbonIcons.checkmarkFilled`
- `4K` → `CarbonIcons.icon4k` (numeric prefixes get `icon` prefix)

## Getting All Icons

```dart
// Get a map of all available icons
Map<String, IconData> allIcons = CarbonIcons.all;

// Iterate through all icons
allIcons.forEach((name, iconData) {
  print('Icon: $name');
});
```

## Regenerating Icons

If you need to regenerate the icon font from updated SVG files:

```bash
cd icon_converter
npm run build
node generate-dart-icons.js
```

This will:
1. Convert SVGs in `assets/icons/svg/32/` to TTF font
2. Generate the `carbon_icons.dart` file with all icon constants
