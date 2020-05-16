import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/mark_todo_as_completed.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  final mockTodoRepository = MockTodoRepository();
  final markAsCompleted = MarkTodoAsCompleted(mockTodoRepository);

  test("should set todo completed property to true and then save it", () async {
    final pendingTodo = Todo(id: 1, description: "foo", completed: false);

    final completedTodo = Todo(id: 1, description: "foo", completed: true);

    when(mockTodoRepository.update(any))
        .thenAnswer((_) async => Right(completedTodo));

    final result = await markAsCompleted(pendingTodo);

    verify(mockTodoRepository.update(any));

    expect(result, equals(Right(completedTodo)));
  });
}
