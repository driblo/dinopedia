import 'package:hive/hive.dart';

class DinoModel extends HiveObject {
  DinoModel({
    required this.id,
    required this.name,
    required this.clade,
    required this.period,
    required this.diet,
    this.lengthM,
    this.weightKg,
    this.thumbnailUrl,
    required this.wikipediaSlug,
    required this.quizTier,
  });

  factory DinoModel.fromJson(Map<String, dynamic> json) => DinoModel(
        id: json['id'] as String,
        name: json['name'] as String,
        clade: json['clade'] as String,
        period: json['period'] as String,
        diet: json['diet'] as String,
        lengthM: (json['length_m'] as num?)?.toDouble(),
        weightKg: (json['weight_kg'] as num?)?.toDouble(),
        thumbnailUrl: json['thumbnail_url'] as String?,
        wikipediaSlug: json['wikipedia_slug'] as String,
        quizTier: (json['quiz_tier'] as num?)?.toInt() ?? 3,
      );

  final String id;
  final String name;
  final String clade;
  final String period;
  final String diet;
  final double? lengthM;
  final double? weightKg;
  final String? thumbnailUrl;
  final String wikipediaSlug;
  final int quizTier;
}

// Hive is used only for WikiCacheEntry and QuizStateEntry;
// DinoModel is loaded from bundled JSON and kept in memory.
