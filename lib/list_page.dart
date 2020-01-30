import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_gallery/photo_page.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List photoDetailsList = [];

  @override
  void didChangeDependencies() {
    photoDetailsList.forEach((photo) =>
        precacheImage(NetworkImage(photo['urls']['regular'].image), context));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            print('project snapshot data is: ${snapshot.data}');
            return Container();
          }
          return StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: photoDetailsList.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PhotoPage(photoDetailsList[index]['urls']['regular']),
                ),
              ),
              child: Hero(
                tag: photoDetailsList[index]['urls']['regular'],
                child: Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  photoDetailsList[index]['urls']['regular']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(photoDetailsList[index]['user']
                                ['username'] ??
                            'User ${index + 1}'),
                        subtitle: Text(photoDetailsList[index]['description'] ??
                            (photoDetailsList[index]['alt_description'] ??
                                'Description #${index + 1}')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(2, index.isEven ? 4 : 2),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );
        },
        future: getPhotosInfo(),
      ),
    );
  }

  Future getPhotosInfo() async {
    var url =
        'https://api.unsplash.com/photos/?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0';

    var response = await http.get(url);

    if (response.statusCode == 200 && photoDetailsList.isEmpty) {
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse.forEach((item) => photoDetailsList.add(item));
    }
  }
}
