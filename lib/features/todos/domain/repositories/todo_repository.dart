import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, Todo>> create(final String description);
  Future<Either<Failure, Todo>> update(final Todo todo);
  Future<Either<Failure, void>> delete(final Todo todo);
}
