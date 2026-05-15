import 'dart:math';
import '../../data/dino_model.dart';
import 'data/quiz_config.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.correct,
    required this.options,
    required this.tier,
  });

  final DinoModel correct;

  /// Always length 4, includes the correct dino.
  final List<DinoModel> options;

  /// Tier this question belongs to (matches config tier number).
  final int tier;

  int get correctIndex => options.indexWhere((d) => d.id == correct.id);
}

class QuizBuilder {
  QuizBuilder({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// Builds the question ladder for one playthrough. Returns null if the
  /// catalog cannot provide enough images for a full run.
  List<QuizQuestion>? build({
    required List<DinoModel> catalog,
    required QuizConfig config,
  }) {
    final pool = catalog.where((d) => (d.thumbnailUrl ?? '').isNotEmpty).toList();
    if (pool.length < 4) return null;

    final byTierBucket = <int, List<DinoModel>>{};
    for (final d in pool) {
      byTierBucket.putIfAbsent(d.quizTier, () => []).add(d);
    }

    final questions = <QuizQuestion>[];
    final usedIds = <String>{};

    for (final tier in config.tiers) {
      // Candidate correct-answers come from this tier and easier tiers.
      final candidates = pool
          .where((d) => d.quizTier <= tier.tier && !usedIds.contains(d.id))
          .toList();
      if (candidates.length < tier.questions) {
        // Allow repeats across tiers if catalog is small.
        candidates.addAll(pool.where((d) => d.quizTier <= tier.tier));
      }
      candidates.shuffle(_random);

      var taken = 0;
      for (final correct in candidates) {
        if (taken >= tier.questions) break;
        if (usedIds.contains(correct.id)) continue;
        final question = _buildQuestion(
          correct: correct,
          pool: pool,
          tier: tier.tier,
          strategy: config.distractorStrategy,
        );
        if (question == null) continue;
        questions.add(question);
        usedIds.add(correct.id);
        taken++;
      }
    }

    if (questions.length < config.totalQuestions) return null;
    return questions;
  }

  QuizQuestion? _buildQuestion({
    required DinoModel correct,
    required List<DinoModel> pool,
    required int tier,
    required String strategy,
  }) {
    final useDifferentClade = strategy == 'different_clade' && tier <= 3;
    var distractorPool = pool.where((d) => d.id != correct.id).toList();
    if (useDifferentClade) {
      final diffClade =
          distractorPool.where((d) => d.clade != correct.clade).toList();
      if (diffClade.length >= 3) distractorPool = diffClade;
    }
    if (distractorPool.length < 3) return null;
    distractorPool.shuffle(_random);
    final distractors = distractorPool.take(3).toList();
    final options = [correct, ...distractors]..shuffle(_random);
    return QuizQuestion(correct: correct, options: options, tier: tier);
  }
}
