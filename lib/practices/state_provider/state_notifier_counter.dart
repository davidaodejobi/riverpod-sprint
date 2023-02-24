// Import necessary packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Create a state provider for count, initialized to 0
final countProvider = StateProvider((ref) => 0);

// Create a widget that uses the count provider
class StateProviderCounter extends ConsumerWidget {
  const StateProviderCounter({super.key});

  // Build the UI of the widget
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      // Set the app title and theme
      title: 'State Provider Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        // Set the app bar title
        appBar: AppBar(
          title: const Text('Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the count value
              const Text(
                'Count:',
              ),
              Consumer(builder: (context, watch, child) {
                // Read the count provider
                final count = ref.watch(countProvider);
                // Display the count value as text
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              }),
            ],
          ),
        ),
        // Add a button to increment the count
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Increment the count when the button is pressed
            ref.read(countProvider.notifier).state++;
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
