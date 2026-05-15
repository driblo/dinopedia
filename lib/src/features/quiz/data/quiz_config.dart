import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizTierConfig {
  const QuizTierConfig({
    required this.tier,
    required this.points,
    required this.questions,
    required this.label,
  });

  factory QuizTierConfig.fromJson(Map<String, dynamic> j) => QuizTierConfig(
        tier: j['tier'] as int,
        points: j['points'] as int,
        questions: j['questions'] as int,
        label: j['label'] as String,
      );

  final int tier;
  final int points;
  final int questions;
  final String label;
}

class QuizLifelinesConfig {
  const QuizLifelinesConfig({
    required this.fiftyFifty,
    required this.audience,
    required this.skip,
  });

  factory QuizLifelinesConfig.fromJson(Map<String, dynamic> j) =>
      QuizLifelinesConfig(
        fiftyFifty: (j['fifty_fifty'] as num).toInt(),
        audience: (j['audience'] as num).toInt(),
        skip: (j['skip'] as num).toInt(),
      );

  final int fiftyFifty;
  final int audience;
  final int skip;
}

class QuizConfig {
  const QuizConfig({
    required this.tiers,
    required this.checkpoints,
    required this.lifelines,
    required this.distractorStrategy,
  });

  factory QuizConfig.fromJson(Map<String, dynamic> j) => QuizConfig(
        tiers: (j['tiers'] as List)
            .cast<Map<String, dynamic>>()
            .map(QuizTierConfig.fromJson)
            .toList(growable: false),
        checkpoints:
            (j['checkpoints'] as List).cast<num>().map((n) => n.toInt()).toList(
                  growable: false,
                ),
        lifelines: QuizLifelinesConfig.fromJson(
          j['lifelines'] as Map<String, dynamic>,
        ),
        distractorStrategy:
            j['distractor_strategy'] as String? ?? 'different_clade',
      );

  final List<QuizTierConfig> tiers;
  final List<int> checkpoints;
  final QuizLifelinesConfig lifelines;
  final String distractorStrategy;

  int get totalQuestions =>
      tiers.fold(0, (sum, t) => sum + t.questions);

  /// Returns the tier that contains the given (1-indexed) question number.
  QuizTierConfig tierForQuestion(int questionNumber) {
    var counter = 0;
    for (final t in tiers) {
      counter += t.questions;
      if (questionNumber <= counter) return t;
    }
    return tiers.last;
  }
}

final quizConfigProvider = FutureProvider<QuizConfig>((ref) async {
  final raw = await rootBundle.loadString('assets/data/quiz_config.json');
  return QuizConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
});
