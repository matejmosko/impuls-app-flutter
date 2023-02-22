class Location {
  String id;
  String displayName;
  String description;
  String address;
  String city;
  String longitude;
  String latitude;
  int icon;
  String color;

  Location(
      {this.id = "",
      this.displayName = "",
      this.description = "",
      this.address = "",
      this.longitude = "",
        this.city = "",
      this.latitude = "",
      this.icon = 0,
        this.color = ""});

  Location.fromData(Map<String, dynamic> data)
      : id = data['id'],
        displayName = data['displayName'] ?? "",
        description = data['description'] ?? "",
        address = data['address'] ?? "",
        city = data['city'] ?? "",
        longitude = data['longitude'] ?? "",
        latitude = data['latitude'] ?? "",
        icon = data['icon'] ?? 0,
        color = data['color'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'description': description,
      'address': address,
      'city': city,
      'longitude': longitude,
      'latitude': latitude,
      'icon': icon,
      'color': color
    };
  }
}
