import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  @override
  TodoState get initialState => TodoInitial();

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
