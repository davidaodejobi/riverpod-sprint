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
