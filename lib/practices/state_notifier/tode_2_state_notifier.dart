import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Define a model for the to-do item
class Todo {
  final String title;
  final bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });

  // Define a copyWith method to make it easy to create a new instance of a Todo with
  // updated fields without modifying the original
  Todo copyWith({
    String? title,
    bool? isDone,
  }) {
    return Todo(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

// Define a state notifier to manage the to-do list
class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]);

  /// Define methods to add, remove, and toggle the 'isDone' status of a to-do item

  /// Adds a new Todo item to the list of Todos in the app state
  void add(String title) {
    /// Using the `spread operator`, create a new list that contains all the
    /// elements of the old list plus a new Todo item with the given title
    state = [...state, Todo(title: title)];
  }

  /// Removes a Todo item from the list of Todos in the app state
  void remove(Todo todo) {
    /// Use the `.where()` method to create a new list that only contains the
    /// elements of the old list where the element is not equal to the Todo item
    /// being removed. Then assign this new list to the `app state`.
    state = state.where((t) => t != todo).toList();
  }

  /// Toggles the 'isDone' property of a Todo item in the list of Todos in the app state
  void toggleDone(Todo todo) {
    /// Create a new list by iterating through the old list of Todos and
    /// replacing the Todo item being toggled with a new Todo item that has the
    /// same properties, except with the 'isDone' property flipped.
    /// Then assign this new list to the app state.
    state = [
      for (var t in state)
        if (t == todo) t.copyWith(isDone: !t.isDone) else t
    ];
  }
}

// Define a provider for the to-do list using StateNotifierProvider
final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>(
  (ref) => TodoList(),
);

// Define a widget to display the to-do list
class TodoListWidget extends ConsumerWidget {
  const TodoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retrieve the current state of the to-do list using the 'watch' method of the 'ref' object
    final todoList = ref.watch(todoListProvider);

    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        final todo = todoList[index];
        return Dismissible(
          key: ValueKey(todo),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          // When a to-do item is dismissed, remove it from the list
          onDismissed: (_) => ref.read(todoListProvider.notifier).remove(todo),
          child: ListTile(
            title: Text(
              todo.title,
              style: todo.isDone
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle),
              color: todo.isDone ? Colors.green : null,
              onPressed: () =>
                  ref.read(todoListProvider.notifier).toggleDone(todo),
            ),
            // When a to-do item is long-pressed, remove it from the list
            onLongPress: () => ref.read(todoListProvider.notifier).remove(todo),
          ),
        );
      },
    );
  }
}

// Define a widget to add new to-do items
class AddTodoWidget extends ConsumerStatefulWidget {
  const AddTodoWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTodoWidget> createState() => _AddTodoWidgetState();
}

class _AddTodoWidgetState extends ConsumerState<AddTodoWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Add a new to-do...'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            final title = _controller.text.trim();
            if (title.isNotEmpty) {
              ref.read(todoListProvider.notifier).add(title);
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}

// Define a widget to display the entire to-do list screen
class Todo1StateNotifier extends StatelessWidget {
  const Todo1StateNotifier({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('To-do List'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
            left: 16,
            top: 16,
          ),
          child: Column(
            children: const [
              Expanded(
                child: TodoListWidget(),
              ),
              AddTodoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
