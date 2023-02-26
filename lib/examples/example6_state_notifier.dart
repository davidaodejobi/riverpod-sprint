// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  /// Creates a copy of the [Film] object with the given [isFavorite] value.
  ///
  /// This is a convenience method for creating a copy of a [Film] object
  /// with the given [isFavorite] value. This is useful for creating a copy
  /// of a [Film] object with a different [isFavorite] value. For example, if
  /// you have a [Film] object with an [isFavorite] value of `false` and you
  /// want to create a copy of that same [Film] object with an [isFavorite] value
  /// of `true`, you can do so by calling the [copy] method with the argument
  /// `isFavorite: true`.
  Film copy({
    required bool isFavorite,
  }) =>
      Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  @override
  String toString() =>
      'Film{id: $id, title: $title, description: $description, isFavorite: $isFavorite}';

  /// Compares two [Film]s by [id] and [isFavorite].
  /// This is used to check if a [Film] has changed or not.
  /// The [other] [Film] is compared to this [Film].
  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavorite == other.isFavorite;

  /// Returns the hash code for this object, which is the [hash code] of the
  /// [identifier] and the [isFavorite] flag.
  @override
  int get hashCode => Object.hashAll([id, isFavorite]);
}

const List<Film> films = [
  Film(
    id: '1',
    title: 'The Shawshank Redemption',
    description:
        'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
    isFavorite: true,
  ),
  Film(
    id: '2',
    title: 'The Godfather',
    description:
        'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'The Dark Knight',
    description:
        'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
    isFavorite: true,
  ),
  Film(
    id: '4',
    title: 'The Lord of the Rings: The Fellowship of the Ring',
    description:
        'A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.',
    isFavorite: true,
  ),
  Film(
    id: '5',
    title: 'Forrest Gump',
    description:
        'The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate, and other historical events unfold through the perspective of an Alabama man with an IQ of 75.',
    isFavorite: false,
  ),
  Film(
    id: '6',
    title: 'Star Wars: Episode IV - A New Hope',
    description:
        'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee, and two droids to save the galaxy from the Empire\'s world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.',
    isFavorite: true,
  ),
];

class FilmNotifer extends StateNotifier<List<Film>> {
  FilmNotifer() : super(films);

  /// Update the [film] with the given [id] to be [favorite] or not.
  //
  /// The [id] identifies the [film] to update. The [isFavorite] parameter
  /// determines whether the film is marked as a favorite or not.
  /// If the film is not in the list, nothing will happen.

  void update(String id, bool isFavorite) {
    state = state
        .map(
          (film) => film.id == id
              ? film.copy(
                  isFavorite: isFavorite,
                )
              : film,
        )
        .toList();
  }
}

enum FavoriteFilter {
  all,
  favorite,
  notFavorite,
}

final favoriteStatusProvider = StateProvider<FavoriteFilter>(
  (_) => FavoriteFilter.all,
);

final allFilmsProvider = StateNotifierProvider<FilmNotifer, List<Film>>(
  (_) => FilmNotifer(),
);

// favoriteFilmsProvider
final favoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => film.isFavorite,
      ),
);

// notFavoriteFilmsProvider
final notFavoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => !film.isFavorite,
      ),
);

class Example6StateNotifier extends StatelessWidget {
  const Example6StateNotifier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Films'),
      ),
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(builder: (context, ref, child) {
            final filter = ref.watch(favoriteStatusProvider);
            switch (filter) {
              case FavoriteFilter.all:
                return FilmsWidget(
                  provider: allFilmsProvider,
                );
              case FavoriteFilter.favorite:
                return FilmsWidget(
                  provider: favoriteFilmsProvider,
                );
              case FavoriteFilter.notFavorite:
                return FilmsWidget(
                  provider: notFavoriteFilmsProvider,
                );
            }
          })
        ],
      ),
    );
  }
}

class FilmsWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsWidget({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          final favoriteIcon =
              film.isFavorite ? Icons.favorite : Icons.favorite_border_outlined;
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              icon: Icon(
                favoriteIcon,
              ),
              onPressed: () {
                final isFavorite = !film.isFavorite;
                ref.read(allFilmsProvider.notifier).update(
                      film.id,
                      isFavorite,
                    );
              },
            ),
          );
        },
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return DropdownButton<FavoriteFilter>(
          value: ref.watch(favoriteStatusProvider),
          items: FavoriteFilter.values.map(
            (filter) {
              return DropdownMenuItem(
                value: filter,
                child: Text(
                  filter.name,
                ),
              );
            },
          ).toList(),
          onChanged: (FavoriteFilter? filter) {
            ref.read(favoriteStatusProvider.notifier).state = filter!;
          },
        );
      },
    );
  }
}
