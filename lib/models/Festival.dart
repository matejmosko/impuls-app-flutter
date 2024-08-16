import 'package:hive/hive.dart';
part 'Festival.g.dart';

@HiveType(typeId: 1)
class Festival {
  @HiveField(0)
  DateTime? endDate;
  @HiveField(1)
  String magazine_src =
      "https://javisko.sk/wp-json/wp/v2/posts?per_page=20&order=desc&";
  @HiveField(2)
  String news_src =
      "https://www.tvor-ba.sk/2024/wp-json/wp/v2/posts?per_page=20&order=desc&";
  @HiveField(3)
  DateTime? startDate;
  @HiveField(4)
  String subtitle = "Multižánrový festival tvorivosti";
  @HiveField(5)
  String title = "TVOR•BA 2024";
  @HiveField(6)
  String backgroundColor;
  @HiveField(7)
  String foregroundColor;
  @HiveField(8)
  String selectedColor;
  @HiveField(9)
  String mainProgramColor;
  @HiveField(10)
  String offProgramColor;
  @HiveField(11)
  String logo;
  @HiveField(12)
  String background;

  Festival(
      {this.endDate,
      this.magazine_src =
          "https://javisko.sk/wp-json/wp/v2/posts?per_page=20&order=desc&",
      this.news_src =
          "https://www.tvor-ba.sk/2024/wp-json/wp/v2/posts?per_page=20&order=desc&",
      this.startDate,
      this.subtitle = "Multižánrový festival tvorivosti",
      this.title = "TVOR•BA 2024",
      this.backgroundColor = "ffffffff",
      this.foregroundColor = "ff000000",
      this.selectedColor = "ff888888",
      this.mainProgramColor = "ffffffff",
      this.offProgramColor = "ffffffff",
      this.logo = "gs://scenickazatva-343517.appspot.com/default.png",
      this.background = "gs://scenickazatva-343517.appspot.com/default.png"});

  factory Festival.fromJson(Map<String, dynamic> json) {
    //Map<String, dynamic> festivals = jsonDecode(json['festivals'] ?? {});

    var startDate = DateTime.parse(json['startdate']);
    var endDate = DateTime.parse(json['enddate']);

    return Festival(
        endDate: endDate,
        magazine_src: json['magazine_src'],
        news_src: json['news_src'],
        startDate: startDate,
        subtitle: json['subtitle'],
        title: json['title'],
        backgroundColor: json['backgroundColor'],
        foregroundColor: json['foregroundColor'],
        selectedColor: json['selectedColor'],
        mainProgramColor: json['mainProgramColor'],
        offProgramColor: json['offProgramColor'],
        logo: json['logo'],
        background: json['background']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enddate'] = this.endDate;
    data['magazine_src'] = this.magazine_src;
    data['news_src'] = this.magazine_src;
    data['startdate'] = this.startDate;
    data['subtitle'] = this.subtitle;
    data['title'] = this.title;
    data['backgroundColor'] = this.backgroundColor;
    data['foregroundColor'] = this.foregroundColor;
    data['selectedColor'] = this.selectedColor;
    data['mainProgramColor'] = this.mainProgramColor;
    data['offProgramColor'] = this.offProgramColor;
    data['logo'] = this.logo;
    data['background'] = this.background;
    return data;
  }
}
