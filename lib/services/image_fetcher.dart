import 'dart:convert';
import 'dart:io';
import 'package:vocaloid_stream/models/all.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ImageFetcher {
  static const List<String> _TAGS = [
    "%23gawrt",
    // "%23IRySart",
    // "%23artsofashes",
    // "%23callillust",
    // "%23inart",
    // "%23ameliaRT"
  ];

  static const TWITTER_URI =
      'https://api.twitter.com/2/tweets?ids=1228393702244134912,1227640996038684673,1199786642791452673&tweet.fields=created_at&expansions=author_id&user.fields=created_at';

  static String query(String endpoint, {TwitterQueryParams params}) {
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
    return await [
      'assets/images/pic1.jpg',
      'assets/images/pic2.jpg',
      'assets/images/pic3.jpg',
      'assets/images/pic4.jpg',
      'assets/images/pic5.jpg',
      'assets/images/pic6.jpg',
      'assets/images/pic7.jpg',
      'assets/images/pic8.jpg',
    ].sublist(0, num != null ? num : 8);
  }

  static Future<FetchRemoteRes> fetchRemote({
    String graph = 'recent',
    int num = 100,
    String since,
    String untilId,
  }) async {
    final auth = await _loadAuthJSON();
    final uri = query(graph,
        params: new TwitterQueryParams(_TAGS.join(' '),
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
            maxResults: num));

    print('imageFetcher - fetcheRemote - uri: $uri');

    final res = await http.get(Uri.parse(uri), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${auth['BearerToken']}'
    });
    final body = json.decode(res.body);

    ImageCacher.cacheTwitterResBody(body);

    final twitterAPIResponse = new TwitterAPIResponse.fromResBody(body);

    return new FetchRemoteRes(
        _getMediaURLs(twitterAPIResponse), twitterAPIResponse.meta.oldest_id);
    // return _getMediaURLs(twitterAPIResponse);

    // .then((res) {
    //   final body = json.decode(res.body);
    //   final twitterRes = new TwitterAPIResponse.fromJSON(
    //       data: body['data'], includes: body['includes'], meta: body['meta']);
    //   print(
    //       'imageFetcher - fetchRemote - mediaList: ${twitterRes.includes.mediaList}');
    //   return twitterRes.includes.mediaList.where((el) => el.url != null).map((e) => e.url);
    // }).catchError((error) {
    //   print('imageFetcher - fetchRemote - error: $error');
    //   // ignore: return_of_invalid_type_from_catch_error
    //   return [
    //     "https://pbs.twimg.com/media/E6A7URBVkAMKnz3?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E5wc_1wUUAEjIZy?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E5sQx9OUUAAz36-?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E5iDqqcVEAAzp5Z?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E5NneTwWQAMxxj8?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E498v2-UUAgwo22?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E4-K2BPWYAc307Y?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E4kjaPLXEAMQH5d?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E4Yk5YLXEAI76IO?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E4U8zNcUUAAuyHB?format=jpg&name=medium",
    //     "https://pbs.twimg.com/media/E4ORdy2UYAIJe3W?format=jpg&name=medium"

    //     // "https://pbs.twimg.com/media/E6A7URBVkAMKnz3?format=jpg&name=medium",
    //     // "https://pbs.twimg.com/media/E5wc_1wUUAEjIZy?format=jpg&name=large",
    //     // "https://pbs.twimg.com/media/E5sQx9OUUAAz36-?format=jpg&name=large",
    //     // "https://pbs.twimg.com/media/E5iDqqcVEAAzp5Z?format=jpg&name=4096x4096",
    //     // "https://pbs.twimg.com/media/E5NneTwWQAMxxj8?format=jpg&name=large",
    //     // "https://pbs.twimg.com/media/E498v2-UUAgwo22?format=jpg&name=large",
    //     // "https://pbs.twimg.com/media/E4-K2BPWYAc307Y?format=jpg&name=4096x4096",
    //     // "https://pbs.twimg.com/media/E4kjaPLXEAMQH5d?format=jpg&name=4096x4096",
    //     // "https://pbs.twimg.com/media/E4Yk5YLXEAI76IO?format=jpg&name=medium",
    //     // "https://pbs.twimg.com/media/E4U8zNcUUAAuyHB?format=jpg&name=4096x4096",
    //     // "https://pbs.twimg.com/media/E4ORdy2UYAIJe3W?format=jpg&name=large"
    //   ].sublist(0, num != null ? num : 8);
    // });
  }
}

List<String> _getMediaURLs(TwitterAPIResponse twitterAPIResponse) {
  return twitterAPIResponse.includes.mediaList
      .where((el) => el.url != null)
      .map((e) => e.url)
      .toList();
}

Future<dynamic> _loadAuthJSON() async {
  final String res = await rootBundle.loadString('assets/twitter_auth.json');
  return json.decode(res);
}

class FetchRemoteRes {
  final List<String> uris;
  final String sinceId;

  FetchRemoteRes(this.uris, this.sinceId);
}
