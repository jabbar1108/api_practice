import 'package:flutter/material.dart';

import 'models/todo.dart';

class FetchDataWidget extends StatefulWidget {
  const FetchDataWidget(
      {super.key,
      required this.futureTodo,
      this.completedTasks = false,
      this.notCompletedTasks = false});

  final Future<List<Todo>> futureTodo;
  final bool completedTasks;
  final bool notCompletedTasks;

  @override
  State<FetchDataWidget> createState() => _FetchDataWidgetState();
}

class _FetchDataWidgetState extends State<FetchDataWidget> {
  final List<Todo> completedTasks = [];
  final List<Todo> notCompletedTasks = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: widget.futureTodo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (widget.completedTasks) {
            for (var todo in snapshot.data!) {
              if (todo.isCompleted) {
                completedTasks.add(todo);
              }
            }
            return ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      completedTasks[index].title,
                    ),
                    trailing: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                  );
                });
          } else if (widget.notCompletedTasks) {
            for (var todo in snapshot.data!) {
              if (!todo.isCompleted) {
                notCompletedTasks.add(todo);
              }
            }
            return ListView.builder(
                itemCount: notCompletedTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      notCompletedTasks[index].title,
                    ),
                    trailing: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  );
                });
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      snapshot.data![index].title,
                    ),
                    trailing: snapshot.data![index].isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                  );
                });
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
