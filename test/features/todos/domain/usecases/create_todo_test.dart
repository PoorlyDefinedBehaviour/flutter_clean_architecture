import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/get_todos.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  final mockTodoRepository = MockTodoRepository();
  final createTodo = CreateTodo(mockTodoRepository);

  test("should get all todos from the repository", () async {
    when(mockTodoRepository.createTodo(any)).thenAnswer(Right);

    final result = await createTodo("test todo");

    expect(result, equals(Right(Todo("test todo"))));
  });
}
