import 'dart:convert';

import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TodoLocalDataSource {
  Future<Either<Failure, List<TodoModel>>> getTodos();
  Future<void> cacheTodos(final List<TodoModel> todos);
}

const TODOS_CACHE_KEY = "cache@todos";

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheTodos(List<TodoModel> todos) {
    return sharedPreferences.setString(TODOS_CACHE_KEY, json.encode(todos));
  }

  @override
  Future<Either<Failure, List<TodoModel>>> getTodos() {
    final todos = sharedPreferences.getString(TODOS_CACHE_KEY);

    return Future.value(todos == null
        ? Left(CacheFailure())
        : Right(json
            .decode(todos)
            .map((todoJson) => TodoModel.fromJson(todoJson))
            .toList()));
  }
}
