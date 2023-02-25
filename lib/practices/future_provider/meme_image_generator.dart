import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Response {
  final bool success;
  final Map<String, dynamic> data;

  Response({
    required this.success,
    required this.data,
  });

  Response.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        data = json['data'];
}

class Memes {
  final List<Meme> memes;

  Memes({
    required this.memes,
  });

  Memes.fromJson(Map<String, dynamic> json)
      : memes = (json['memes'] as List).map((e) => Meme.fromJson(e)).toList();
}

class Meme {
  final String id;
  final String name;
  final String url;
  final int width;
  final int height;
  final int boxCount;
  final int captions;

  Meme({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
    required this.captions,
  });

  Meme.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'],
        width = json['width'],
        height = json['height'],
        boxCount = json['box_count'],
        captions = json['captions'];
}

Future<Response> fetchMemes() async {
  final response = await Dio().get('https://api.imgflip.com/get_memes');

  if (response.statusCode == 200) {
    final data = Response.fromJson(response.data);
    return data;
  } else {
    throw Exception('Failed to load memes');
  }
}

final memeProvider = FutureProvider.autoDispose<Memes>(
  (ref) async {
    final response = await fetchMemes();
    return Memes.fromJson(response.data);
  },
);

class MemeImageGenerator extends HookConsumerWidget {
  const MemeImageGenerator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memes = ref.watch(memeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meme Image Generator'),
        ),
        body: memes.when(
          data: (memes) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: memes.memes.length,
                itemBuilder: (context, index) {
                  final meme = memes.memes[index];
                  return Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: meme.url,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const SpinKitChasingDots(
                          color: Colors.teal,
                          size: 30.0,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            meme.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SpinKitChasingDots(
                  color: Colors.teal,
                  size: 40.0,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading memes, wait abeg... 🤓',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          error: (error, stackTrace) => const Center(
            child: Text(
              'You don fuck up guy! 🥹👩🏾‍💻',
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
