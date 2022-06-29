import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.amber,
            child: CachedNetworkImage(
              imageUrl: 'https://www.scenickazatva.eu/2022/wp-content/uploads/2022/05/sz-typo-twist.png',
            ),
          ),
        ],
      ),
    );
  }
}
