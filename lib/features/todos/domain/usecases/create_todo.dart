import 'package:clean_architecture_app/core/usecases/usecase.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:clean_architecture_app/features/todos/domain/repositories/todo_repository.dart';

class CreateTodo implements UseCase<Todo, NoParams> {
  final TodoRepository repository;

  CreateTodo(this.repository);

  @override
  Future<Either<Failure, List<Todo>>> call(Params description) =>
      repository.create(description);
}
