import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the v2 invariant: everything except the explicit Material bridge
/// (`lib/material.dart` + `lib/src/material/`) is Material-free.
void main() {
  test('package (minus the bridge) has no material/cupertino imports', () {
    const guardedDirs = [
      'lib/src/theme',
      'lib/src/foundation',
      'lib/src/base',
      'lib/src/app',
      'lib/src/text',
      'lib/src/widgets',
      'lib/src/icons',
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
