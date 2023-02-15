import 'package:flutter/material.dart';

// Built using https://m3.material.io/theme-builder#/custom

Color darkColor = Colors.black87;
Color darkColorLighter = Colors.blueGrey;
Color lightColor = Colors.white;
Color lightColorDarker = Color(0xFFF0F0F0);
Color accentColor = Color(0xffdf9f4a);
Color accentColorDarker = Color(0xFF855400);
Color lightColorTransparent = Colors.white54;

var lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: accentColor,
  onPrimary: darkColor,
  primaryContainer: lightColor,
  onPrimaryContainer: darkColor,
  secondary: darkColor,
  onSecondary: accentColor,
  secondaryContainer: accentColor,
  onSecondaryContainer: darkColor,
  tertiary: lightColor,
  onTertiary: darkColor,
  tertiaryContainer: lightColor,
  onTertiaryContainer: darkColor,
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: lightColorDarker,
  onBackground: darkColor,
  surface: lightColor,
  onSurface: darkColor,
  surfaceVariant: lightColorDarker,
  onSurfaceVariant: darkColorLighter,
  outline: darkColorLighter,
  onInverseSurface: lightColorDarker,
  inverseSurface: accentColor,
  inversePrimary: darkColor,
  shadow: Color(0xFF000000),
  surfaceTint: lightColor,
  outlineVariant: accentColor,
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB95D),
  onPrimary: Color(0xFF462A00),
  primaryContainer: Color(0xFF653E00),
  onPrimaryContainer: Color(0xFFFFDDB7),
  secondary: Color(0xFF4FD8EB),
  onSecondary: Color(0xFF00363D),
  secondaryContainer: Color(0xFF004F58),
  onSecondaryContainer: Color(0xFF97F0FF),
  tertiary: Color(0xFFFFB1C8),
  onTertiary: Color(0xFF5E1133),
  tertiaryContainer: Color(0xFF7B2949),
  onTertiaryContainer: Color(0xFFFFD9E2),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF3E0021),
  onBackground: Color(0xFFFFD9E4),
  surface: Color(0xFF3E0021),
  onSurface: Color(0xFFFFD9E4),
  surfaceVariant: Color(0xFF504539),
  onSurfaceVariant: Color(0xFFD4C4B5),
  outline: Color(0xFF9C8E80),
  onInverseSurface: Color(0xFF3E0021),
  inverseSurface: Color(0xFFFFD9E4),
  inversePrimary: Color(0xFF855400),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFB95D),
  outlineVariant: Color(0xFF504539),
  scrim: Color(0xFF000000),
);