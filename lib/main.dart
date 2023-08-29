import 'dart:async';
import 'dart:convert';

import 'package:api_practice/album_page.dart';
import 'package:api_practice/fetch_data_widget.dart';
import 'package:flutter/material.dart';
import 'models/album.dart';
import 'package:http/http.dart' as http;

import 'models/todo.dart';

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));

  List<Album> albums = [];
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    List<dynamic> res = jsonDecode(response.body);

    for (var album in res) {
      albums.add(Album.fromJson(album));
    }
    return albums;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Todo>> fetchTodos() async {
  final response =
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));

  if (response.statusCode == 200) {
    List<Todo> todos = [];
    List<dynamic> res = jsonDecode(response.body);

    for (var todo in res) {
      todos.add(Todo.fromJson(todo));
    }

    return todos;
  } else {
    return throw Exception("Could not load todos");
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Todo>> futureTodo;
  bool completedTasks = false;
  bool notCompletedTasks = false;

  @override
  void initState() {
    super.initState();
    futureTodo = fetchTodos();
  }

  void _moveToAlbum() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AlbumPage(),
                        ),
                      );
                    },
                    child: const Text("Album"),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            completedTasks = true;
                            notCompletedTasks = false;
                            // print("built again");
                          });
                        },
                        icon: const Icon(Icons.check_circle_rounded),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            notCompletedTasks = true;
                            completedTasks = false;
                            // print("built with outlined");
                          });
                        },
                        icon: const Icon(Icons.cancel),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            notCompletedTasks = false;
                            completedTasks = false;
                            // print("built with outlined");
                          });
                        },
                        icon: const Icon(Icons.notes),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: FetchDataWidget(
                    futureTodo: futureTodo,
                    completedTasks: completedTasks,
                    notCompletedTasks: notCompletedTasks,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
