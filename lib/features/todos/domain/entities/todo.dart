import "package:equatable/equatable.dart";
import "package:meta/meta.dart";

class Todo extends Equatable {
  final int id;
  final String description;
  final bool completed;

  Todo(
      {@required this.id,
      @required this.description,
      @required this.completed});

  @override
  List<Object> get props => [id, description, completed];
}
