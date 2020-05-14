import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/core/usecases/usecase.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:dartz/dartz.dart';

class CreateTodo implements UseCase<Todo, String> {
  final TodoRepository repository;

  CreateTodo(this.repository);

  @override
  Future<Either<Failure, Todo>> call(String description) =>
      repository.create(description);
}
