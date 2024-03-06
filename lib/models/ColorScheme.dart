import 'package:flutter/material.dart';

// Built using https://m3.material.io/theme-builder#/custom

/*
* každé pozadie (aj fialové aj biele) zmeniť na farbu: #FBFCFB / rgb(251, 252, 251) - celý web/appka budú biele so zelenými zvýrazneniami a grafikou.
Tam kde je potrebné zvýraznenie (tlačidlá, orámovania…) zmeniť na farbu: #66CC33 / rgb(102, 204, 51).
Tam kde je potrebné farebne odlíšiť pozadie (program napr.) striedajme prosím tieto farby: #A3E085 / rgb(163, 224, 133), #C8EDB6 / rgb(200, 237, 182), #E9F8E2 / rgb(233, 248, 226), #EDF9E7 / rgb(237, 249, 231).
Tam kde bude potrebné zvýrazniť aj inak ako hlavnou zelenou farbou (#66CC33) tak prosím použite farbu modrú #4C33CC / rgb(76, 51, 204).
* */

Color darkColor = Colors.black87;
Color darkColorLighter = Colors.black54;
Color lightColor = Colors.white;
Color lightColorDarker = Color(0xFBFCFBFF);
Color accentColor = Color(0xff66CC33);
Color accentColorDarker = Color(0xbb66CC33);
Color lightColorTransparent = Colors.white54;

var lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: lightColorDarker,
  onPrimary: darkColor,
  primaryContainer: lightColorDarker,
  onPrimaryContainer: darkColor,
  secondary: lightColorDarker,
  onSecondary: darkColor,
  secondaryContainer: accentColor,
  onSecondaryContainer: lightColorDarker,
  tertiary: lightColorDarker,
  onTertiary: darkColorLighter,
  tertiaryContainer: lightColorDarker,
  onTertiaryContainer: darkColor,
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: lightColorDarker,
  onBackground: darkColor,
  surface: lightColorDarker,
  onSurface: darkColor,
  surfaceVariant: lightColorDarker,
  onSurfaceVariant: darkColorLighter,
  outline: darkColorLighter,
  onInverseSurface: lightColorDarker,
  inverseSurface: accentColorDarker,
  inversePrimary: darkColor,
  shadow: Color(0xFF000000),
  surfaceTint: lightColorDarker,
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
  onSurfaceVariant: darkColorLighter,
  outline: darkColorLighter,
  onInverseSurface: lightColorDarker,
  inverseSurface: accentColorDarker,
  inversePrimary: darkColor,
  shadow: Color(0xFF000000),
  surfaceTint: lightColor,
  outlineVariant: accentColor,
  scrim: Color(0xFF000000),
);

/* Color darkColor = Colors.black87;
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
  onSurfaceVariant: darkColorLighter,
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
  onSurfaceVariant: darkColorLighter,
  outline: darkColorLighter,
  onInverseSurface: lightColorDarker,
  inverseSurface: accentColorDarker,
  inversePrimary: darkColor,
  shadow: Color(0xFF000000),
  surfaceTint: lightColor,
  outlineVariant: accentColor,
  scrim: Color(0xFF000000),
);
 */