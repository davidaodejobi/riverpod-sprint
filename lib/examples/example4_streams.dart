import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<String> names = [
  //generate 20 real names
  'John',
  'Paul',
  'George',
  'Ringo',
  'Pete',
  'Bola',
  'Grace',
];

/// This code creates a new StreamProvider that will emit a new value every second.
/// The value will be the number of seconds since the stream was created.
final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (x) => x + 1,
  ),
);

// This code takes the current tick count from the ticker provider and
// chooses a name from the list of names. It uses the tick count as an index
// into the list of names.
final nameProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (event) => event <= 10 ? names[event % names.length] : names[-1],
      ),
);

class Example4Streams extends ConsumerWidget {
  const Example4Streams({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      //genrate a random scaffold color every second
      backgroundColor: ref.watch(tickerProvider).when(
            data: (value) => Colors.primaries[value % Colors.primaries.length],
            loading: () => Colors.blueGrey,
            error: (error, stack) => Colors.white,
          ),
      appBar: AppBar(
        title: const Text('Streams'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Seconds since app started:',
                style: TextStyle(fontSize: 20)),
            ref.watch(tickerProvider).when(
                  data: (value) => Text(
                    value.toString(),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text(
                    error.toString(),
                  ),
                ),
            const SizedBox(height: 20),
            const Text(
              'Name:',
              style: TextStyle(fontSize: 20),
            ),
            ref.watch(nameProvider).when(
                  data: (value) => Text(
                    value,
                    style: const TextStyle(fontSize: 30),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => const Text(
                    'That is all folks! 🥹',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
