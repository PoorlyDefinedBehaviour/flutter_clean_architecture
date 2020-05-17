import 'dart:convert';

import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TodoLocalDataSource {
  Future<Either<Failure, List<TodoModel>>> getTodos();
  Future<Either<Failure, TodoModel>> create(final String description);
  Future<void> cacheTodos(final List<TodoModel> todos);
  Future<Either<Failure, TodoModel>> update(TodoModel todo);
  Future<Either<Failure, void>> delete(TodoModel todo);
}

const TODOS_CACHE_KEY = "cache@todos";

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    sharedPreferences.setString(
      TODOS_CACHE_KEY,
      json.encode(todos),
    );
  }

  @override
  Future<Either<Failure, TodoModel>> create(String description) {
    return getTodos().then(
      (failureOrTodos) => failureOrTodos.map(
        (todos) {
          final highestId = todos.fold(
              0,
              (previousValue, element) =>
                  previousValue > element.id ? previousValue : element.id);

          final todo = TodoModel(
            id: highestId + 1,
            description: description,
            completed: false,
          );

          cacheTodos([...todos, todo]);

          return todo;
        },
      ),
    );
  }

  @override
  Future<Either<Failure, List<TodoModel>>> getTodos() {
    final cachedTodos = sharedPreferences.getString(TODOS_CACHE_KEY);

    if (cachedTodos == null) {
      return Future.value(Left(CacheFailure()));
    }

    List<dynamic> todosJson = json.decode(cachedTodos);

    final todos = todosJson.map((todo) => TodoModel.fromJson(todo)).toList();

    return Future.value(Right(todos));
  }

  @override
  Future<Either<Failure, TodoModel>> update(TodoModel todo) async {
    final todos = await getTodos();

    return todos
        .map((todos) => todos.map((t) => t.id == todo.id ? todo : t).toList())
        .fold(
            (cacheFailure) => Future.value(Left(cacheFailure)),
            (todos) =>
                cacheTodos(todos).then((_) => Future.value(Right(todo))));
  }

  @override
  Future<Either<Failure, void>> delete(TodoModel todo) =>
      getTodos().then((failureOrTodos) => failureOrTodos.map(
          (todos) => cacheTodos(todos.where((t) => t.id != todo.id).toList())));
}
