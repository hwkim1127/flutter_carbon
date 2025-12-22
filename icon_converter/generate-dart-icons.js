/**
 * Generate Dart icon constants from Carbon Design System icon font
 *
 * This script:
 * 1. Reads icon mappings from CarbonIcons.json
 * 2. Converts icon names from kebab-case to camelCase
 * 3. Handles special cases:
 *    - Icons starting with numbers get 'icon' prefix (e.g., 4K → icon4k)
 *    - Dart reserved keywords get 'Icon' suffix (e.g., continue → continueIcon)
 * 4. Generates a Dart class with all icon constants as IconData
 *
 * Usage: node generate-dart-icons.js
 */

const fs = require('fs');
const path = require('path');

const jsonPath = path.join(__dirname, '../fonts/carbon-icons/CarbonIcons.json');
const outputPath = path.join(__dirname, '../lib/src/icons/carbon_icons.dart');

// Read the icon mapping
const iconMap = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));

// Dart reserved keywords that cannot be used as identifiers
const DART_RESERVED_KEYWORDS = new Set([
  'abstract', 'as', 'assert', 'async', 'await',
  'break',
  'case', 'catch', 'class', 'const', 'continue',
  'default', 'deferred', 'do', 'dynamic',
  'else', 'enum', 'export', 'extends', 'extension', 'external',
  'factory', 'false', 'final', 'finally', 'for',
  'get',
  'hide',
  'if', 'implements', 'import', 'in', 'interface', 'is',
  'late', 'library',
  'mixin',
  'new', 'null',
  'of', 'on', 'operator',
  'part',
  'required', 'rethrow', 'return',
  'set', 'show', 'static', 'super', 'switch', 'sync',
  'this', 'throw', 'true', 'try', 'typedef',
  'var', 'void',
  'while', 'with',
  'yield'
]);

// Convert kebab-case to camelCase
function toCamelCase(str) {
  let result = str
    .split('-')
    .map((word, index) => {
      if (index === 0) return word.toLowerCase();
      return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
    })
    .join('');

  // Dart identifiers can't start with a number
  if (/^[0-9]/.test(result)) {
    result = 'icon' + result.charAt(0).toUpperCase() + result.slice(1);
  }

  // Check if the result is a Dart reserved keyword
  if (DART_RESERVED_KEYWORDS.has(result)) {
    result = result + 'Icon';
  }

  return result;
}

// Convert kebab-case to PascalCase
function toPascalCase(str) {
  return str
    .split('-')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join('');
}

// Generate Dart code
let dartCode = `// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated from Carbon Design System icons
// Icon count: ${Object.keys(iconMap).length}

import 'package:flutter/widgets.dart';

/// IconData constants for Carbon Design System icons.
///
/// Use these icons with the [Icon] widget like Material Icons:
///
/// \`\`\`dart
/// Icon(CarbonIcons.add)
/// Icon(CarbonIcons.checkmark, size: 24.0, color: Colors.blue)
/// \`\`\`
class CarbonIcons {
  CarbonIcons._();

  static const String _fontFamily = 'CarbonIcons';
  static const String _fontPackage = 'flutter_carbon';

`;

// Sort icons alphabetically
const sortedIcons = Object.entries(iconMap).sort(([a], [b]) => a.localeCompare(b));

// Track special naming cases
const numericPrefixIcons = [];
const reservedKeywordIcons = [];

// Generate icon constants
sortedIcons.forEach(([iconName, codePoint]) => {
  const camelCaseName = toCamelCase(iconName);
  const hexCode = `0x${codePoint.toString(16)}`;

  // Track special cases for reporting
  if (/^[0-9]/.test(iconName)) {
    numericPrefixIcons.push({ original: iconName, generated: camelCaseName });
  }
  const baseResult = iconName.split('-').map((word, index) => {
    if (index === 0) return word.toLowerCase();
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  }).join('');
  if (DART_RESERVED_KEYWORDS.has(baseResult)) {
    reservedKeywordIcons.push({ original: iconName, generated: camelCaseName });
  }

  dartCode += `  /// Icon for "${iconName}"\n`;
  dartCode += `  static const IconData ${camelCaseName} = IconData(${hexCode}, fontFamily: _fontFamily, fontPackage: _fontPackage);\n\n`;
});

// Add helper method to get all icons
dartCode += `  /// Get all available icons as a map
  static Map<String, IconData> get all => {
`;

sortedIcons.forEach(([iconName, _], index) => {
  const camelCaseName = toCamelCase(iconName);
  const comma = index < sortedIcons.length - 1 ? ',' : '';
  dartCode += `        '${iconName}': ${camelCaseName}${comma}\n`;
});

dartCode += `      };
}
`;

// Write to file
const outputDir = path.dirname(outputPath);
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

fs.writeFileSync(outputPath, dartCode, 'utf8');

console.log(`✓ Generated ${outputPath}`);
console.log(`✓ Total icons: ${Object.keys(iconMap).length}`);

// Report special naming cases
if (numericPrefixIcons.length > 0) {
  console.log(`\n⚠ ${numericPrefixIcons.length} icons with numeric prefix (added 'icon' prefix):`);
  numericPrefixIcons.forEach(({ original, generated }) => {
    console.log(`  - "${original}" → ${generated}`);
  });
}

if (reservedKeywordIcons.length > 0) {
  console.log(`\n⚠ ${reservedKeywordIcons.length} icons using Dart reserved keywords (added 'Icon' suffix):`);
  reservedKeywordIcons.forEach(({ original, generated }) => {
    console.log(`  - "${original}" → ${generated}`);
  });
}
