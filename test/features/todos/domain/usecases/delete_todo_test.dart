import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/delete_todo.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  final mockTodoRepository = MockTodoRepository();
  final deleteTodo = DeleteTodo(mockTodoRepository);

  test("should use the repository to delete the todo", () async {
    final todo = Todo(id: 1, description: "foo", completed: true);

    when(mockTodoRepository.delete(todo)).thenAnswer((_) async => Right(null));

    final result = await deleteTodo(todo);

    verify(mockTodoRepository.delete(todo));

    expect(result, equals(Right(null)));
  });
}
