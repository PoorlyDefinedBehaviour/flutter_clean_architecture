import 'package:clean_architecture_app/core/failures.dart';
import 'package:clean_architecture_app/core/usecases/usecase.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';

class GetTodos implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repository;

  GetTodos(this.repository)

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams _) => repository.getTodos();
}