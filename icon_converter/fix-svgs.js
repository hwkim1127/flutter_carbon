const fs = require('fs');
const path = require('path');

const svgDir = path.join(__dirname, '../assets/icons/svg/32');
const files = fs.readdirSync(svgDir).filter(f => f.endsWith('.svg'));

console.log(`Checking and fixing ${files.length} SVG files...`);

const problematicFiles = [
  'calendar--add--alt.svg',
  'calendar--add.svg',
  'data-quality-definition.svg',
  'rule--data-quality.svg',
  'workflow-automation.svg',
];

let fixedCount = 0;

for (const file of problematicFiles) {
  const filePath = path.join(svgDir, file);

  if (!fs.existsSync(filePath)) {
    console.log(`Skipping ${file} (not found)`);
    continue;
  }

  let content = fs.readFileSync(filePath, 'utf8');

  // Remove DOCTYPE declaration with entity definitions
  content = content.replace(/<!DOCTYPE[^>]*\[[^\]]*\]>/gs, '');

  // Remove custom namespace attributes that reference entities
  content = content.replace(/\s*xmlns:x="&[^"]+;"/g, '');
  content = content.replace(/\s*xmlns:i="&[^"]+;"/g, '');
  content = content.replace(/\s*xmlns:graph="&[^"]+;"/g, '');

  // Remove the entire <switch> element and its content, keep only the content inside the <g> tag
  content = content.replace(/<switch>\s*<foreignObject[^>]*>[\s\S]*?<\/foreignObject>\s*<g[^>]*>/gs, '<g>');
  content = content.replace(/<\/g>\s*<\/switch>/gs, '</g>');

  // Remove i: prefixed attributes
  content = content.replace(/\s+i:\w+="[^"]*"/g, '');

  // Write the fixed content back
  fs.writeFileSync(filePath, content, 'utf8');
  fixedCount++;
  console.log(`Fixed: ${file}`);
}

console.log(`\nFixed ${fixedCount} SVG files!`);
