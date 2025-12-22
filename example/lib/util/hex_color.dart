import 'package:flutter/material.dart';

/// Utility extension to display colors as Hex strings.
extension HexColor on Color {
  String toHexString() {
    // ignore: deprecated_member_use
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
