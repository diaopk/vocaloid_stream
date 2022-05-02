import 'all.dart';

class VocalImage {
  final String label;
  final String url;
  final int index;
  bool network;
  bool liked;
  TwitterResMedia _media;

  VocalImage(this.url, this.label, this.index,
      {bool network, bool liked, TwitterResMedia media}) {
    this.network = network;
    this.liked = liked;
    this._media = media;
  }

  String toString() {
    return 'url: ${this.url}, label: ${this.label}, index: ${this.index}, network: ${this.network}, liked: ${this.liked}';
  }

  TwitterResMedia media() {
    return _media;
  }

  bool operator ==(Object other) =>
      other is VocalImage && other.url == this.url;

  @override
  int get hashCode => label.hashCode ^ url.hashCode;
}
