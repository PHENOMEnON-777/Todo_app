part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  final List<Todo> todos;

  const TodoState(this.todos);

  @override
  List<Object> get props => [todos];
}

class TodoInitialState extends TodoState {
  TodoInitialState() : super([]);
}

class FetchingTodo extends TodoState {
  const FetchingTodo(super.todos);
}

class FetchingTodoSuccessful extends TodoState {
  const FetchingTodoSuccessful(super.todos);
}

class FetchingTodoError extends TodoState {
  final String errorMessage;

  const FetchingTodoError({required this.errorMessage}) : super(const []);

  @override
  List<Object> get props => [errorMessage, ...super.props];
}

class AddingTodo extends TodoState {
  const AddingTodo(super.todos);
}

class AddingTodoSucces extends TodoState {
  final String successfulmessage;

  const AddingTodoSucces({required this.successfulmessage, required List<Todo> todos}) : super(todos);

  @override
  List<Object> get props => [successfulmessage, ...super.props];
}

class AddingTodoFailure extends TodoState {
  final String errorMessage;

  const AddingTodoFailure({required this.errorMessage}) : super(const []);

  @override
  List<Object> get props => [errorMessage, ...super.props];
}

class DelitingTodo extends TodoState {
  const DelitingTodo(super.todos);
}

class DelitingTodoSucces extends TodoState {
  final String successfulmessage;

  const DelitingTodoSucces({required this.successfulmessage, required List<Todo> todos}) : super(todos);

  @override
  List<Object> get props => [successfulmessage, ...super.props];
}

class DelitingTodoFailure extends TodoState {
  final String errorMessage;

  const DelitingTodoFailure({required this.errorMessage}) : super(const []);

  @override
  List<Object> get props => [errorMessage, ...super.props];
}

class UpdatingTodo extends TodoState {
  const UpdatingTodo(super.todos);
}

class UpdatingTodoSucces extends TodoState {
  final String successfulmessage;

  const UpdatingTodoSucces({required this.successfulmessage, required List<Todo> todos}) : super(todos);

  @override
  List<Object> get props => [successfulmessage, ...super.props];
}

class UpdatingTodoFailure extends TodoState {
  final String errorMessage;

  const UpdatingTodoFailure({required this.errorMessage}) : super(const []);

  @override
  List<Object> get props => [errorMessage, ...super.props];
}
