import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/core/failures.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<Either<Failure, Todo> getTodos();
  Future<Either<Failure, Todo> create(String description);
}