import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
  Future<Either<Failure, Todo>> create(final String description);
}
