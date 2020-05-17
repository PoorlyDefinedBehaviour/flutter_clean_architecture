import 'package:clean_architecture_app/core/network/network_info.dart';
import 'package:clean_architecture_app/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:clean_architecture_app/features/todos/data/datasources/todo_remote_data_source.dart';
import 'package:clean_architecture_app/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/create_todo.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/delete_todo.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/get_todos.dart';
import 'package:clean_architecture_app/features/todos/domain/usecases/mark_todo_as_completed.dart';
import 'package:clean_architecture_app/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

Future<TodoBloc> todoBlocComposer() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  final todoRepository = TodoRepositoryImpl(
      remoteDataSource: TodoRemoteDataSourceImpl(),
      localDataSource: TodoLocalDataSourceImpl(sharedPreferences),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()));

  return TodoBloc(
    createTodo: CreateTodo(
      todoRepository,
    ),
    getTodos: GetTodos(
      todoRepository,
    ),
    markTodoAsCompleted: MarkTodoAsCompleted(
      todoRepository,
    ),
    deleteTodo: DeleteTodo(todoRepository),
  );
}
