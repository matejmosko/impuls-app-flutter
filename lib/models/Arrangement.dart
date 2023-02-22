class Arrangement {
  String id = "";
  String title = "";
  String location = "";
  DateTime? startTime;
  DateTime? endTime;
  String imgUrl = "";

  Arrangement({
    this.id = "",
    this.title = "",
    this.startTime,
    this.endTime,
    this.location = "",
    this.imgUrl = "",
  });

  factory Arrangement.fromJson(Map<String, dynamic> json) {
    var startTime = json['startTime'].runtimeType == String
        ? DateTime.parse(json['startTime'])
        : null;
    var endTime = json['endTime'].runtimeType == String
        ? DateTime.parse(json['endTime'])
        : null;

    return Arrangement(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      startTime: startTime,
      endTime: endTime,
      imgUrl: json['imgUrl'] as String,
    );
  }
}
