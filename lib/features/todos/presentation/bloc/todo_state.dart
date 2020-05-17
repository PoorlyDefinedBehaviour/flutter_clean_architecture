part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class FetchingTodos extends TodoState {
  @override
  List<Object> get props => [];
}

class TodosFetched extends TodoState {
  final List<Todo> todos;

  TodosFetched(this.todos);

  @override
  List<Object> get props => [];
}
