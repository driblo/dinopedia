import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'hive_boxes.dart';
import 'wiki_cache_entry.dart';

class WikiSummary {
  const WikiSummary({
    required this.slug,
    required this.lang,
    required this.summary,
    required this.imageUrl,
    required this.pageUrl,
  });

  final String slug;
  final String lang;
  final String summary;
  final String? imageUrl;
  final String pageUrl;
}

class WikiException implements Exception {
  WikiException(this.message);
  final String message;
  @override
  String toString() => 'WikiException: $message';
}

class WikiRepository {
  WikiRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static String _cacheKey(String lang, String slug) => '$lang:$slug';

  static String _pageUrl(String lang, String slug) =>
      'https://$lang.wikipedia.org/wiki/$slug';

  Future<WikiSummary> getSummary(String slug, {required String lang}) async {
    final key = _cacheKey(lang, slug);
    final cached = HiveBoxes.wiki.get(key);
    if (cached != null && !cached.isExpired) {
      return WikiSummary(
        slug: slug,
        lang: lang,
        summary: cached.summary,
        imageUrl: cached.imageUrl,
        pageUrl: _pageUrl(lang, slug),
      );
    }

    final uri = Uri.parse(
      'https://$lang.wikipedia.org/api/rest_v1/page/summary/$slug',
    );

    final http.Response res;
    try {
      res = await _client.get(uri, headers: const {
        'accept': 'application/json',
        'user-agent': 'Dinopedia/1.0 (https://github.com/driblo/dinopedia)',
      }).timeout(const Duration(seconds: 12));
    } on SocketException {
      throw WikiException('offline');
    }

    if (res.statusCode == 404 && lang != 'en') {
      // Fall back to English if the localized page doesn't exist.
      return getSummary(slug, lang: 'en');
    }
    if (res.statusCode != 200) {
      throw WikiException('status ${res.statusCode}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final extract = (body['extract'] as String?)?.trim() ?? '';
    final image = (body['originalimage'] as Map?)?['source'] as String? ??
        (body['thumbnail'] as Map?)?['source'] as String?;

    await HiveBoxes.wiki.put(
      key,
      WikiCacheEntry(
        slug: slug,
        summary: extract,
        imageUrl: image,
        cachedAt: DateTime.now(),
      ),
    );

    return WikiSummary(
      slug: slug,
      lang: lang,
      summary: extract,
      imageUrl: image,
      pageUrl: _pageUrl(lang, slug),
    );
  }
}

final wikiRepositoryProvider = Provider<WikiRepository>((ref) {
  final repo = WikiRepository();
  ref.onDispose(() => repo._client.close());
  return repo;
});

/// Family: (slug, lang) → summary. The current UI Locale is passed in so cache
/// hits respect language.
final wikiSummaryProvider = FutureProvider.family
    .autoDispose<WikiSummary, ({String slug, Locale locale})>((ref, args) {
  return ref
      .read(wikiRepositoryProvider)
      .getSummary(args.slug, lang: args.locale.languageCode);
});
