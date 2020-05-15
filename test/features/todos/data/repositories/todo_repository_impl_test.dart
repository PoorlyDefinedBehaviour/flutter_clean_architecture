import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/core/network/network_info.dart';
import 'package:clean_architecture_app/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:clean_architecture_app/features/todos/data/datasources/todo_remote_data_source.dart';
import 'package:clean_architecture_app/features/todos/data/models/todo.dart';
import 'package:clean_architecture_app/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:clean_architecture_app/features/todos/domain/entities/todo.dart';
import 'package:dartz/dartz.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:mockito/mockito.dart';
import 'package:flutter/foundation.dart';

class MockTodoRemoteDataSource extends Mock implements TodoRemoteDataSource {}

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  final mockTodoRemoteDataSource = MockTodoRemoteDataSource();
  final mockTodoLocalDataSource = MockTodoLocalDataSource();
  final mockNetworkInfo = MockNetworkInfo();
  final repository = TodoRepositoryImpl(
      remoteDataSource: mockTodoRemoteDataSource,
      localDataSource: mockTodoLocalDataSource,
      networkInfo: mockNetworkInfo);

  group("getTodos", () {
    test("should check if device is online", () async {
      when(mockTodoRemoteDataSource.getTodos())
          .thenAnswer((_) async => Right([]));

      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

      await repository.getTodos();

      verify(mockNetworkInfo.isConnected());
    });

    group("device is online", () {
      setUp(() =>
          when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true));

      test("should return todos from remote data source when device is online",
          () async {
        when(mockTodoRemoteDataSource.getTodos()).thenAnswer((_) async =>
            Right([TodoModel(description: "foo", completed: false)]));

        final expected = [Todo(description: "foo", completed: false)];

        final result = await repository
            .getTodos()
            .then((todos) => todos.fold((l) => null, (r) => r));

        expect(listEquals(result, expected), true);
      });

      test("should return Left(Failure) when remove call fails", () async {
        clearInteractions(mockTodoLocalDataSource);

        when(mockTodoRemoteDataSource.getTodos())
            .thenAnswer((_) async => Left(ServerFailure()));

        final result = await repository.getTodos();

        verifyZeroInteractions(mockTodoLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });

    group("device is offline", () {
      setUp(() =>
          when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false));
      test(
          "should return cached todos when theres no connection and theres cached todos",
          () async {
        clearInteractions(mockTodoRemoteDataSource);

        when(mockTodoLocalDataSource.getTodos()).thenAnswer((_) async =>
            Right([TodoModel(description: "foo", completed: false)]));

        final expected = [Todo(description: "foo", completed: false)];

        final result = await repository
            .getTodos()
            .then((todos) => todos.fold((l) => null, (r) => r));

        verifyZeroInteractions(mockTodoRemoteDataSource);

        verify(mockTodoLocalDataSource.getTodos());

        expect(listEquals(result, expected), true);
      });

      test(
          "should return CacheFailure todos when theres no connection and theres no cached todos",
          () async {
        when(mockTodoLocalDataSource.getTodos())
            .thenAnswer((_) async => Left(CacheFailure()));

        final result = await repository.getTodos();

        verifyZeroInteractions(mockTodoRemoteDataSource);

        verify(mockTodoLocalDataSource.getTodos());

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
