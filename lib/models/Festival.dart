class Festival {
  DateTime? endDate;
  String magazine_src = "https://javisko.sk/wp-json/wp/v2/posts?per_page=20&order=desc&";
  String news_src = "https://www.tvor-ba.sk/2024/wp-json/wp/v2/posts?per_page=20&order=desc&";
  DateTime? startDate;
  String subtitle = "Multižánrový festival tvorivosti";
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
    var endDate = DateTime(
        json["endDate"].year, json["endDate"].month, json["endDate"].day);
    var startDate = DateTime(
        json["startDate"].year, json["startDate"].month, json["startDate"].day);

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
    data['endDate'] = this.endDate;
    data['magazine_src'] = this.magazine_src;
    data['news_src'] = this.magazine_src;
    data['startDate'] = this.startDate;
    data['subtitle'] = this.subtitle;
    data['title'] = this.title;
    return data;
  }
}
