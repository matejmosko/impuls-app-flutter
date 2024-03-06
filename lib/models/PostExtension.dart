import 'package:wordpress_client/wordpress_client.dart';

extension FeaturedImage on Post{
  String featuredImageSourceUrl(){
      return this["_embedded"]["wp:featuredmedia"][0]["source_url"];
  }
}