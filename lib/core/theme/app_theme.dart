import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Punkt 10 (obowiązkowy): obsługa dark/light mode - FlexColorScheme.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class AppTheme {
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.mandyRed,
    useMaterial3: true,
    fontFamily: 'Roboto',
  );

  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.mandyRed,
    useMaterial3: true,
    fontFamily: 'Roboto',
  );
}
