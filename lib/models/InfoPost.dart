class InfoPost {
  String id = "";
  String title = "";
  String description = "";
  int index = 0;
  bool published = false;
  String image = "";
  int icon = 0;

  InfoPost(
      {this.id = "",
      this.title = "",
      this.description = "",
      this.icon = 0,
      });

  InfoPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['icon'] = this.icon;
    return data;
  }
}
