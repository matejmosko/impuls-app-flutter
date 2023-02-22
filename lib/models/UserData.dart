class UserData {
  String id = "";
  String fullName = "";
  String email = "";
  String userRole = "";
  late Map? notifications;
  String timestamp = "";
  String fcmtoken = "";

  UserData(
      {this.id = "",
      this.fullName = "",
      this.email = "",
      this.userRole = "",
      this.notifications,
      this.timestamp = "",
      this.fcmtoken = ""});

  UserData.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        userRole = data['userRole'],
        notifications = data['notifications'],
        timestamp = data['timestamp'],
        fcmtoken = data['fcmtoken'];

  Map<String, dynamic> toJson() {
    return {
      'id': id != null ? id : "",
      'fullName': fullName != null ? fullName : "",
      'email': email != null ? email : "",
      'userRole': userRole != null ? userRole : "user",
      'notifications': notifications != null ? notifications : {},
      'timestamp': timestamp != null ? timestamp : "",
      'fcmtoken': fcmtoken != null ? fcmtoken : ""
    };
  }
}
