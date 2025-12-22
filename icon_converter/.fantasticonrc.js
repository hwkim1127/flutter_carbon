module.exports = {
  // Input: Use the comprehensive 32px icon set (2,575 icons)
  inputDir: '../assets/icons/svg/32',

  // Output: Where to generate the font files
  outputDir: '../fonts/carbon-icons',

  // Font formats to generate
  fontTypes: ['ttf'],

  // Asset types for reference
  assetTypes: ['json'],

  // Font family name
  name: 'CarbonIcons',

  // Prefix for CSS classes
  prefix: 'carbon',

  // Normalize icons for consistent sizing
  normalize: true,

  // Font height
  fontHeight: 1000,

  // Descent (affects vertical alignment)
  descent: 200,

  // Round icon paths for smaller file size
  round: 10e12,

  // Selector for CSS
  selector: '.carbon',

  // Tag for HTML (not used in Flutter)
  tag: 'i',

  // Code point start (Unicode Private Use Area)
  codepoints: {},

  // Font format version
  formatOptions: {
    ttf: {
      // TTF-specific options
      ts: Math.round(Date.now() / 1000),
    },
  },
};
