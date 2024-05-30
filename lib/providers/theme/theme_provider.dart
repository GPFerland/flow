import 'package:flow/providers/theme/color_provider.dart';
import 'package:flow/providers/theme/dark_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = Provider<ThemeData>((ref) {
  final color = ref.watch(colorProvider);
  final darkMode = ref.watch(darkModeProvider);

  return ThemeData(
    brightness: darkMode ? Brightness.dark : Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: color,
      primary: color,
      brightness: darkMode ? Brightness.dark : Brightness.light,
    ),
  );
});
