import 'package:flutter/material.dart';
import 'package:vocaloid_stream/models/all.dart';
import 'package:vocaloid_stream/services/all.dart';
import 'package:vocaloid_stream/utils/all.dart';
import 'package:flutter/foundation.dart';

class ImageStageModel with ChangeNotifier {
  static List<VocalImage> _vocalImages = [];
  static List<String> _urls = [];
  static String _oldestId;

  List<VocalImage> get vocalImages {
    if (_vocalImages.length == 0) reload();

    return _vocalImages;
  }

  List<String> get urls {
    if (_vocalImages.length == 0) reload();

    return _urls;
  }

  reload() async {
    final value = await ImageFetcher.fetchRemote(num: 100);
    _oldestId = value.sinceId;

    if (!listEquals(value.uris, _urls)) {
      ImageCacher.store(value.uris);
      _urls = value.uris;
      _vocalImages =
          await mapFromURLs(value.uris, network: true, checkLikes: true);
      notifyListeners();
    }
  }

  append() async {
    final value =
        await ImageFetcher.fetchRemote(graph: 'recent', untilId: _oldestId);
    _oldestId = value.sinceId;
    final cacahedURIs = await ImageCacher.read();
    _appendURIs(cacahedURIs, value.uris);
    ImageCacher.store(cacahedURIs);

    _urls = cacahedURIs;
    _vocalImages =
        await mapFromURLs(cacahedURIs, network: true, checkLikes: true);
    notifyListeners();

    print('imageStageModel - append - cachedURIS: $cacahedURIs');
  }

  List<String> _appendURIs(List<String> original, List<String> newURIs) {
    newURIs.forEach((element) {
      if (!original.contains(element)) {
        original.add(element);
      }
    });

    return original;
  }
}
