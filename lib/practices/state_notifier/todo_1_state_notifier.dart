import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {
  final String title;

  Todo({required this.title});
}

class StateNotifierTodoList extends StateNotifier<List<Todo>> {
  StateNotifierTodoList() : super([]);

  void add(String title) {
    state = [...state, Todo(title: title)];
  }

  void remove(Todo todo) {
    state = state.where((t) => t != todo).toList();
  }
}

/// Todo is a simple class that represents a single
/// todo item with a title property.

/// TodoList is a StateNotifier that manages a list of Todo items.
/// It provides two methods, add and remove, to add and
/// remove Todo items from the list.

final todoProvider = StateNotifierProvider<StateNotifierTodoList, List<Todo>?>(
  (ref) => StateNotifierTodoList(),
);

/// StateNotifierTodo is a ConsumerWidget that displays the todo
/// list and provides a form to add new items to the list.

class StateNotifierTodo extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  StateNotifierTodo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'State Notifier Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Todo App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer(builder: (context, ref, _) {
                  final todos = ref.watch(todoProvider);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: todos!.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return ListTile(
                          title: Text(todo.title),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref.read(todoProvider.notifier).remove(todo);
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Add a task',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a task';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(todoProvider.notifier)
                                .add(_textController.text);
                            _textController.clear();
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
