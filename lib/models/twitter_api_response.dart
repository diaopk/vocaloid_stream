class TwitterAPIResponse {
  final List<TwitterResData> data;
  final TwitterResMeta meta;
  final TwitterResIncludes includes;

  TwitterAPIResponse(this.data, this.includes, this.meta);

  static find() {}

  factory TwitterAPIResponse.fromResBody(dynamic body) =>
      new TwitterAPIResponse.fromJSON(
          data: body['data'], includes: body['includes'], meta: body['meta']);

  factory TwitterAPIResponse.fromJSON(
      {List<dynamic> data, Map<String, dynamic> includes, Map meta}) {
    final _dataList = data
        .map<TwitterResData>((el) => new TwitterResData(el['id'], el['text']))
        .toList();
    final _includes = new TwitterResIncludes.fromJSON(media: includes['media']);
    final _meta = new TwitterResMeta.fromJSON(meta);
    return new TwitterAPIResponse(_dataList, _includes, _meta);
  }

  String toString() {
    return '{data: $data, includes: $includes, meta: $meta}';
  }
}

class TwitterResIncludes {
  final List<TwitterResMedia> mediaList;

  TwitterResIncludes(this.mediaList);

  factory TwitterResIncludes.fromJSON({List<dynamic> media}) {
    final mediaList = media
        .map<TwitterResMedia>((el) => new TwitterResMedia(
            el['media_key'], el['type'], el['url'], el['height'], el['width']))
        .toList();
    return new TwitterResIncludes(mediaList);
  }

  String toString() {
    return '{mediaList: $mediaList}';
  }
}

class TwitterResData {
  final String id;
  final String text;

  TwitterResData(this.id, this.text);

  factory TwitterResData.fromJSON(Map<String, String> json) {
    return new TwitterResData(json['id'], json['text']);
  }

  String toString() {
    return '{id: $id, text: $text}';
  }
}

class TwitterResMedia {
  final String media_key;
  final String type;
  final String url;
  final int height;
  final int width;

  TwitterResMedia(this.media_key, this.type, this.url, this.height, this.width);

  factory TwitterResMedia.fromJSON(Map<String, dynamic> json) {
    return new TwitterResMedia(json['media_key'], json['type'], json['url'],
        json['height'], json['width']);
  }

  String toString() {
    return '{media_key: $media_key, type: $type, url: $url, height: $height, width: $width}';
  }
}

class TwitterResMeta {
  final String newest_id;
  final String next_token;
  final String oldest_id;
  final int result_count;

  TwitterResMeta(
      this.newest_id, this.next_token, this.oldest_id, this.result_count);

  factory TwitterResMeta.fromJSON(Map<String, dynamic> json) {
    return new TwitterResMeta(json['newest_id'], json['next_token'],
        json['oldest_id'], json['result_count']);
  }

  String toString() {
    return '{newest_id: $newest_id, next_token: $next_token, oldest_id: $oldest_id, result_count: $result_count}';
  }
}
