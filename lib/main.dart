import 'package:blocprojects/data/model/todo.dart';
import 'package:blocprojects/logic/blocs/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 final Storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

      
  HydratedBloc.storage = Storage;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 156, 23, 180)),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print('object');
    // context.read<TodoBloc>().add(TodoInitial());
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mytodo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is AddingTodoSucces || state is UpdatingTodoSucces) {
              Navigator.of(context).pop();
            }
          },
          builder:  (context, state) {
            if (state is FetchingTodoError) {
              return AlertDialog(
                content: Text(state.errorMessage),
                title: const Text('fetching error'),
              );
            }
            if (state is FetchingTodo) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FetchingTodoSuccessful) {
              return TodosWidget(tododata: state.todos);
            }
            
            if (state is AddingTodoSucces) {
              return TodosWidget(tododata: state.todos);
            }
            if (state is DelitingTodoSucces) {
              return TodosWidget(tododata: state.todos);
            }
            if (state is UpdatingTodoSucces) {
              return TodosWidget(tododata: state.todos);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController titleController = TextEditingController();
                TextEditingController subtitleController = TextEditingController();

                return TodoDialog(
                    titleController: titleController,
                    subtitleController: subtitleController);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoDialog extends StatelessWidget {
  const TodoDialog({
    super.key,
    required this.titleController,
    required this.subtitleController,
    this.todo,
    this.id,
  });

  final TextEditingController titleController;
  final TextEditingController subtitleController;
  final Todo? todo;
  final String? id;

  @override
  Widget build(BuildContext context) {
    final bool isEditing = id != null;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: titleController,
          ),
          const SizedBox(
            height: 9,
          ),
          TextField(
            controller: subtitleController,
          ),
          const SizedBox(
            height: 9,
          ),
          IconButton(
              onPressed: () {
                final todo = Todo(
                      id: isEditing ? id! : DateTime.now().toString(),
                    title: titleController.text,
                    subtitle: subtitleController.text);
                    if(isEditing){
                      context.read<TodoBloc>().add(UpdateTodo(todo));
                    }
                    else{
                      context.read<TodoBloc>().add(AddTodo(todo));

                    }
                     

                // BlocProvider.of<TodoBloc>(context).add(AddTodo(todo));
              },
              icon: isEditing ? const Text('update') : const Icon(Icons.add))
        ],
      ),
    );
  }
}

class TodosWidget extends StatelessWidget {
  final List<Todo> tododata;
  const TodosWidget({
    super.key,
    required this.tododata,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tododata.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(tododata[index].title!),
            subtitle: Text(tododata[index].subtitle!),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        final todoId = tododata[index].id;
                        context.read<TodoBloc>().add(DeleteTodo(todoId!));
                      },
                      icon: const Icon(Icons.delete)),
                  IconButton(
                      onPressed: () {
                        final todoId = tododata[index].id;
                        final title = tododata[index].title;
                        final subtitle = tododata[index].subtitle;
                        TextEditingController titleController =
                            TextEditingController(text: title);
                        TextEditingController subtitleController =
                            TextEditingController(text: subtitle);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return TodoDialog(
                                  id: todoId,
                                  titleController: titleController,
                                  subtitleController: subtitleController);
                            });
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
            ),
          ));
        });
  }
}
