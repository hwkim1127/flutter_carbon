import 'package:flutter/material.dart';
import 'package:flutter_carbon/material.dart';
import '../widgets/demo_page_template.dart';

/// One gallery entry: fence tag + display name + idiomatic fixture.
class _LanguageExample {
  final String tag;
  final String name;
  final String code;

  const _LanguageExample(this.tag, this.name, this.code);
}

const List<_LanguageExample> _examples = [
  _LanguageExample('dart', 'Dart / Flutter', r'''
/// A greeting card.
class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Hello, $name!',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}'''),
  _LanguageExample('bash', 'Bash', r'''
#!/bin/bash
# Deploy the current build.
export TARGET="releases/$USER/$1"
if [ -z "$1" ]; then
  echo 'usage: deploy <version>' --help
  exit 1
fi
function cleanup() { local tmp="$TMPDIR"; rm -rf "$tmp"; }'''),
  _LanguageExample('json', 'JSON', r'''
{
  // JSONC comments are supported too
  "name": "flutter_carbon",
  "version": "2.0.0",
  "materialFree": true,
  "widgets": 48,
  "homepage": null
}'''),
  _LanguageExample('python', 'Python', r'''
# Fibonacci with memoization.
from functools import cache

@cache
def fib(n: int) -> int:
    """Return the n-th Fibonacci number."""
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)

print(f"fib(10) = {fib(10)}")'''),
  _LanguageExample('js', 'JavaScript', r'''
/** Fetch a user by id. */
export async function getUser(id) {
  const res = await fetch(`/api/users/${id}`);
  if (!res.ok) throw new Error("not found");
  return res.json() ?? null;
}'''),
  _LanguageExample('ts', 'TypeScript', r'''
interface Repo<T> {
  readonly name: string;
  find(id: number): T | undefined;
}

type Keys = keyof Repo<unknown>;
const empty = { name: "carbon" } satisfies Partial<Repo<never>>;'''),
  _LanguageExample('c', 'C', r'''
#include <stdio.h>
#define GREETING "hello"

int main(void) {
  const char *name = "carbon";
  char initial = 'c';
  /* classic */
  printf("%s, %s! (%c)\n", GREETING, name, initial);
  return 0;
}'''),
  _LanguageExample('cpp', 'C++', r'''
/// A 2-D point.
namespace geo {
template <typename T>
class Point {
 public:
  constexpr Point(T x, T y) : x_(x), y_(y) {}
  auto scaled(double k) const {
    return Point(static_cast<T>(x_ * k), static_cast<T>(y_ * k));
  }
 private:
  T x_, y_;
};
}  // namespace geo'''),
  _LanguageExample('java', 'Java', r'''
/** An inclusive integer range. */
public record Range(int lo, int hi) {
  @Override
  public String toString() {
    if (lo > hi) throw new IllegalStateException("inverted");
    return lo + ".." + hi;
  }
}'''),
  _LanguageExample('cs', 'C#', r'''
#region Models
/// A user account.
[Serializable]
public sealed record User(string Name)
{
    public override string ToString() => $"user {Name}";
    private static readonly string Root = @"C:\data\users";
    public bool Valid => Name is not null;
}
#endregion'''),
  _LanguageExample('rust', 'Rust', r'''
/// Borrowed name holder.
#[derive(Debug, Clone)]
pub struct Ids<'a> {
    name: &'a str,
}

fn main() {
    let ids = Ids { name: "carbon" };
    let raw = r#"raw "quoted" text"#;
    println!("{:?} {}", ids, raw);
}'''),
  _LanguageExample('go', 'Go', r'''
package main

import "fmt"

func main() {
	query := `SELECT id, name
FROM users`
	if err := run(query); err != nil {
		fmt.Println("failed:", err)
	}
	const max int = 10
	_ = max
}'''),
  _LanguageExample('php', 'PHP', r'''
<?php
#[Attribute]
class Greeter {
    public function greet(string $name): string {
        $greeting = "hello $name";
        // single quotes stay literal
        $literal = 'raw $name';
        return $greeting . ' / ' . $literal;
    }
}
?>'''),
];

/// Demo page for Carbon syntax highlighting — the language gallery.
class SyntaxHighlightingDemoPage extends StatelessWidget {
  const SyntaxHighlightingDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return DemoPageTemplate(
      title: 'Syntax Highlighting',
      description:
          'The built-in highlighters — one per language, resolved from a '
          'Markdown fence tag via carbonHighlighterFor. Colors come from '
          'the carbon.syntax theme tokens.',
      sections: [
        for (final example in _examples)
          DemoSection(
            title: example.name,
            description: "carbonHighlighterFor('${example.tag}')",
            builder: (context) => CarbonCodeSnippet(
              code: example.code.trim(),
              type: CarbonCodeSnippetType.multi,
              highlighter: carbonHighlighterFor(example.tag),
            ),
          ),
        DemoSection(
          title: 'Syntax Color Reference',
          description: 'A sample of the carbon.syntax token palette',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _ColorSwatch('Keyword', carbon.syntax.syntaxKeyword),
              _ColorSwatch('Control', carbon.syntax.syntaxControlKeyword),
              _ColorSwatch(
                'Definition',
                carbon.syntax.syntaxDefinitionKeyword,
              ),
              _ColorSwatch('String', carbon.syntax.syntaxString),
              _ColorSwatch('Escape/Interp.', carbon.syntax.syntaxEscape),
              _ColorSwatch('Comment', carbon.syntax.syntaxComment),
              _ColorSwatch('Doc Comment', carbon.syntax.syntaxDocComment),
              _ColorSwatch('Type', carbon.syntax.syntaxTypeName),
              _ColorSwatch('Attribute', carbon.syntax.syntaxAttributeName),
              _ColorSwatch('Property', carbon.syntax.syntaxPropertyName),
              _ColorSwatch('Variable', carbon.syntax.syntaxVariableName),
              _ColorSwatch('Macro', carbon.syntax.syntaxMacroName),
              _ColorSwatch('Number', carbon.syntax.syntaxNumber),
              _ColorSwatch('Boolean', carbon.syntax.syntaxBool),
              _ColorSwatch('Null', carbon.syntax.syntaxNull),
              _ColorSwatch('Tag', carbon.syntax.syntaxTag),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorSwatch(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: carbon.layer.layer02,
        border: Border.all(color: carbon.layer.borderSubtle01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: carbon.text.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
