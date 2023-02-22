import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

///Firstly create a `Config` class which will hold our static configuration data:
class Config {
  final String apiUrl;
  final String apiKey;

  Config({required this.apiUrl, required this.apiKey});
}

/// Next step is create a basic provider for this `Config` class using the `Provider` constructor:
final configProvider = Provider<Config>((ref) {
  return Config(apiUrl: 'https://api.example.com', apiKey: 'my_api_key');
});

/// Now we can use this `configProvider` to inject the `Config` instance into any part of our app:
class ConfigProviderPractice extends ConsumerWidget {
  const ConfigProviderPractice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      title: 'Config Provider Practice',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
        ),
        body: Center(
          child: Text('API URL: ${config.apiUrl}\nAPI Key: ${config.apiKey}'),
        ),
      ),
    );
  }
}
