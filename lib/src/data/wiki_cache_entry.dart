import 'package:hive/hive.dart';

class WikiCacheEntry {
  WikiCacheEntry({
    required this.slug,
    required this.summary,
    this.imageUrl,
    required this.cachedAt,
  });

  final String slug;
  final String summary;
  final String? imageUrl;
  final DateTime cachedAt;

  bool get isExpired => DateTime.now().difference(cachedAt).inDays >= 30;
}

class WikiCacheEntryAdapter extends TypeAdapter<WikiCacheEntry> {
  @override
  final int typeId = 1;

  @override
  WikiCacheEntry read(BinaryReader reader) {
    return WikiCacheEntry(
      slug: reader.readString(),
      summary: reader.readString(),
      imageUrl: reader.read() as String?,
      cachedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, WikiCacheEntry obj) {
    writer
      ..writeString(obj.slug)
      ..writeString(obj.summary)
      ..write(obj.imageUrl)
      ..writeInt(obj.cachedAt.millisecondsSinceEpoch);
  }
}
