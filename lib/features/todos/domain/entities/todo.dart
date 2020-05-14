import "package:equatable/equatable.dart";
import "package:meta/meta.dart";

class Todo extends Equatable {
  final String description;
  final bool completed;

  Todo({@required this.description, @required this.completed})
      : super([description, completed]);
}
