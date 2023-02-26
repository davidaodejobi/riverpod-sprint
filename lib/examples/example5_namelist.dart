import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  /// : uuid = uuid ?? const Uuid().v4();
  /// A unique identifier for a person. This is used to refer to a person when
  /// talking to the database.
  ///
  /// If a UUID is not provided, then one will be generated.
  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  // This method returns a new Person object with the name and age fields updated.
  // If either the name or age field is null, the original value is used.
  // The original Person object is not modified.
  Person updated([String? name, int? age]) => Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );

  // Returns the name and age of the person as a single string.
  String get displayName => '$name ($age years old)';

  // This code is used to compare two Person objects. It checks
  // whether two Person objects are identical to each other. It
  // also checks whether the runtime types of the objects are the
  // same, and whether the names, ages, and uuids of the objects
  // are the same.
  // @override
  // bool operator ==(covariant Object other) =>
  //     identical(this, other) ||
  //     other is Person &&
  //         runtimeType == other.runtimeType &&
  //         name == other.name &&
  //         age == other.age &&
  //         uuid == other.uuid;

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  // Returns a hash code for this object.
  @override
  int get hashCode => uuid.hashCode;

  /// Returns a string representation of the person.
  /// The string representation has the form 'Person(name: John, age: 42, uuid: ...)'.
  @override
  String toString() => 'Person{name: $name, age: $age, uuid: $uuid}';
}

class DataModel extends ChangeNotifier {
  final List<Person> _people = [];

  List<Person> get people => _people;

  UnmodifiableListView<Person> get peopele =>
      UnmodifiableListView<Person>(_people);

  void addPerson(Person person) {
    people.add(person);
    notifyListeners();
  }

  void removePerson(Person person) {
    people.remove(person);
    notifyListeners();
  }

  void updatePerson(Person updatedPerson) {
    final index = _people.indexOf(updatedPerson);
    final oldPerson = _people[index];
    if (oldPerson.name != updatedPerson.name ||
        oldPerson.age != updatedPerson.age) {
      _people[index] = oldPerson.updated(
        updatedPerson.name,
        updatedPerson.age,
      );
      notifyListeners();
    }
  }
}

final dataModelProvider = ChangeNotifierProvider<DataModel>((ref) {
  return DataModel();
});

class Example5NameList extends ConsumerWidget {
  const Example5NameList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPerson = await createOrUpdatePersonDialog(context);
          if (newPerson != null) {
            ref.read(dataModelProvider).addPerson(newPerson);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final dataModel = ref.watch(dataModelProvider);
          return ListView.builder(
            itemCount: dataModel.people.length,
            itemBuilder: (context, index) {
              final person = dataModel.people[index];
              return ListTile(
                title: Text(person.displayName),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final newPerson = await createOrUpdatePersonDialog(
                      context,
                      person,
                    );
                    if (newPerson != null) {
                      dataModel.updatePerson(newPerson);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(
  BuildContext context, [
  Person? existingPerson,
]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  nameController.text = name ?? '';
  ageController.text = age?.toString() ?? '';
  return showDialog<Person?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(existingPerson == null ? 'Add Person' : 'Edit Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              onChanged: (value) => name = value,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: ageController,
              onChanged: (value) => age = int.tryParse(value),
              decoration: const InputDecoration(
                labelText: 'Age',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (name != null && age != null) {
                // Navigator.of(context).pop(
                //   existingPerson?.update(name, age) ??
                //       Person(name: name, age: age),
                // );
                if (existingPerson != null) {
                  log('existingPerson: $existingPerson');
                  final newPerson = existingPerson.updated(
                    name,
                    age,
                  );
                  Navigator.of(context).pop(newPerson);
                } else {
                  final newPerson = Person(
                    name: name!,
                    age: age!,
                  );
                  Navigator.of(context).pop(newPerson);
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(existingPerson == null ? 'Add' : 'Update'),
          ),
        ],
      );
    },
  );
}
