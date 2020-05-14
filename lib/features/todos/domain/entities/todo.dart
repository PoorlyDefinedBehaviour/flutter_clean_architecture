import "package:equatable/equatable.dart";

class Todo extends Equatable {
  final String description;
  bool completed = false;

  Todo(this.description) 
    : super([description, completed])
}