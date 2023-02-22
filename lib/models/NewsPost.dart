class NewsPost {
  int id = 0;
  String title = "";
  String description = "";
  String content = "";
  String location = "";
  String publishTime = "";
  String image = "";

  NewsPost(
      {this.id = 0,
      this.title = "",
      this.description = "",
      this.content = "",
      this.location = "",
      this.publishTime = "",
      this.image = "",
    });

  NewsPost.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title']['rendered'] ?? "";
    description = json['excerpt']['rendered'] ?? "";
    content = json['content']['rendered'] ?? "";
    location = json['format'] ?? "";
    publishTime = json['date'] ?? "";
    image = json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content;
    data['location'] = this.location;
    data['publishTime'] = this.publishTime;
    data['image'] = this.image;
   // data['arrangement'] = this.arrangement;
    return data;
  }
}
