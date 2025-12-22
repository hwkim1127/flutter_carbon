# Carbon Icons Setup Summary

Successfully converted **2,575** Carbon Design System SVG icons to a Flutter icon font!

## What Was Done

### 1. SVG to TTF Conversion
- Used `@twbs/fantasticon` to convert SVG icons to TrueType font
- Source: `assets/icons/svg/32/` (32px icon set - most comprehensive)
- Output: `fonts/carbon-icons/CarbonIcons.ttf`
- Also generated: JSON file for reference

### 2. Fixed Problematic SVGs
Fixed 5 SVG files that had Adobe Illustrator-specific XML entities:
- `calendar--add--alt.svg`
- `calendar--add.svg`
- `data-quality-definition.svg`
- `rule--data-quality.svg`
- `workflow-automation.svg`

### 3. Generated Dart Icon Constants
Created `lib/src/icons/carbon_icons.dart` with:
- 2,575 icon constants as `IconData`
- Proper naming (kebab-case → camelCase)
- Icons starting with numbers prefixed with "icon" (e.g., `4K` → `icon4k`)
- Helper method `CarbonIcons.all` to get all icons as a Map

### 4. Updated Package Configuration
- Added font to `pubspec.yaml`
- Exported icons in main library file
- Added README and examples

## Usage

```dart
import 'package:flutter_carbon/flutter_carbon.dart';

// Simple usage
Icon(CarbonIcons.add)
Icon(CarbonIcons.checkmark, size: 24, color: Colors.blue)

// In buttons
IconButton(
  icon: Icon(CarbonIcons.menu),
  onPressed: () {},
)

// Get all icons
Map<String, IconData> allIcons = CarbonIcons.all;
print('Total icons: ${allIcons.length}'); // 2575
```

## Icon Naming Convention

SVG filenames are converted from kebab-case to camelCase with special handling:

| SVG Filename | Dart Constant | Notes |
|--------------|---------------|-------|
| `add.svg` | `CarbonIcons.add` | Standard conversion |
| `arrow--right.svg` | `CarbonIcons.arrowRight` | Double dash becomes camelCase |
| `checkmark--filled.svg` | `CarbonIcons.checkmarkFilled` | Double dash becomes camelCase |
| `4K.svg` | `CarbonIcons.icon4k` | Numeric prefix gets `icon` |
| `continue.svg` | `CarbonIcons.continueIcon` | Reserved keyword gets `Icon` suffix |
| `return.svg` | `CarbonIcons.returnIcon` | Reserved keyword gets `Icon` suffix |
| `user--avatar.svg` | `CarbonIcons.userAvatar` | Standard conversion |

**Special Rules:**
- Icons starting with numbers get `icon` prefix (e.g., `4K` → `icon4k`)
- Dart reserved keywords get `Icon` suffix (e.g., `continue` → `continueIcon`, `return` → `returnIcon`)

## Regenerating Icons

If you update the SVG files or add new ones:

```bash
cd icon_converter

# Step 1: Generate font files
npm run build

# Step 2: Generate Dart constants
node generate-dart-icons.js

# Step 3: Verify
flutter analyze lib/src/icons/carbon_icons.dart
```

## Files Created

- `fonts/carbon-icons/CarbonIcons.ttf` - Icon font
- `fonts/carbon-icons/CarbonIcons.woff` - Web font (WOFF)
- `fonts/carbon-icons/CarbonIcons.woff2` - Web font (WOFF2)
- `fonts/carbon-icons/CarbonIcons.json` - Icon mapping
- `fonts/carbon-icons/CarbonIcons.css` - CSS reference
- `lib/src/icons/carbon_icons.dart` - Flutter icon constants (GENERATED)
- `icon_converter/` - Build tooling directory

## Benefits

1. **Native IconData**: Works exactly like Material Icons or Cupertino Icons
2. **Small Bundle Size**: TTF font is much smaller than 2,575 individual SVG assets
3. **Type Safe**: All icons are compile-time constants
4. **Scalable**: Vector icons scale perfectly to any size
5. **Theme Support**: Icons inherit color from IconTheme, just like Material Icons
6. **Consistent API**: Familiar API for Flutter developers

## Example

See `example/lib/screens/icons_demo_screen.dart` for a complete demo showing:
- Icon grid display
- Usage in AppBar
- Usage in buttons
- Usage in dialogs
- Getting icon statistics

## Notes

- The font family is `CarbonIcons`
- Font package is `flutter_carbon`
- Icons use Unicode Private Use Area (0xF100+)
- All 2,575 icons from Carbon Design System v11 are included
