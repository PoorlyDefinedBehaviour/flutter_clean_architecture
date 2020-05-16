import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import "package:meta/meta.dart";

class TodoModel extends Todo {
  TodoModel(
      {@required int id,
      @required String description,
      @required bool completed})
      : super(id: id, description: description, completed: completed);

  factory TodoModel.fromJson(final Map<String, dynamic> json) => TodoModel(
      id: json["id"],
      description: json["description"],
      completed: json['completed']);

  Map<String, dynamic> toJson() =>
      {"id": id, "description": description, "completed": completed};

  factory TodoModel.fromTodo(final Todo todo) => TodoModel(
      id: todo.id, description: todo.description, completed: todo.completed);
}
