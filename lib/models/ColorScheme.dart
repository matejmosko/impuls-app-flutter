import 'package:flutter/material.dart';

// Built using https://m3.material.io/theme-builder#/custom

Color darkColor = Colors.black87;
Color darkColorLighter = Colors.blueGrey;
Color lightColor = Colors.white;
Color lightColorDarker = Color(0xFFF0F0F0);
Color accentColor = Color(0xFF18003a);
Color accentColorDarker = Color(0xFF513582);
Color lightColorTransparent = Colors.white54;

var lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: accentColor,
  onPrimary: darkColor,
  primaryContainer: lightColor,
  onPrimaryContainer: darkColor,
  secondary: lightColor,
  onSecondary: darkColor,
  secondaryContainer: accentColor,
  onSecondaryContainer: lightColor,
  tertiary: darkColor,
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
  surfaceVariant: darkColorLighter,
  onSurfaceVariant: lightColorTransparent,
  outline: darkColorLighter,
  onInverseSurface: lightColorDarker,
  inverseSurface: accentColorDarker,
  inversePrimary: darkColor,
  shadow: Color(0xFF000000),
  surfaceTint: lightColor,
  outlineVariant: accentColor,
  scrim: Color(0xFF000000),
);

var darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: accentColor,
  onPrimary: darkColor,
  primaryContainer: darkColor,
  onPrimaryContainer: lightColor,
  secondary: darkColor,
  onSecondary: lightColor,
  secondaryContainer: accentColor,
  onSecondaryContainer: lightColor,
  tertiary: lightColor,
  onTertiary: darkColor,
  tertiaryContainer: lightColor,
  onTertiaryContainer: darkColor,
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: darkColor,
  onBackground: lightColor,
  surface: lightColor,
  onSurface: darkColor,
  surfaceVariant: darkColorLighter,
  onSurfaceVariant: lightColorTransparent,
  outline: darkColorLighter,
  onInverseSurface: lightColorDarker,
  inverseSurface: accentColorDarker,
  inversePrimary: darkColor,
  shadow: Color(0xFF000000),
  surfaceTint: lightColor,
  outlineVariant: accentColor,
  scrim: Color(0xFF000000),
);