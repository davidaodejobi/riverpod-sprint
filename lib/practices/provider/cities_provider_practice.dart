import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// A simple data class to hold information about a city
class City {
  final String name;
  final String timezone;

  City({
    required this.name,
    required this.timezone,
  });
}

// Create a Provider that provides a List of cities
final citiesProvider = Provider<List<City>>(
  (ref) => [
    City(name: 'New York', timezone: 'UTC-5'),
    City(name: 'Los Angeles', timezone: 'UTC-8'),
    City(name: 'London', timezone: 'UTC+0'),
    City(name: 'Sydney', timezone: 'UTC+11'),
  ],
);

// A widget that uses the citiesProvider to display a list of cities
class CitiesProvider extends ConsumerWidget {
  const CitiesProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the list of cities from the citiesProvider
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
