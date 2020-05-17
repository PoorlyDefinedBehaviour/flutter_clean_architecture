part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}
