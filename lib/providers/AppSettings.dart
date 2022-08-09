import 'package:flutter/material.dart';

var userData;

class Venues {
  Map Locations = {
    "Štúdio": {"color": Colors.orangeAccent, "icon": Icons.corporate_fare, "name": "Štúdio SKD"},
    "ND": {"color": Colors.brown, "icon": Icons.house, "name": "Národný dom"},
    "Záhrada": {"color": Colors.greenAccent, "icon": Icons.grass, "name": "Záhrada SNM"},
    "BM": {"color": Colors.deepPurple, "icon": Icons.museum, "name": "BarMuseum"},
    "Stan": {"color": Colors.blueAccent, "icon": Icons.storefront, "name": "Modrý stan"},
    "Námestie": {"color": Colors.blueAccent, "icon": Icons.panorama_horizontal_rounded, "name": "Divadelné námestie"},
    "default": {"color": Colors.grey, "icon": Icons.reduce_capacity_rounded, "name": ""}
  };

  Venues() {
    getColor("default");
    getIcon("default");
  }
  Color getColor(String loc) {
    return Locations[loc] !=null ? Locations[loc]["color"] : Locations["default"]["color"];
  }

  IconData getIcon(String loc) {
    return Locations[loc] !=null ? Locations[loc]["icon"] : Locations["default"]["icon"];
  }

  String getName(String loc) {
    return Locations[loc] !=null ? Locations[loc]["name"] : loc;
  }
}

class ColorProvider extends ChangeNotifier {
  static Color themeDark = Color(0xff021f2d);
  static Color themeDarker = Color(0xff000d14);
  static Color themeLight = Color(0xffffd8d1);

  Color _mainColor = themeDark;
  Color _secondaryColor = themeLight;
  Color _textColor = themeLight;

  Color get mainColor => _mainColor;

  Color get secondaryColor => _secondaryColor;

  bool _isLightThemeActive = true;

  bool get isLightThemeActive => _isLightThemeActive;

  Color get textColor => _textColor;

  setLightTheme() {
    _isLightThemeActive = true;
    _mainColor = themeDark;
    _secondaryColor = themeLight;
    notifyListeners();
  }

  setDarkTheme() {
    _isLightThemeActive = false;
    _mainColor = themeDark;
    _secondaryColor = themeDarker;
    notifyListeners();
  }

  toggleTheme() {
    if (_isLightThemeActive) {
      setDarkTheme();
    } else {
      setLightTheme();
    }
  }
}
