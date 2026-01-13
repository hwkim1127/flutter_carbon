const fs = require('fs');
const path = require('path');

const svgDir = path.join(__dirname, '../assets/icons/svg/32');
const files = fs.readdirSync(svgDir).filter(f => f.endsWith('.svg'));

console.log(`Checking and fixing ${files.length} SVG files...`);

let fixedCount = 0;

for (const file of files) {
  const filePath = path.join(svgDir, file);
  if (!fs.existsSync(filePath)) continue;

  let content = fs.readFileSync(filePath, 'utf8');
  let originalContent = content;

  // 1. Remove DOCTYPE declaration
  content = content.replace(/<!DOCTYPE[^>]*\[[^\]]*\]>/gs, '');

  // 2. Remove custom namespace attributes
  content = content.replace(/\s*xmlns:x="&[^"]+;"/g, '');
  content = content.replace(/\s*xmlns:i="&[^"]+;"/g, '');
  content = content.replace(/\s*xmlns:graph="&[^"]+;"/g, '');

  // 3. Remove switch/foreignObject tags
  content = content.replace(/<switch[^>]*>/g, '');
  content = content.replace(/<\/switch>/g, '');
  content = content.replace(/<foreignObject[^>]*>[\s\S]*?<\/foreignObject>/gs, '');

  // 4. Remove i: prefixed attributes
  content = content.replace(/\s+i:\w+="[^"]*"/g, '');

  // 5. Remove transparent bounding box rectangles/paths (Fix for inverted icons)

  // 5a. Remove <rect> based bounding boxes (generic class matching)
  // Matches <rect ... width="32" height="32" ... /> regardless of class name
  content = content.replace(/<rect[^>]*width="32"[^>]*height="32"[^>]*\/>/g, '');

  // 5b. Remove <path> based bounding boxes
  // Matches <path d="M0 0h32v32H0z"/> and variations
  content = content.replace(/<path[^>]*d="M0 0h32v32H0z"[^>]*\/>/g, '');

  // 6. Dynamic removal of transparent elements based on class definitions
  // Find all classes that are defined as fill:none
  // e.g. .cls-1{fill:none;} or .st0{fill:none;}
  const styleMatch = content.match(/<style[^>]*>([\s\S]*?)<\/style>/);
  if (styleMatch) {
    const styleContent = styleMatch[1];
    const fillNoneRegex = /\.([\w-]+)\s*\{[^}]*fill\s*:\s*none[^}]*\}/g;
    let match;
    const classesToRemove = [];

    while ((match = fillNoneRegex.exec(styleContent)) !== null) {
      classesToRemove.push(match[1]);
    }

    // Remove elements using these classes
    for (const className of classesToRemove) {
      // Create a regex to match elements with this class
      // Matches class="className" or class="... className ..."
      const classRegex = new RegExp(`<[^>]+class="[^"]*\\b${className}\\b[^"]*"[^>]*\\/?>`, 'g');
      content = content.replace(classRegex, '');
    }
  }

  // 7. Remove any style definitions that are now likely unused
  content = content.replace(/<style[^>]*>[\s\S]*?fill:none;[\s\S]*?<\/style>/g, '');
  content = content.replace(/<defs><style>[\s\S]*?fill:none;[\s\S]*?<\/style><\/defs>/g, '');

  // Write if changed
  if (content !== originalContent) {
    fs.writeFileSync(filePath, content, 'utf8');
    fixedCount++;
  }
}

console.log(`\nFixed ${fixedCount} SVG files!`);
