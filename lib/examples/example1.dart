import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final Provider<DateTime> dateTimeProvider = Provider((ref) => DateTime.now());

//another way to write the same thing
//? final dateTimeProvider = Provider<DateTime>((ref) => DateTime.now());
//? final dateTimeProvider = Provider((ref) => DateTime.now());
class Home extends ConsumerWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTime = ref.watch(dateTimeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Example 1'),
      ),
      body: Center(
        child: Text(dateTime.toIso8601String()),
      ),
    );
  }
}
