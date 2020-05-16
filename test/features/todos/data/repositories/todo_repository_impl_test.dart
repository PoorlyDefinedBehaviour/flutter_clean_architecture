import 'dart:convert';

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

import '../../../../fixtures/fixture_reader.dart';

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

  group("create", () {
    group("device is online", () {
      test("should create todo using the remote data source", () async {
        clearInteractions(mockTodoLocalDataSource);

        when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

        final todoModel =
            TodoModel.fromJson(json.decode(fixture("test/fixtures/todo.json")));

        final expected = Todo(
            id: todoModel.id,
            description: todoModel.description,
            completed: todoModel.completed);

        when(mockTodoRemoteDataSource.create(expected.description))
            .thenAnswer((_) async => Right(todoModel));

        await repository.create(expected.description);

        verifyZeroInteractions(mockTodoLocalDataSource);

        verify(mockTodoRemoteDataSource.create(expected.description));
      });
    });

    group("device is offline", () {
      test("should create todo using the local data source", () async {
        clearInteractions(mockTodoRemoteDataSource);

        when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

        final todoModel =
            TodoModel.fromJson(json.decode(fixture("test/fixtures/todo.json")));

        final expected = Todo(
            id: todoModel.id,
            description: todoModel.description,
            completed: todoModel.completed);

        when(mockTodoLocalDataSource.create(expected.description))
            .thenAnswer((_) async => Right(todoModel));

        await repository.create(expected.description);

        verifyZeroInteractions(mockTodoRemoteDataSource);

        verify(mockTodoLocalDataSource.create(expected.description));
      });
    });
  });

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
            Right([TodoModel(id: 1, description: "foo", completed: false)]));

        final expected = [Todo(id: 1, description: "foo", completed: false)];

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
            Right([TodoModel(id: 1, description: "foo", completed: false)]));

        final expected = [Todo(id: 1, description: "foo", completed: false)];

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

  group("update", () {
    group("device is online", () {
      test("should update todo when connected to internet", () async {
        clearInteractions(mockTodoLocalDataSource);

        when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

        final todoModel =
            TodoModel.fromJson(json.decode(fixture("test/fixtures/todo.json")));

        final todo = Todo(
            id: todoModel.id,
            description: todoModel.description,
            completed: todoModel.completed);

        when(mockTodoRemoteDataSource.update(todoModel))
            .thenAnswer((_) async => Right(todoModel));

        await repository.update(todo);

        verify(mockTodoRemoteDataSource.update(todoModel));

        verifyZeroInteractions(mockTodoLocalDataSource);
      });
    });
  });

  group("device is offline", () {
    test("should update todo locally when not  connected to internet",
        () async {
      clearInteractions(mockTodoRemoteDataSource);

      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

      final todoModel =
          TodoModel.fromJson(json.decode(fixture("test/fixtures/todo.json")));

      final todo = Todo(
          id: todoModel.id,
          description: todoModel.description,
          completed: todoModel.completed);

      when(mockTodoLocalDataSource.update(todoModel))
          .thenAnswer((_) async => Right(todoModel));

      await repository.update(todo);

      verify(mockTodoLocalDataSource.update(todoModel));

      verifyZeroInteractions(mockTodoRemoteDataSource);
    });
  });

  group("delete", () {
    group("device is online", () {
      test("should delete todo when connected to internet", () async {
        when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

        final todo =
            TodoModel.fromJson(json.decode(fixture("test/fixtures/todo.json")));

        when(mockTodoRemoteDataSource.delete(todo))
            .thenAnswer((_) async => Right(null));

        final result = await repository.delete(todo);

        verify(mockTodoRemoteDataSource.delete(todo));

        expect(result, equals(Right(null)));
      });
    });
  });

  group("device is offline", () {
    test("should delete todo locally when not connected to internet", () async {
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

      final todo =
          TodoModel.fromJson(json.decode(fixture("test/fixtures/todo.json")));

      when(mockTodoLocalDataSource.delete(todo))
          .thenAnswer((_) async => Right(null));

      final result = await repository.delete(todo);

      verify(mockTodoLocalDataSource.delete(todo));

      expect(result, equals(Right(null)));
    });
  });
}
