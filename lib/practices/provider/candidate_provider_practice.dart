// ccreate a class
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PACList {
  final List<PACriteria> paCriteria;

  PACList({
    required this.paCriteria,
  });

  @override
  String toString() => 'PACList(paCriteria: $paCriteria)';

  PACList.fromJson(Map<String, dynamic> json)
      : paCriteria = (json['paCriteria'] as List)
            .map((e) => PACriteria.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        'paCriteria': paCriteria.map((e) => e.toJson()).toList(),
      };
}

class PACriteria {
  final String name;
  final String description;
  final String id;
  final String type;
  final String year;

  PACriteria(
    this.name,
    this.description,
    this.id,
    this.type,
    this.year,
  );

  @override
  String toString() =>
      'PACriteria(name: $name, description: $description, id: $id, type: $type, year: $year)';

  PACriteria.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        id = json['id'],
        type = json['type'],
        year = json['year'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'type': type,
        'year': year,
      };
}

//create a provider
final paCriteriaProvider = Provider<List<PACriteria>>(
  (ref) => PACList.fromJson(rawJson).paCriteria,
);

//create a map of raw json
Map<String, dynamic> rawJson = {
  "state": "success",
  "paCriteria": [
    {
      "name": "Jacob Smith",
      "description":
          "Eiusmod magna ea ea quis ut aliqua ipsum. Ut occaecat eu duis commodo sunt non sunt ex enim. Est anim sint Lorem in do dolore deserunt commodo ut ad in. Adipisicing labore quis irure excepteur cupidatat adipisicing ipsum deserunt. Lorem commodo sunt ex nulla fugiat velit deserunt do reprehenderit veniam tempor mollit enim. Ex fugiat nisi Lorem occaecat nisi eiusmod enim incididunt. Cillum minim aute dolor labore amet officia deserunt laboris.",
      "id": "1",
      "type": "Good",
      "year": "2020"
    },
    {
      "name": "Lucas Johnson",
      "description":
          "Sint quis aute cupidatat aliqua eu nisi qui ex commodo cupidatat. Sunt et ex mollit id reprehenderit voluptate amet. Enim duis officia labore anim reprehenderit. Aute dolore nostrud ullamco non fugiat et eu culpa ad cupidatat sint ad. Est exercitation in tempor in. Et incididunt ea aute id proident.",
      "id": "2",
      "type": "Not Bad",
      "year": "2024"
    }
  ],
};

class PACriteriaProviderPractice extends ConsumerWidget {
  const PACriteriaProviderPractice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paCriteria = ref.watch(paCriteriaProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      title: 'PACriteria',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PACriteria'),
        ),
        body: ListView.builder(
          itemCount: paCriteria.length,
          itemBuilder: (context, index) {
            final pa = paCriteria[index];
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(pa.name),
                      Text(pa.description),
                      Text(pa.id),
                      Text(pa.type),
                      Text(pa.year),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print(pa);
                    }
                  },
                  child: const Text('Print'),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
