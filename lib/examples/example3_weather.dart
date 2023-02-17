import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City {
  tokyo,
  osaka,
  nagoya,
}

typedef WeatherEmoji = String;

// Fetches the weather emoji for the given city.
//
// This function returns a Future<WeatherEmoji> because it is asynchronous.
// It returns the weather emoji as a String. This function will eventually
// return a value, but the return type is Future<WeatherEmoji> rather than
// WeatherEmoji because it is asynchronous, and the value is not available
// immediately.

Future<WeatherEmoji> fetchWeather(City city) async {
  await Future.delayed(const Duration(seconds: 1));
  return {
    City.tokyo: '🌤',
    City.osaka: '🌧',
    City.nagoya: '☀️',
  }[city]!;
}

//UI writes and reads from this
// This provider is used to store the city that the user has selected as
// their current city. It is used to display the current city in the UI.
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '🤷🏾‍♂️';
//UI reads this
// Fetches the weather emoji for the current city, or the unknown weather emoji
// if the current city is null.
final weatherEmojiProvider = FutureProvider<WeatherEmoji>(
  (ref) {
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      return fetchWeather(city);
    } else {
      return unknownWeatherEmoji;
    }
  },
);

class Example3 extends ConsumerWidget {
  const Example3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(weatherEmojiProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            city.when(
              data: (data) => Text(
                'Weather: $data',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              loading: () => const CircularProgressIndicator.adaptive(),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: City.values.length,
                itemBuilder: (context, index) {
                  final isSelected =
                      ref.watch(currentCityProvider) == City.values[index];
                  final city = City.values[index];
                  return ListTile(
                    title: Text(city.toString()),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () =>
                        ref.read(currentCityProvider.notifier).state = city,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
