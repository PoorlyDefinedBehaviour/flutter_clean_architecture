import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRemoteDataSource {
  Future<Either<Failure, List<TodoModel>>> getTodos();
  Future<Either<Failure, TodoModel>> create(final String description);
}
