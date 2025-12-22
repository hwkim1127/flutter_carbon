const fs = require('fs');
const path = require('path');

const svgDir = path.join(__dirname, '../assets/icons/svg/32');
const files = fs.readdirSync(svgDir).filter(f => f.endsWith('.svg'));

console.log(`Checking ${files.length} SVG files...`);

for (const file of files) {
  const filePath = path.join(svgDir, file);
  const content = fs.readFileSync(filePath, 'utf8');

  // Check for problematic patterns
  if (content.match(/&#[0-9]+;/)) {
    console.log(`Found numeric entity in: ${file}`);
  }

  // Check for malformed XML
  const lines = content.split('\n');
  if (lines.length >= 12) {
    const line12 = lines[11]; // Line 12 (0-indexed)
    if (line12.includes('&') && !line12.includes('&amp;') && !line12.includes('&lt;') && !line12.includes('&gt;') && !line12.includes('&quot;')) {
      console.log(`Potential issue in ${file} at line 12:`);
      console.log(`  ${line12.substring(0, 100)}`);
    }
  }
}

console.log('Done!');
