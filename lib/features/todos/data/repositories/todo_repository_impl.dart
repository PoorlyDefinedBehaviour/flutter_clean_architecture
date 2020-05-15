import 'package:clean_architecture_app/core/network/network_info.dart';
import 'package:clean_architecture_app/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:clean_architecture_app/features/todos/data/datasources/todo_remote_data_source.dart';
import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';
import 'package:dartz/dartz.dart';
import "package:meta/meta.dart";

Todo _fromTodoModel(final TodoModel todo) =>
    Todo(description: todo.description, completed: todo.completed);

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, Todo>> create(final String description) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    final isConnected = await networkInfo.isConnected();

    if (!isConnected) {
      return localDataSource.getTodos().then((failureOrTodos) =>
          failureOrTodos.map((todos) => todos.map(_fromTodoModel).toList()));
    }

    final failureOrTodos = await remoteDataSource.getTodos();

    return failureOrTodos.map((ts) {
      localDataSource.cacheTodos(ts);
      return ts.map(_fromTodoModel).toList();
    });
  }
}
