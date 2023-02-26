import 'package:cached_network_image/cached_network_image.dart';
import 'package:example1/practices/future_provider/meme_image_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(
      seconds: 2,
    ),
    (x) => x + 1,
  ),
);

final memeStreamProvider = StreamProvider(
  (ref) {
    final memes = ref.watch(memeProvider);
    List listOfMemes = memes.asData!.value.memes;
    return ref.watch(tickerProvider.stream).map(
          (event) => listOfMemes.getRange(0, event),
        );
  },
);

class MemeImageGeneratorStreams extends HookConsumerWidget {
  const MemeImageGeneratorStreams({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memes = ref.watch(memeStreamProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stream Meme Image Generator'),
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
                itemCount: memes.length,
                itemBuilder: (context, index) {
                  final meme = memes.elementAt(index);
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
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Seems we\'ve gotten to the end or we\'ve not started yet 👩🏾‍💻',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
