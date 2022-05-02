import 'package:flutter/material.dart';
import 'package:vocaloid_stream/models/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The [Favorites] class holds a list of favorite items saved by the user.
class Favorites with ChangeNotifier {
  static const String _STORE_KEY = 'vocaloid';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<VocalImage> _favoriteItems = [];
  List<String> _urls = [];

  Future<List<VocalImage>> get items async {
    // ignore: await_only_futures
    await _read();
    return this._favoriteItems;
  }

  Future<List<String>> get urls async {
    // ignore: await_only_futures
    await _readURLs();
    return this._urls;
  }

  void _read() async {
    // reset
    // (await _prefs).setStringList(_STORE_KEY, []);

    _favoriteItems = (await _prefs)
        .getStringList(_STORE_KEY)
        .asMap()
        .entries
        .map((entry) => new VocalImage(entry.value, entry.value, entry.key,
            network: true, liked: true))
        .toList();
    // notifyListeners();
  }

  void _readURLs() async {
    _urls = (await _prefs).getStringList(_STORE_KEY);
  }

  void add(VocalImage vocalImage) async {
    if (!_favoriteItems.contains(vocalImage)) {
      List<String> urls = (await _prefs).getStringList(_STORE_KEY);
      print('fav - add - urls: $urls');
      if (urls == null) {
        (await _prefs).setStringList(_STORE_KEY, [vocalImage.url]);
      } else {
        (await _prefs).setStringList(_STORE_KEY, [...urls, vocalImage.url]);
      }

      notifyListeners();
    }
  }

  void remove(VocalImage vocalImage) async {
    // _favoriteItems.remove(vocalImage);

    List<String> urls = (await _prefs).getStringList(_STORE_KEY);
    urls.remove(vocalImage.url);
    print('favorites: remove - urls: $urls');
    (await _prefs).setStringList(_STORE_KEY, urls);
    notifyListeners();
  }

  Future<bool> liked(VocalImage vocalImage) async {
    List<String> urls = (await _prefs).getStringList(_STORE_KEY);
    return urls.contains(vocalImage.url);
  }
}
