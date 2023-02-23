import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Define a StateNotifier for the counter, which extends from the StateNotifier class
// provided by Riverpod, with the type parameter of `int?`.
class Counter extends StateNotifier<int?> {
  // In the constructor, initialize the state to `null`.
  Counter() : super(null);

  // Define a method to increment the counter, which checks if the current state is null
  // and initializes it to 1 if it is, otherwise increments the current state by 1.
  void increment() => state = state == null ? 1 : state! + 1;
}

// Define a StateNotifierProvider with the type parameter of `Counter` and `int?`.
final counterProvider =
    StateNotifierProvider<Counter, int?>((ref) => Counter());

// Define a ConsumerWidget named `BasicCounterStateNotifer`.
class BasicCounterStateNotifer extends ConsumerWidget {
  const BasicCounterStateNotifer({super.key});

  // Implement the `build` method to build the UI.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Return a MaterialApp widget with a title, debug banner, and themes.
    return MaterialApp(
      title: 'Counter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      // Create a Scaffold widget with an AppBar and a body containing a Column
      // widget with a Text widget and a Consumer widget.
      home: Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You have pushed the button this many times:'),
              // Use a Consumer widget to rebuild the Text widget whenever the
              // state of the counterProvider changes.
              Consumer(
                builder: (context, watch, _) {
                  final count = ref.watch(counterProvider);
                  final nullCheck =
                      count ?? 'Press the button to start counting';
                  return Text(
                    '$nullCheck',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
            ],
          ),
        ),
        // Add a FloatingActionButton with an onPressed callback to increment the
        // counter and an Icon widget as its child.
        floatingActionButton: FloatingActionButton(
          onPressed: () => ref.read(counterProvider.notifier).increment(),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
