import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocaloid_stream/models/all.dart';

/// The [ImageCacher] class provide shared perference object that is reading
/// cached images and return them
class ImageCacher {
  static const String _cached_key = 'cachedImages';
  static const String _cached_twitter_res_key = 'cachedTwitterRes';
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<List<dynamic>> read({bool toObject}) async {
    return toObject != null && toObject
        ? (await _prefs)
            .getStringList(_cached_key)
            .asMap()
            .entries
            .map((e) => new VocalImage(e.value, e.value, e.key,
                network: true, liked: false))
            .toList()
        : (await _prefs).getStringList(_cached_key);
  }

  static store(List<String> urls) async {
    (await _prefs).setStringList(_cached_key, urls);
  }

  static cacheTwitterResBody(dynamic body) async {
    (await _prefs).setString(_cached_twitter_res_key, jsonEncode(body));
  }

  static Future<TwitterAPIResponse> getCachedTwitterRes() async {
    final body = (await _prefs).getString(_cached_twitter_res_key);
    print('imageCacher - getCachedTwitterRes - body: $body');

    return new TwitterAPIResponse.fromResBody(body);
  }
}
