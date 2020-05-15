import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import "package:meta/meta.dart";

class TodoModel extends Todo {
  TodoModel({@required String description, @required bool completed})
      : super(description: description, completed: completed);

  factory TodoModel.fromJson(final Map<String, dynamic> json) =>
      TodoModel(description: json["description"], completed: json['completed']);

  Map<String, dynamic> toJson() =>
      {"description": description, "completed": completed};
}
