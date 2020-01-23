import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoPage extends StatelessWidget {
  final String photoUrl;
  PhotoPage(this.photoUrl);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: photoUrl,
      child: Image.network(photoUrl),
    );
  }
}
