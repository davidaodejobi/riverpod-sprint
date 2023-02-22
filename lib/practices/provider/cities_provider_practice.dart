import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class City {
  final String name;
  final String timezone;

  City({
    required this.name,
    required this.timezone,
  });
}

final citiesProvider = Provider<List<City>>(
  (ref) => [
    City(name: 'New York', timezone: 'UTC-5'),
    City(name: 'Los Angeles', timezone: 'UTC-8'),
    City(name: 'London', timezone: 'UTC+0'),
    City(name: 'Sydney', timezone: 'UTC+11'),
  ],
);

class CitiesProvider extends ConsumerWidget {
  const CitiesProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(citiesProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      title: 'Cities',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cities'),
        ),
        body: ListView.builder(
          itemCount: cities.length,
          itemBuilder: (context, index) {
            final city = cities[index];
            return ListTile(
              title: Text(city.name),
              subtitle: Text(city.timezone),
            );
          },
        ),
      ),
    );
  }
}
