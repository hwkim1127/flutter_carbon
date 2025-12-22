const fs = require('fs');
const path = require('path');
const sax = require('sax');

const svgDir = path.join(__dirname, '../assets/icons/svg/32');
const files = fs.readdirSync(svgDir).filter(f => f.endsWith('.svg')).sort();

console.log(`Testing ${files.length} SVG files for XML validity...`);

const problemFiles = [];

for (const file of files) {
  const filePath = path.join(svgDir, file);
  const content = fs.readFileSync(filePath, 'utf8');

  const parser = sax.parser(true);
  let hasError = false;

  parser.onerror = function (e) {
    hasError = true;
    problemFiles.push({ file, error: e.message });
  };

  try {
    parser.write(content).close();
  } catch (e) {
    problemFiles.push({ file, error: e.message });
  }
}

if (problemFiles.length > 0) {
  console.log(`\nFound ${problemFiles.length} problematic SVG file(s):\n`);
  problemFiles.forEach(({ file, error }) => {
    console.log(`  ${file}`);
    console.log(`    Error: ${error}\n`);
  });
} else {
  console.log('\nAll SVG files are valid!');
}
