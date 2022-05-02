class TwitterQueryParams {
  List<String> _expansions;
  int _maxResults;
  List<String> _mediaFields;
  String _nextToken;
  List<String> _placeFields;
  List<String> _pollFields;
  final String _query;
  String _sinceId;
  List<String> _tweetFeilds;
  String _untilId;

  TwitterQueryParams(this._query,
      {List<String> expansions,
      int maxResults,
      List<String> mediaFeidls,
      String nextToken,
      List<String> placeFields,
      List<String> pollFields,
      String sinceId,
      List<String> tweetFeilds,
      String untilId}) {
    this._expansions = expansions;
    this._mediaFields = mediaFeidls;
    this._maxResults = maxResults;
    this._nextToken = nextToken;
    this._placeFields = placeFields;
    this._pollFields = pollFields;
    this._sinceId = sinceId;
    this._tweetFeilds = tweetFeilds;
    this._untilId = untilId;
  }

  List<String> expansions() {
    return this._expansions;
  }

  int maxResults() {
    return this._maxResults;
  }

  List<String> mediaFields() {
    return this._mediaFields;
  }

  String nextToken() {
    return this._nextToken;
  }

  List<String> placeFields() {
    return this._placeFields;
  }

  List<String> pollFields() {
    return this._pollFields;
  }

  String query() {
    return this._query;
  }

  String sinceId() {
    return this._sinceId;
  }

  List<String> tweetFeilds() {
    return this._tweetFeilds;
  }

  String untilId() {
    return this._untilId;
  }

  String toString() {
    String query = 'query=${this._query}';

    if (_expansions != null) query += '&expansions=${_expansions.join(",")}';

    if (_mediaFields != null)
      query += '&media.fields=${_mediaFields.join(',')}';

    if (_maxResults != null) query += '&max_results=$_maxResults';

    if (_nextToken != null) query += '&next_token=$_nextToken';

    if (_placeFields != null)
      query += '&place.fields=${_placeFields.join(',')}';

    if (_pollFields != null) query += '&poll.fields=${_pollFields.join(',')}';

    if (_sinceId != null) query += '&since_id=$_sinceId';

    if (_tweetFeilds != null) query += '&tweet.fields=$_sinceId';

    if (_untilId != null) query += '&until_id=$_untilId';

    return query;
  }
}
