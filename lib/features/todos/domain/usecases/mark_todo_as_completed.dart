import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/core/usecases/usecase.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:dartz/dartz.dart';

class MarkTodoAsCompleted implements UseCase<Todo, Todo> {
  final TodoRepository repository;

  MarkTodoAsCompleted(this.repository);

  @override
  Future<Either<Failure, Todo>> call(Todo params) {
    final completedTodo =
        Todo(id: params.id, description: params.description, completed: true);

    return repository.update(completedTodo);
  }
}
