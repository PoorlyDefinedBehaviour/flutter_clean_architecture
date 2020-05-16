import 'dart:convert';

import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import "package:flutter_test/flutter_test.dart";

import '../../../../fixtures/fixture_reader.dart';

void main() {
  test("should be subclass of Todo", () {
    expect(TodoModel(id: 1, description: "foo", completed: false), isA<Todo>());
  });

  group("fromJson", () {
    test("should return a todo model created from json contents", () {
      final todoJson = json.decode(fixture("test/fixtures/todo.json"));

      final expected = TodoModel(
          id: todoJson["id"],
          description: todoJson['description'],
          completed: todoJson['completed']);

      expect(TodoModel.fromJson(todoJson), equals(expected));
    });
  });

  group("toJson", () {
    test("should return Map<String, dynamic>", () {
      final expected = {"id": 1, "description": "foo", "completed": false};

      final result =
          TodoModel(id: 1, description: "foo", completed: false).toJson();

      expect(result, equals(expected));
    });
  });

  group("fromTodo", () {
    test("should return a TodoModel created from a todo", () {
      final todo = Todo(id: 1, description: "foo", completed: false);

      final expected = TodoModel(
          id: todo.id,
          description: todo.description,
          completed: todo.completed);

      final result = TodoModel.fromTodo(todo);

      expect(result, equals(expected));
    });
  });
}
