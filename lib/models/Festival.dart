import 'package:hive/hive.dart';
part 'Festival.g.dart';

@HiveType(typeId : 1)
class Festival {
  @HiveField(0)
  DateTime? endDate;
  @HiveField(1)
  String magazine_src = "https://javisko.sk/wp-json/wp/v2/posts?per_page=20&order=desc&";
  @HiveField(2)
  String news_src = "https://www.tvor-ba.sk/2024/wp-json/wp/v2/posts?per_page=20&order=desc&";
  @HiveField(3)
  DateTime? startDate;
  @HiveField(4)
  String subtitle = "Multižánrový festival tvorivosti";
  @HiveField(5)
  String title = "TVOR•BA 2024";

  Festival({
    this.endDate,
    this.magazine_src = "https://javisko.sk/wp-json/wp/v2/posts?per_page=20&order=desc&",
    this.news_src = "https://www.tvor-ba.sk/2024/wp-json/wp/v2/posts?per_page=20&order=desc&",
    this.startDate,
    this.subtitle = "Multižánrový festival tvorivosti",
    this.title = "TVOR•BA 2024",
  });

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
    return data;
  }
}
