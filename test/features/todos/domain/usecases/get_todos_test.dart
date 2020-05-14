import 'package:clean_architecture_app/core/usecases/usecase.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/get_todos.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  final mockTodoRepository = MockTodoRepository();
  final getTodos = GetTodos(mockTodoRepository);

  test("should get all todos from the repository", () async {
    final todos = [
      Todo(description: "aaa", completed: false),
      Todo(description: "bbb", completed: false),
      Todo(description: "ccc", completed: false)
    ];

    when(mockTodoRepository.getTodos()).thenAnswer((_) async => Right(todos));

    final result = await getTodos(NoParams());

    expect(result, equals(Right(todos)));
  });
}
