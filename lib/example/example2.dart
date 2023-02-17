import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Example2 extends ConsumerWidget {
  const Example2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Example 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Consumer(
              builder: (context, ref, child) {
                final count = ref.watch(counterProvider);
                final text = count == null ? 'Press the button' : '$count';
                return Text(
                  text,
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).increment(),
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
}

final counterProvider =
    StateNotifierProvider<Counter, int?>((ref) => Counter());

// extension OptionalInfixAdditional<T extends num> on T? {
//   T? operator +(T? other) => this != null ? this + (other ?? 0) as T : null;
// }

extension OptionalInfixAdditional<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow == null) {
      return null;
    } else {
      return shadow + (other ?? 0) as T;
    }
  }
}
