import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/create_todo.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/delete_todo.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/get_todos.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/mark_todo_as_completed.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  GetTodos getTodos;
  CreateTodo createTodo;
  MarkTodoAsCompleted markTodoAsCompleted;
  DeleteTodo deleteTodo;

  TodoBloc(
      {@required this.getTodos,
      @required this.createTodo,
      @required this.markTodoAsCompleted,
      @required this.deleteTodo});

  @override
  TodoState get initialState => TodoInitial();

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
