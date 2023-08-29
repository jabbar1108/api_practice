class Todo {
  Todo({required this.id, required this.userId, required this.title, required this.isCompleted});

  final int id;
  final int userId;
  final String title;
  final bool isCompleted;

  Todo.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      userId = json['userId'],
      title = json['title'],
      isCompleted = json['completed'];

}
