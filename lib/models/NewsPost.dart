import 'package:wordpress_client/wordpress_client.dart';

class NewsPost extends Post{
  final String image = "";

  NewsPost({
    required super.id,
    required super.slug,
    required super.status,
    required super.link,
    required super.author,
    required super.commentStatus,
    required super.pingStatus,
    required super.sticky,
    required super.format,
    required super.self,
   // this.image = "",
});

/*
  factory NewsPost.fromJson(Map<String, dynamic> json) {
    return NewsPost(
    super.id,
    super.slug,
    super.status,
    super.link,
    super.author,
    super.commentStatus,
    super.pingStatus,
    super.sticky,
    super.format,
    super.self,
    image = json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? "";
  }
*/
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
   // data['arrangement'] = this.arrangement;
    return data;
  }
}
