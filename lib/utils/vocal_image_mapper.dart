import 'package:vocaloid_stream/models/all.dart';

Future<List<VocalImage>> mapFromURLs(List<String> urls,
    {bool network, bool checkLikes}) async {
  final likedURLs = await new Favorites().urls;
  return urls != null
      ? urls
          .asMap()
          .entries
          .map((e) => new VocalImage(e.value, e.value, e.key,
              network: network != null ? network : false,
              liked: likedURLs.contains(e.value)))
          .toList()
      : [];
}
