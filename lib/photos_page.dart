import 'dart:convert';

import 'package:api_practice/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos() async {
  final response =
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

  if (response.statusCode == 200) {
    List<dynamic> res = jsonDecode(response.body);
    List<Photo> photos = [];

    for (var photo in res) {
      photos.add(Photo.fromJson(photo));
    }

    return photos;
  } else {
    return throw Exception("Could not load photos");
  }
}

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key, required this.albumId});

  final int albumId;

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  late final Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurePhotos = fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Available photos"),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          }),
        ),
        body: Center(
          child: FutureBuilder(
            future: futurePhotos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Photo> photos = snapshot.data!;
                photos = photos.where((element) => element.albumId == widget.albumId).toList();
                // photos.map((photo) {
                //   if(photo.albumId == widget.albumId) {
                //     print(photo.albumId == widget.albumId);
                //     return photo;
                //   }
                // }).toList();
                // print(photos);
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return Image.network(photos[index].url);
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
