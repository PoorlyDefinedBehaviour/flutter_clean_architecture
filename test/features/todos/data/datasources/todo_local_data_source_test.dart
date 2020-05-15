import 'dart:convert';

import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final localDataSource = TodoLocalDataSourceImpl(mockSharedPreferences);

  group("getTodos", () {
    test(
        "should return a list of todos from shared preferences when theres cached todos",
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture("test/fixtures/todo.json"));

      final expected = [
        TodoModel.fromJson(json.decode(fixture("test/fixtures/todo.json")))
      ];

      final result = await localDataSource
          .getTodos()
          .then((todos) => todos.fold((l) => null, (r) => r));

      verify(mockSharedPreferences.getString(TODOS_CACHE_KEY));

      expect(listEquals(result, expected), equals(true));
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
      final todos = [TodoModel(description: "foo", completed: false)];

      final expected = json.encode(todos);

      await localDataSource.cacheTodos(todos);

      verify(mockSharedPreferences.setString(TODOS_CACHE_KEY, expected));
    });
  });
}
