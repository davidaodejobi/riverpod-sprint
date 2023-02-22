import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'practices/provider/config_provider_practice.dart';

void main() {
  runApp(const ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ConfigProviderPractice();
  }
}
