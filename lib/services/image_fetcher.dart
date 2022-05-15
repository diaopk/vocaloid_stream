import 'dart:convert';
import 'dart:io';
import 'package:vocaloid_stream/models/all.dart';
import 'package:http/http.dart' as http;
import 'package:vocaloid_stream/utils/all.dart';
import 'package:flutter/services.dart' show rootBundle;

class ImageFetcher {
  static Future<String> _loadTags() async {
    final config = await loadJSON('assets/config.json');
    return config['kronii']['tag'];
  }

  static const TWITTER_URI =
      'https://api.twitter.com/2/tweets?ids=1228393702244134912,1227640996038684673,1199786642791452673&tweet.fields=created_at&expansions=author_id&user.fields=created_at';

  static String _query(String endpoint, {TwitterQueryParams params}) {
    assert(endpoint == 'recent' || endpoint == 'all',
        'endpoint must be either recent or all');

    final String uri = endpoint == 'recent'
        ? 'https://api.twitter.com/2/tweets/search/recent'
        : 'https://api.twitter.com/2/tweets/search/all';

    return '$uri?$params';
  }

  static List<String> get({int num}) {
    String url =
        'https://pbs.twimg.com/media/EusFdtOU4AImWWb?format=png&name=large';

    return [
      url,
      'https://pbs.twimg.com/media/Eulse2EXcAYXHvh?format=jpg&name=large',
      'https://pbs.twimg.com/media/EnsxTAKUYAA2Swh?format=jpg&name=4096x4096',
      'https://pbs.twimg.com/media/EuhKhnWVEAM5NcW?format=jpg&name=large'
    ];
  }

  static Future<List<String>> fetchLocal({int num}) async {
    final values = [
      'assets/images/pic1.jpg',
      'assets/images/pic2.jpg',
      'assets/images/pic3.jpg',
      'assets/images/pic4.jpg',
      'assets/images/pic5.jpg',
      'assets/images/pic6.jpg',
      'assets/images/pic7.jpg',
      'assets/images/pic8.jpg',
    ].sublist(0, num != null ? num : 8);
    return Future.value(values);
  }

  static Future<FetchRemoteRes> fetchRemote({
    String graph = 'recent',
    int num = 100,
    String since,
    String untilId,
  }) async {
    final auth = await loadJSON('assets/twitter_auth.json');
    final tags = await _loadTags();
    final uri = _query(
      graph,
      params: new TwitterQueryParams(tags,
          expansions: [
            'attachments.poll_ids',
            // 'author_id',
            'attachments.media_keys'
          ],
          sinceId: since,
          untilId: untilId,
          mediaFeidls: [
            'duration_ms',
            'height',
            'media_key',
            'preview_image_url',
            'type',
            'url',
            'width',
            'public_metrics',
            'non_public_metrics',
            'organic_metrics',
            'promoted_metrics'
          ],
          maxResults: num),
    );

    print('imageFetcher - fetcheRemote - uri: $uri');

    final res = await http.get(Uri.parse(uri), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${auth['BearerToken']}'
    });
    final body = json.decode(res.body);

    ImageCacher.cacheTwitterResBody(body);

    final twitterAPIResponse = new TwitterAPIResponse.fromResBody(body);

    return new FetchRemoteRes(
        _getMediaURLs(twitterAPIResponse), twitterAPIResponse.meta.oldest_id);
  }
}

List<String> _getMediaURLs(TwitterAPIResponse twitterAPIResponse) {
  return twitterAPIResponse.includes.mediaList
      .where((el) => el.url != null)
      .map((e) => e.url)
      .toList();
}

class FetchRemoteRes {
  final List<String> uris;
  final String sinceId;

  FetchRemoteRes(this.uris, this.sinceId);
}
