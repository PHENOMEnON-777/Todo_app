import 'package:blocprojects/data/model/todo.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'todo_event.dart';
part 'todo_state.dart';


class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitialState()) {
    on<TodoInitial>(
      (event, emit) {
        emit(FetchingTodo(state.todos));
        try {
          final listOfTodos = state.todos;
          emit(FetchingTodoSuccessful(listOfTodos));
        } catch (e) {
          emit(const FetchingTodoError(errorMessage: 'errorMessage'));
        }
      },
    );

    on<AddTodo>((event, emit) {
      emit(AddingTodo(state.todos));
      try {
        final todo = event.todo;
        state.todos.add(todo);
        emit(AddingTodoSucces(
            successfulmessage: 'successfulmessage', todos: state.todos));
      } catch (e) {
        emit(const AddingTodoFailure(errorMessage: 'errorMessage'));
      }
    });

    on<DeleteTodo>((event, emit) {
      emit(DelitingTodo(state.todos));
      try {
        state.todos.removeWhere((todo) => todo.id == event.todoId);
        emit(DelitingTodoSucces(
            successfulmessage: 'successfulmessage', todos: state.todos));
      } catch (e) {
        emit(const DelitingTodoFailure(errorMessage: 'errorMessage'));
      }
    });

    on<UpdateTodo>((event, emit) {
      emit(UpdatingTodo(state.todos));
      try {
        for (var i = 0; i < state.todos.length; i++) {
          if (event.todo.id == state.todos[i].id) {
            state.todos[i] = event.todo;
            break; // Exit loop once the item is found and updated
          }
        }
        emit(
          UpdatingTodoSucces(
            successfulmessage: 'successfulmessage',
            todos: state.todos,
          ),
        );
      } catch (e) {
        emit(
          const UpdatingTodoFailure(
            errorMessage: 'Update failed',
          ),
        );
      }
    });
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {


    print('......Generating object............');
    

    if (json['todos'] != null) {
      final todosJson = json['todos'] as List<String>;
      // print(json['todos']);
      // print(todosJson);
      final todos = todosJson.map((todoStr) => Todo.fromJson(todoStr)).toList();
      print(todos);
      // print(todoss);
      return FetchingTodoSuccessful(todos);
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {


    print('......Destructuring object............');


    if (state is AddingTodoSucces) {
      print(state.todos.map((todo) => todo.toMap()).toList());
      return {
        
        'todos': state.todos.map((todo) => todo.toJson()).toList(),
      };
    }
    if (state is DelitingTodoSucces) {
      print(state.todos.map((todo) => todo.toMap()).toList());

      return {
        'todos': state.todos.map((todo) => todo.toJson()).toList(),
      };
    }
    if (state is UpdatingTodoSucces) {
      print('updating');
      print(state.todos.map((todo) => todo.toMap()).toList());

      return {
        'todos': state.todos.map((todo) => todo.toJson()).toList(),
      };
    }
    if (state is FetchingTodoSuccessful) {
      print('fetching');
      print(state.todos.map((todo) => todo.toMap()).toList() );

      return {
        'todos': state.todos.map((todo) => todo.toJson()).toList(),
      };
    }
    return null;
  }

  // @override
  // TodoState? fromJson(Map<String, dynamic> json) {
  //   print('......Generating object............');
  //   if (json['todos'] != null) {
  //     final todosJson = json['todos'] as List<dynamic>;
  //     print(todosJson);
  //     final todos = todosJson.map((todoMap) => Todo.fromMap(todoMap as Map<String, dynamic>)).toList();
  //     print(todos);
  //     return FetchingTodoSuccessful(todos);
  //   }
  //   return null;
  // }

  // @override
  // Map<String, dynamic>? toJson(TodoState state) {
  //   print('......Destructuring object............');
  //   if (state is AddingTodoSucces || state is DelitingTodoSucces || state is UpdatingTodoSucces || state is FetchingTodoSuccessful) {
  //     final todos = (state as dynamic).todos;
  //     return {
  //       'todos': todos.map((todo) => todo.toMap()).toList(),
  //     };
  //   }
  //   return null;
  // }

  
}
