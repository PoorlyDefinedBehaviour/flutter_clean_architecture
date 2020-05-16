import 'dart:convert';

import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final localDataSource = TodoLocalDataSourceImpl(mockSharedPreferences);

  group("create", () {
    test(
        "should create a todo locally so it can be synced when the app is online",
        () async {
      final todos = [
        TodoModel(id: 1, description: "a", completed: false),
        TodoModel(id: 2, description: "b", completed: false),
        TodoModel(id: 3, description: "c", completed: false)
      ];

      when(mockSharedPreferences.getString(any)).thenReturn(json.encode(todos));

      final target = todos.elementAt(1);

      await localDataSource.delete(target);

      verify(mockSharedPreferences.setString(
          TODOS_CACHE_KEY,
          json.encode([
            TodoModel(id: 1, description: "a", completed: false),
            TodoModel(id: 3, description: "c", completed: false)
          ])));
    });
  });

  group("getTodos", () {
    test(
        "should return a list of todos from shared preferences when theres cached todos",
        () async {
      final todos = [TodoModel(id: 1, description: "foo", completed: false)];

      when(mockSharedPreferences.getString(any)).thenReturn(json.encode(todos));

      final result = await localDataSource
          .getTodos()
          .then((todos) => todos.fold((l) => null, (r) => r));

      verify(mockSharedPreferences.getString(TODOS_CACHE_KEY));

      expect(listEquals(result, todos), equals(true));
    });

    test("should return CacheFailure when theres nothing in the cache",
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final result = await localDataSource.getTodos();

      expect(result, equals(Left(CacheFailure())));
    });
  });

  group("cacheTodos", () {
    test("should use SharedPreferences to cache a key value pair", () async {
      final todos = [TodoModel(id: 1, description: "foo", completed: false)];

      final expected = json.encode(todos);

      await localDataSource.cacheTodos(todos);

      verify(mockSharedPreferences.setString(TODOS_CACHE_KEY, expected));
    });
  });

  group("update", () {
    test(
        "should update a todo locally so it can be synced when the app is online",
        () async {
      final todos = [
        TodoModel(id: 1, description: "a", completed: false),
        TodoModel(id: 2, description: "b", completed: false),
        TodoModel(id: 3, description: "c", completed: false)
      ];

      when(mockSharedPreferences.getString(any)).thenReturn(json.encode(todos));

      final target = TodoModel(id: 2, description: "b", completed: true);

      final result = await localDataSource
          .update(target)
          .then((failureOrTodo) => failureOrTodo.fold((l) => null, (r) => r));

      expect(result, equals(target));
    });
  });

  group("delete", () {
    test(
        "should delete a todo locally so it can be synced when the app is online",
        () async {
      final todos = [
        TodoModel(id: 1, description: "a", completed: false),
        TodoModel(id: 2, description: "b", completed: false),
        TodoModel(id: 3, description: "c", completed: false)
      ];

      when(mockSharedPreferences.getString(any)).thenReturn(json.encode(todos));

      final target = todos.elementAt(1);

      await localDataSource.delete(target);

      verify(mockSharedPreferences.setString(
          TODOS_CACHE_KEY,
          json.encode([
            TodoModel(id: 1, description: "a", completed: false),
            TodoModel(id: 3, description: "c", completed: false)
          ])));
    });
  });
}
