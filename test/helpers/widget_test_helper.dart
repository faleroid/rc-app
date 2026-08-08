import 'package:flutter/material.dart';

/// Helper for wrapping widgets in MaterialApp for Widget Testing
Widget createWidgetUnderTest(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: Material(
      child: child,
    ),
  );
}
