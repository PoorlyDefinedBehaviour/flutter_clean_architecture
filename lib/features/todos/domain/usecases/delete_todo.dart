import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/core/usecases/usecase.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteTodo implements UseCase<void, Todo> {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  @override
  Future<Either<Failure, void>> call(Todo todo) => repository.delete(todo);
}
