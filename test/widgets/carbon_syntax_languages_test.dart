import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  /// The kind of the span covering [needle]'s position in [code], or null.
  CarbonSyntaxKind? spanAt(
    List<CarbonSyntaxSpan> spans,
    String code,
    String needle, {
    int skip = 0,
  }) {
    var index = -1;
    for (var i = 0; i <= skip; i++) {
      index = code.indexOf(needle, index + 1);
      if (index == -1) return null;
    }
    for (final span in spans) {
      if (span.start <= index && index < span.end) return span.kind;
    }
    return null;
  }

  void expectInvariants(List<CarbonSyntaxSpan> spans, String code) {
    for (var i = 0; i < spans.length; i++) {
      expect(spans[i].start, lessThan(spans[i].end), reason: 'empty span $i');
      expect(spans[i].end, lessThanOrEqualTo(code.length),
          reason: 'span $i out of bounds');
      if (i > 0) {
        expect(spans[i].start, greaterThanOrEqualTo(spans[i - 1].end),
            reason: 'span $i overlaps span ${i - 1}');
      }
    }
  }

  group('Dart (Flutter-aware)', () {
    const highlighter = CarbonDartHighlighter();

    test('named-argument labels classify as propertyName', () {
      const code = '''
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    child: Text(flag ? 'yes' : 'no'),
  );
}''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spans, isNotEmpty);
      expect(spanAt(spans, code, 'padding:'), CarbonSyntaxKind.propertyName);
      expect(spanAt(spans, code, 'child:'), CarbonSyntaxKind.propertyName);
      // Ternary operands must NOT classify as labels.
      expect(spanAt(spans, code, 'flag'), isNull);
      // Widget types via the uppercase heuristic.
      expect(spanAt(spans, code, 'Container'), CarbonSyntaxKind.typeName);
    });

    test(r'string interpolation islands render as escape', () {
      const code = r"final s = 'hello $name and ${a.b}!';";
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, r'$name'), CarbonSyntaxKind.escape);
      expect(spanAt(spans, code, r'${a.b}'), CarbonSyntaxKind.escape);
      // The pieces around the islands stay string-colored.
      expect(spanAt(spans, code, 'hello'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, ' and '), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, '!'), CarbonSyntaxKind.string);
    });

    test(r'raw strings are never split by interpolation', () {
      const code = r"final s = r'raw $name';";
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, r'$name'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'raw'), CarbonSyntaxKind.string);
    });

    test(r'escaped dollar is not an island', () {
      const code = r"final s = 'price \$5';";
      final spans = highlighter.highlight(code);
      expect(spanAt(spans, code, r'$5'), CarbonSyntaxKind.string);
    });

    test('triple-quoted strings interpolate too', () {
      const code = "final s = '''line \$x\nmore''';";
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);
      expect(spanAt(spans, code, r'$x'), CarbonSyntaxKind.escape);
      expect(spanAt(spans, code, 'line'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'more'), CarbonSyntaxKind.string);
    });
  });

  group('Bash', () {
    const highlighter = CarbonBashHighlighter();

    test('classifies shell constructs', () {
      const code = '''
#!/bin/bash
# deploy script
export TARGET="prod-\$REGION"
if [ -f "\$1" ]; then
  echo 'literal \$HOME' --verbose
  function cleanup() { local tmp=\$TMPDIR; }
fi''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '#!/bin/bash'), CarbonSyntaxKind.lineComment);
      expect(spanAt(spans, code, '# deploy'), CarbonSyntaxKind.lineComment);
      expect(spanAt(spans, code, 'export'), CarbonSyntaxKind.moduleKeyword);
      expect(spanAt(spans, code, 'if'), CarbonSyntaxKind.controlKeyword);
      expect(spanAt(spans, code, 'then'), CarbonSyntaxKind.controlKeyword);
      expect(spanAt(spans, code, 'fi\n') ?? spanAt(spans, code, 'fi', skip: 0),
          isNotNull);
      expect(
        spanAt(spans, code, 'function'),
        CarbonSyntaxKind.definitionKeyword,
      );
      expect(spanAt(spans, code, 'local'), CarbonSyntaxKind.definitionKeyword);
      // Variables — bare and as an island inside double quotes.
      expect(spanAt(spans, code, r'$TMPDIR'), CarbonSyntaxKind.variableName);
      expect(spanAt(spans, code, r'$REGION'), CarbonSyntaxKind.escape);
      expect(spanAt(spans, code, r'$1'), CarbonSyntaxKind.escape);
      // Single quotes never interpolate.
      expect(spanAt(spans, code, r'$HOME'), CarbonSyntaxKind.string);
      // Flags.
      expect(spanAt(spans, code, '--verbose'),
          CarbonSyntaxKind.attributeName);
    });
  });

  group('JSON', () {
    const highlighter = CarbonJsonHighlighter();

    test('keys, values, atoms, jsonc comments', () {
      const code = '''
{
  // jsonc comment
  "name": "flutter_carbon",
  "count": 42,
  "enabled": true,
  "extra": null
}''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '"name"'), CarbonSyntaxKind.propertyName);
      expect(spanAt(spans, code, '"count"'), CarbonSyntaxKind.propertyName);
      expect(
        spanAt(spans, code, '"flutter_carbon"'),
        CarbonSyntaxKind.string,
      );
      expect(spanAt(spans, code, '42'), CarbonSyntaxKind.number);
      expect(spanAt(spans, code, 'true'), CarbonSyntaxKind.boolean);
      expect(spanAt(spans, code, 'null'), CarbonSyntaxKind.nullLiteral);
      expect(spanAt(spans, code, '// jsonc'), CarbonSyntaxKind.lineComment);
    });
  });

  group('Python', () {
    const highlighter = CarbonPythonHighlighter();

    test('classifies python constructs', () {
      const code = '''
# helper
@dataclass
class Point:
    def scale(self, k: int) -> "Point":
        if k is None:
            raise ValueError(f"bad {k!r} factor")
        return Point(self.x * k)

doc = \'\'\'triple
text\'\'\'
raw = rb"bytes"
ok = True
''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '# helper'), CarbonSyntaxKind.lineComment);
      expect(spanAt(spans, code, '@dataclass'),
          CarbonSyntaxKind.attributeName);
      // 'class Point', not bare 'class' — that would hit '@data*class*'.
      expect(spanAt(spans, code, 'class Point'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'def'), CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'self'), CarbonSyntaxKind.self);
      // 'int)' — bare 'int' would hit 'Po*int*'.
      expect(spanAt(spans, code, 'int)'), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, 'if'), CarbonSyntaxKind.controlKeyword);
      expect(spanAt(spans, code, 'is'), CarbonSyntaxKind.operatorKeyword);
      expect(spanAt(spans, code, 'None'), CarbonSyntaxKind.nullLiteral);
      expect(spanAt(spans, code, 'raise'), CarbonSyntaxKind.controlKeyword);
      expect(spanAt(spans, code, 'True'), CarbonSyntaxKind.boolean);
      // f-string: braces island, surrounding text stays string.
      expect(spanAt(spans, code, '{k!r}'), CarbonSyntaxKind.escape);
      expect(spanAt(spans, code, 'bad '), CarbonSyntaxKind.string);
      // Triple-quoted and prefixed strings.
      expect(spanAt(spans, code, 'triple'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'bytes'), CarbonSyntaxKind.string);
      // Uppercase heuristic.
      expect(spanAt(spans, code, 'ValueError'), CarbonSyntaxKind.typeName);
    });

    test('f-string double braces are not islands', () {
      const code = 'f"a {{literal}} {x}"';
      final spans = highlighter.highlight(code);
      expect(spanAt(spans, code, '{{literal'), CarbonSyntaxKind.string);
      // The inner brace of the escaped pair must not start an island.
      expect(spanAt(spans, code, '{literal', skip: 0),
          CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'literal}'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, '{x}'), CarbonSyntaxKind.escape);
    });
  });

  group('JavaScript', () {
    const highlighter = CarbonJsHighlighter();

    test('classifies js constructs', () {
      const code = '''
/** doc block */
export async function load(id) {
  const url = `/api/\${id}?v=2`;
  if (id === undefined) throw new Error("missing");
  return this.cache[id] ?? null;
}''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '/** doc'), CarbonSyntaxKind.docComment);
      expect(spanAt(spans, code, 'export'), CarbonSyntaxKind.moduleKeyword);
      expect(spanAt(spans, code, 'async'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'function'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'const'),
          CarbonSyntaxKind.definitionKeyword);
      // Template literal with an interpolation island.
      expect(spanAt(spans, code, r'${id}'), CarbonSyntaxKind.escape);
      expect(spanAt(spans, code, '/api/'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, '?v=2'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'undefined'), CarbonSyntaxKind.atom);
      expect(spanAt(spans, code, 'new'), CarbonSyntaxKind.operatorKeyword);
      expect(spanAt(spans, code, 'Error'), CarbonSyntaxKind.typeName);
      expect(spanAt(spans, code, '"missing"'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'this'), CarbonSyntaxKind.self);
      expect(spanAt(spans, code, 'null'), CarbonSyntaxKind.nullLiteral);
    });

    test('/**/ is a block comment, not a doc comment', () {
      const code = 'a /**/ b /** real doc */ c';
      final spans = highlighter.highlight(code);
      expect(spanAt(spans, code, '/**/'), CarbonSyntaxKind.blockComment);
      expect(spanAt(spans, code, '/** real'), CarbonSyntaxKind.docComment);
    });

    test('unterminated template literal colors to EOF', () {
      const code = 'const s = `no end class';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);
      expect(spanAt(spans, code, 'class'), CarbonSyntaxKind.string);
    });
  });

  group('TypeScript', () {
    const highlighter = CarbonTsHighlighter();

    test('classifies ts constructs', () {
      const code = '''
@Component({selector: 'app'})
export interface Repo<T> {
  readonly name: string;
  find(id: number): T | undefined;
}
type Key = keyof Repo<unknown> satisfies string;''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '@Component'),
          CarbonSyntaxKind.attributeName);
      expect(spanAt(spans, code, 'interface'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'readonly'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'string'), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, 'number'), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, 'undefined'), CarbonSyntaxKind.atom);
      expect(spanAt(spans, code, 'type '), CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'keyof'), CarbonSyntaxKind.operatorKeyword);
      expect(spanAt(spans, code, 'satisfies'),
          CarbonSyntaxKind.operatorKeyword);
      expect(spanAt(spans, code, 'unknown'), CarbonSyntaxKind.type);
    });
  });

  group('C', () {
    const highlighter = CarbonCHighlighter();

    test('classifies c constructs', () {
      const code = '''
#include <stdio.h>
#define MAX 100

static int count_words(const char *text) {
  char sep = ' ';
  if (text == NULL) return 0;
  /* walk the buffer */
  return 42;
}''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '#include'), CarbonSyntaxKind.macroName);
      expect(spanAt(spans, code, '#define'), CarbonSyntaxKind.macroName);
      expect(spanAt(spans, code, 'static'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'int '), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, 'const char'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, "' '"), CarbonSyntaxKind.character);
      expect(spanAt(spans, code, 'NULL'), CarbonSyntaxKind.nullLiteral);
      expect(spanAt(spans, code, '/* walk'), CarbonSyntaxKind.blockComment);
      expect(spanAt(spans, code, '42'), CarbonSyntaxKind.number);
    });
  });

  group('C++', () {
    const highlighter = CarbonCppHighlighter();

    test('classifies c++ constructs', () {
      const code = '''
/// Doxygen line
namespace geo {
template <typename T>
class Point {
 public:
  auto scaled(double k) const -> Point {
    if (k == 0) throw std::invalid_argument("zero");
    return static_cast<Point>(*this);
  }
  T* next = nullptr;
};
}  // namespace geo
auto raw = R"(no \\escape \$here)";''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '/// Doxygen'), CarbonSyntaxKind.docComment);
      expect(spanAt(spans, code, 'namespace'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'template'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'typename'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'class'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'double'), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, 'throw'), CarbonSyntaxKind.controlKeyword);
      expect(spanAt(spans, code, 'static_cast'),
          CarbonSyntaxKind.operatorKeyword);
      expect(spanAt(spans, code, 'this'), CarbonSyntaxKind.self);
      expect(spanAt(spans, code, 'nullptr'), CarbonSyntaxKind.nullLiteral);
      expect(spanAt(spans, code, 'no \\escape'), CarbonSyntaxKind.string);
    });
  });

  group('Java', () {
    const highlighter = CarbonJavaHighlighter();

    test('classifies java constructs', () {
      const code = '''
/** Doc block. */
public record Range(int lo, int hi) {
  @Override
  public String toString() {
    char sep = '-';
    String block = """
        multi
        line""";
    if (lo > hi) throw new IllegalStateException("bad");
    return lo + "-" + hi;
  }
}''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '/** Doc'), CarbonSyntaxKind.docComment);
      expect(spanAt(spans, code, 'record'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'int lo'), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, '@Override'),
          CarbonSyntaxKind.attributeName);
      expect(spanAt(spans, code, "'-'"), CarbonSyntaxKind.character);
      expect(spanAt(spans, code, 'multi'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'new'), CarbonSyntaxKind.operatorKeyword);
      expect(spanAt(spans, code, '"bad"'), CarbonSyntaxKind.string);
    });
  });

  group('C#', () {
    const highlighter = CarbonCSharpHighlighter();

    test('classifies c# constructs', () {
      const code = '''
#region Models
/// Summary doc.
[Serializable]
public sealed record User(string Name)
{
    public override string ToString() => \$"user {Name} ok";
    private static readonly string Path = @"C:\\temp\\x";
    public bool Valid => Name is not null;
}
#endregion''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '#region'), CarbonSyntaxKind.macroName);
      expect(spanAt(spans, code, '/// Summary'), CarbonSyntaxKind.docComment);
      expect(spanAt(spans, code, '[Serializable]'),
          CarbonSyntaxKind.attributeName);
      expect(spanAt(spans, code, 'sealed'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'record'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'string Name'), CarbonSyntaxKind.type);
      // Interpolated string: {Name} island, text around stays string.
      expect(spanAt(spans, code, '{Name}'), CarbonSyntaxKind.escape);
      expect(spanAt(spans, code, 'user '), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, ' ok'), CarbonSyntaxKind.string);
      // Verbatim string is never split.
      expect(spanAt(spans, code, 'C:\\temp'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'null'), CarbonSyntaxKind.nullLiteral);
    });

    test('indexers are not attributes', () {
      const code = 'var x = items[index] + map[key];';
      final spans = highlighter.highlight(code);
      expect(spanAt(spans, code, '[index]'), isNull);
      expect(spanAt(spans, code, '[key]'), isNull);
    });
  });

  group('Rust', () {
    const highlighter = CarbonRustHighlighter();

    test('classifies rust constructs', () {
      const code = '''
/// Doc line
#[derive(Debug)]
pub struct Ids<'a> {
    name: &'a str,
}
fn main() {
    let raw = r#"raw "quoted" text"#;
    let c = 'x';
    if 1 != 2 {
        println!("{}", c);
    }
}''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '/// Doc'), CarbonSyntaxKind.docComment);
      expect(spanAt(spans, code, '#[derive(Debug)]'),
          CarbonSyntaxKind.attributeName);
      expect(spanAt(spans, code, 'pub'), CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'struct'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, "'a>"), CarbonSyntaxKind.labelName);
      // 'str,' — bare 'str' would hit '*str*uct'.
      expect(spanAt(spans, code, 'str,'), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, 'fn'), CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'raw "quoted"'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, "'x'"), CarbonSyntaxKind.character);
      expect(spanAt(spans, code, 'println!'), CarbonSyntaxKind.macroName);
      // `1 != 2` must NOT emit a macro span for `1!` — and the numbers stay
      // numbers.
      expect(spanAt(spans, code, '1 !='), CarbonSyntaxKind.number);
      expect(spanAt(spans, code, '2 {'), CarbonSyntaxKind.number);
    });
  });

  group('Go', () {
    const highlighter = CarbonGoHighlighter();

    test('classifies go constructs', () {
      const code = '''
package main

import "fmt"

func main() {
	query := `SELECT *
FROM users`
	var r rune = 'x'
	if err := run(); err != nil {
		fmt.Println("failed", r)
	}
	const max int = 10
	_ = iota
}''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, 'package'), CarbonSyntaxKind.moduleKeyword);
      expect(spanAt(spans, code, 'import'), CarbonSyntaxKind.moduleKeyword);
      expect(spanAt(spans, code, 'func'), CarbonSyntaxKind.definitionKeyword);
      // Multi-line backtick string.
      expect(spanAt(spans, code, 'SELECT'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'FROM users'), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'rune'), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, "'x'"), CarbonSyntaxKind.character);
      expect(spanAt(spans, code, 'nil'), CarbonSyntaxKind.nullLiteral);
      expect(spanAt(spans, code, 'int '), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, 'iota'), CarbonSyntaxKind.atom);
    });
  });

  group('PHP', () {
    const highlighter = CarbonPhpHighlighter();

    test('classifies php constructs', () {
      const code = '''
<?php
# hash comment
// slash comment
#[Attribute]
class Greeter {
    public function greet(string \$name): string {
        \$greeting = "hello \$name";
        \$literal = 'raw \$name';
        foreach ([1, 2] as \$i) { echo \$i; }
        return \$greeting ?? null;
    }
}
?>''';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);

      expect(spanAt(spans, code, '<?php'), CarbonSyntaxKind.tag);
      expect(spanAt(spans, code, '?>'), CarbonSyntaxKind.tag);
      expect(spanAt(spans, code, '# hash'), CarbonSyntaxKind.lineComment);
      expect(spanAt(spans, code, '// slash'), CarbonSyntaxKind.lineComment);
      expect(spanAt(spans, code, '#[Attribute]'),
          CarbonSyntaxKind.attributeName);
      expect(spanAt(spans, code, 'class'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'function'),
          CarbonSyntaxKind.definitionKeyword);
      expect(spanAt(spans, code, 'string '), CarbonSyntaxKind.type);
      expect(spanAt(spans, code, r'$greeting'),
          CarbonSyntaxKind.variableName);
      // Double quotes interpolate; single quotes never do.
      expect(spanAt(spans, code, r'$name";'), CarbonSyntaxKind.escape);
      expect(spanAt(spans, code, r"$name';"), CarbonSyntaxKind.string);
      expect(spanAt(spans, code, 'foreach'),
          CarbonSyntaxKind.controlKeyword);
      expect(spanAt(spans, code, 'null'), CarbonSyntaxKind.nullLiteral);
    });
  });

  group('carbonHighlighterFor', () {
    test('maps fence tags to highlighter types', () {
      expect(carbonHighlighterFor('dart'), isA<CarbonDartHighlighter>());
      expect(carbonHighlighterFor('bash'), isA<CarbonBashHighlighter>());
      expect(carbonHighlighterFor('sh'), isA<CarbonBashHighlighter>());
      expect(carbonHighlighterFor('json'), isA<CarbonJsonHighlighter>());
      expect(carbonHighlighterFor('jsonc'), isA<CarbonJsonHighlighter>());
      expect(carbonHighlighterFor('py'), isA<CarbonPythonHighlighter>());
      expect(
          carbonHighlighterFor('python'), isA<CarbonPythonHighlighter>());
      expect(carbonHighlighterFor('js'), isA<CarbonJsHighlighter>());
      expect(carbonHighlighterFor('jsx'), isA<CarbonJsHighlighter>());
      expect(carbonHighlighterFor('ts'), isA<CarbonTsHighlighter>());
      expect(carbonHighlighterFor('tsx'), isA<CarbonTsHighlighter>());
      expect(carbonHighlighterFor('rust'), isA<CarbonRustHighlighter>());
      expect(carbonHighlighterFor('go'), isA<CarbonGoHighlighter>());
      expect(carbonHighlighterFor('c'), isA<CarbonCHighlighter>());
      expect(carbonHighlighterFor('cpp'), isA<CarbonCppHighlighter>());
      expect(carbonHighlighterFor('c++'), isA<CarbonCppHighlighter>());
      expect(carbonHighlighterFor('php'), isA<CarbonPhpHighlighter>());
      expect(carbonHighlighterFor('java'), isA<CarbonJavaHighlighter>());
      expect(carbonHighlighterFor('cs'), isA<CarbonCSharpHighlighter>());
      expect(carbonHighlighterFor('c#'), isA<CarbonCSharpHighlighter>());
    });

    test('is case-insensitive and returns null for unknown tags', () {
      expect(carbonHighlighterFor('DART'), isA<CarbonDartHighlighter>());
      expect(carbonHighlighterFor('Python'), isA<CarbonPythonHighlighter>());
      expect(carbonHighlighterFor('cobol'), isNull);
      expect(carbonHighlighterFor(''), isNull);
    });
  });

  group('all-highlighter sweep', () {
    test('every highlighter keeps spans sorted/non-overlapping/in-bounds',
        () {
      // A deliberately nasty polyglot fixture: unterminated constructs,
      // mixed quotes, interpolation-ish content.
      const fixture = '''
// c "str \$x" 'c' `t \${y}` #tag @anno #[attr] r#"raw"# @"verb ""q"""
f"py {z}" '''
          "''' unterminated ``` /* open"
          r' \${a}\$b \$1 name! 0xFF_1u64 <?php ?> --flag \$@';

      final highlighters = <CarbonSyntaxHighlighter>[
        const CarbonDartHighlighter(),
        const CarbonBashHighlighter(),
        const CarbonJsonHighlighter(),
        const CarbonPythonHighlighter(),
        const CarbonJsHighlighter(),
        const CarbonTsHighlighter(),
        const CarbonCHighlighter(),
        const CarbonCppHighlighter(),
        const CarbonJavaHighlighter(),
        const CarbonCSharpHighlighter(),
        const CarbonRustHighlighter(),
        const CarbonGoHighlighter(),
        const CarbonPhpHighlighter(),
      ];
      for (final highlighter in highlighters) {
        final spans = highlighter.highlight(fixture);
        expectInvariants(spans, fixture);
        // Purity: same input, same spans.
        final again = highlighter.highlight(fixture);
        expect(again.length, spans.length,
            reason: '${highlighter.runtimeType} is not pure');
      }
    });
  });

  group('engine invariants', () {
    const highlighter = CarbonDartHighlighter();

    test('unterminated block comment colors to EOF without crashing', () {
      const code = 'final x = 1;\n/* unterminated class import';
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);
      expect(spanAt(spans, code, 'unterminated'),
          CarbonSyntaxKind.blockComment);
      // Keywords inside must not leak.
      expect(spanAt(spans, code, 'class'), CarbonSyntaxKind.blockComment);
      expect(spanAt(spans, code, 'import'), CarbonSyntaxKind.blockComment);
    });

    test('unterminated triple string colors to EOF without crashing', () {
      const code = "final s = '''no terminator class";
      final spans = highlighter.highlight(code);
      expectInvariants(spans, code);
      expect(spanAt(spans, code, 'class'), CarbonSyntaxKind.string);
    });

    test('empty block comment /**/ is a block comment, not doc', () {
      const code = 'a /**/ b';
      final spans = highlighter.highlight(code);
      expect(spanAt(spans, code, '/**/'), CarbonSyntaxKind.blockComment);
    });

    test('interpolation output stays sorted and non-overlapping', () {
      const code = r"'$a$b${c}$d' + '$e';";
      final spans = const CarbonDartHighlighter().highlight(code);
      expectInvariants(spans, code);
    });
  });
}
