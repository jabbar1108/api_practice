import 'dart:convert';

import 'package:api_practice/models/album.dart';
import 'package:api_practice/photos_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Album>> fetchAlbums() async {
  final response =
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/albums"));

  if (response.statusCode == 200) {
    List<dynamic> fetchData = jsonDecode(response.body);
    List<Album> albums = [];

    for (var album in fetchData) {
      albums.add(Album.fromJson(album));
    }
    return albums;
  } else {
    return throw Exception("Could not load albums");
  }
}

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late Future<List<Album>> fetchData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Albums"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          }
        ),
      ),
      body: Center(
        child: FutureBuilder(
            future: fetchData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotosPage(albumId: snapshot.data![index].id)));
                        },
                        child: Card(
                          elevation: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Album ${index + 1}. ${snapshot.data![index].title}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
