
class Event {
  String id = "";
  String title = "";
  String description = "";
  String location = "";
  DateTime? startTime;
  DateTime? endTime;
  String image = "";
  String artist = "";

  Event({
    this.id = "",
    this.title = "",
    this.startTime,
    this.endTime,
    this.location = "",
    this.image = "",
    this.description = "",
    this.artist = "",
  });

  factory Event.fromJson(Map<String, dynamic> json){
    var startTime = json['startTime'].runtimeType == String
        ? DateTime.parse(json['startTime'])
        : null;
    var endTime = json['endTime'].runtimeType == String
        ? DateTime.parse(json['endTime'])
        : null;

    return Event(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      location: json['location'] ?? "",
      startTime: startTime ?? DateTime.now(),
      endTime: endTime ?? DateTime.now(),
      image: json['image'] ?? "",
      artist: json['artist'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
      'image': image,
      'artist': artist
    };
  }
}
