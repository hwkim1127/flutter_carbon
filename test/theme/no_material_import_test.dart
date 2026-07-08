import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the v2.0 invariant: the theming core is Material-free.
///
/// Full package-wide Material freedom waits for the native primitives
/// (Phase 2/3 of doc/V2_ROADMAP.md); until then only `lib/src/widgets`
/// and `lib/src/material` may import Material.
void main() {
  test('theming core has no material/cupertino imports', () {
    const guardedDirs = [
      'lib/src/theme',
      'lib/src/foundation',
      'lib/src/base',
      'lib/src/app',
    ];
    final offenders = <String>[];

    for (final dir in guardedDirs) {
      final directory = Directory(dir);
      expect(directory.existsSync(), isTrue, reason: '$dir should exist');
      for (final entity in directory.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final source = entity.readAsStringSync();
        if (source.contains('package:flutter/material.dart') ||
            source.contains('package:flutter/cupertino.dart')) {
          offenders.add(entity.path);
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason: 'These core files import material/cupertino: $offenders',
    );
  });
}
