import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Define a StateNotifierProvider called countProvider that creates and manages a CountNotifier
final countProvider =
    StateNotifierProvider<CountNotifier, int>((ref) => CountNotifier());

// Define a CountNotifier that extends StateNotifier<int> and has two methods to increment and decrement the count
class CountNotifier extends StateNotifier<int> {
  CountNotifier() : super(0);

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

// Create a ConsumerWidget that uses countProvider to read and display the count, and to increment and decrement it with FloatingActionButton buttons
class StateNotifierCounter2 extends ConsumerWidget {
  const StateNotifierCounter2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'State Notifier Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Count:',
              ),
              // Use ref.watch() to read the count from countProvider and display it with Text widget
              Text(
                ref.watch(countProvider).toString(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Use ref.read() to access the CountNotifier's increment() method and update the count when the '+' button is pressed
            FloatingActionButton(
              onPressed: () {
                ref.read(countProvider.notifier).increment();
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            // Use ref.read() to access the CountNotifier's decrement() method and update the count when the '-' button is pressed
            FloatingActionButton(
              onPressed: () {
                ref.read(countProvider.notifier).decrement();
              },
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
