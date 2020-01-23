import 'package:flutter/material.dart';
import 'package:unsplash_gallery/list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
