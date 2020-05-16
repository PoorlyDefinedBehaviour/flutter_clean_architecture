import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRemoteDataSource {
  Future<Either<Failure, List<TodoModel>>> getTodos();
  Future<Either<Failure, TodoModel>> create(final String description);
  Future<Either<Failure, TodoModel>> update(TodoModel todo);
  Future<Either<Failure, void>> delete(TodoModel todo);
}
