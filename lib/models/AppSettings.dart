import 'dart:convert';
import 'package:scenickazatva_app/models/Festival.dart';

class AppSettings {
  String defaultfestival = "tvorba2024";
  Map<String, Festival>? festivals = {};

  AppSettings({
    this.defaultfestival = "tvorba2024",
    this.festivals = const {},
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> f =
        jsonDecode(json["festivals"]) as Map<String, Festival>;
    Map<String, Festival> festivals = {};

    f.forEach((key, value) {
      festivals[key] = Festival.fromJson(value);
    });

    return AppSettings(
      defaultfestival: json['defaultfestival'] ?? "tvorba2024",
      festivals: festivals,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['defaultfestival'] = this.defaultfestival;
    data['festivals'] = this.festivals;
    return data;
  }
}
