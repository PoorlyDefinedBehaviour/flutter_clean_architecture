import 'dart:convert';

import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import "package:flutter_test/flutter_test.dart";

import '../../../../fixtures/fixture_reader.dart';

void main() {
  test("should be subclass of Todo", () {
    expect(TodoModel(description: "foo", completed: false), isA<Todo>());
  });

  group("fromJson", () {
    test("should return a todo model created from json contents", () {
      final todoJson = json.decode(fixture("test/fixtures/todo.json"));

      final expected = TodoModel(
          description: todoJson['description'],
          completed: todoJson['completed']);

      expect(TodoModel.fromJson(todoJson), equals(expected));
    });
  });

  group("toJson", () {
    test("should return Map<String, dynamic>", () {
      final expected = {"description": "foo", "completed": false};

      final result = TodoModel(description: "foo", completed: false).toJson();

      expect(result, equals(expected));
    });
  });
}
