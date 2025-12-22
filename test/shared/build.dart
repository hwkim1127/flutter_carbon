import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

Widget buildTestApp({required Widget child}) {
  return MaterialApp(
    theme: carbonTheme(carbon: WhiteTheme.theme),
    home: Scaffold(body: child),
  );
}
