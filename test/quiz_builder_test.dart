import 'dart:math';

import 'package:dinopedia/src/data/dino_model.dart';
import 'package:dinopedia/src/features/quiz/data/quiz_config.dart';
import 'package:dinopedia/src/features/quiz/quiz_builder.dart';
import 'package:flutter_test/flutter_test.dart';

DinoModel _dino(String id, {String clade = 'Theropoda', int tier = 1}) =>
    DinoModel(
      id: id,
      name: id,
      clade: clade,
      period: 'Cretaceous',
      diet: 'carnivore',
      thumbnailUrl: 'https://example/$id.jpg',
      wikipediaSlug: id,
      quizTier: tier,
    );

const _config = QuizConfig(
  tiers: [
    QuizTierConfig(tier: 1, points: 100, questions: 2, label: 'Hatchling'),
    QuizTierConfig(tier: 2, points: 250, questions: 2, label: 'Juvenile'),
  ],
  checkpoints: [2],
  lifelines: QuizLifelinesConfig(fiftyFifty: 1, audience: 1, skip: 1),
  distractorStrategy: 'different_clade',
);

void main() {
  group('QuizBuilder', () {
    test('returns null when there are not enough images', () {
      final catalog = [_dino('a'), _dino('b'), _dino('c')];
      final builder = QuizBuilder(random: Random(1));
      expect(builder.build(catalog: catalog, config: _config), isNull);
    });

    test('builds totalQuestions with 4 options each and a valid correctIndex',
        () {
      final catalog = [
        for (var i = 0; i < 10; i++)
          _dino('t1_$i', clade: i.isEven ? 'Theropoda' : 'Sauropoda', tier: 1),
        for (var i = 0; i < 10; i++)
          _dino('t2_$i', clade: i.isEven ? 'Ceratopsia' : 'Thyreophora', tier: 2),
      ];
      final builder = QuizBuilder(random: Random(42));
      final questions = builder.build(catalog: catalog, config: _config);

      expect(questions, isNotNull);
      expect(questions!.length, _config.totalQuestions);
      for (final q in questions) {
        expect(q.options.length, 4);
        expect(q.correctIndex, inInclusiveRange(0, 3));
        expect(q.options.contains(q.correct), isTrue);
      }
    });

    test('tier 1 distractors come from a different clade when possible', () {
      final catalog = [
        _dino('hero', clade: 'Theropoda', tier: 1),
        for (var i = 0; i < 6; i++) _dino('foe_$i', clade: 'Sauropoda', tier: 1),
        for (var i = 0; i < 6; i++) _dino('foe_t_$i', clade: 'Theropoda', tier: 1),
      ];
      final cfg = QuizConfig(
        tiers: const [
          QuizTierConfig(tier: 1, points: 100, questions: 1, label: 'A'),
        ],
        checkpoints: const [],
        lifelines: const QuizLifelinesConfig(
            fiftyFifty: 0, audience: 0, skip: 0),
        distractorStrategy: 'different_clade',
      );
      final builder = QuizBuilder(random: Random(7));
      // Run a few times to be confident.
      for (var i = 0; i < 20; i++) {
        final qs = builder.build(catalog: catalog, config: cfg)!;
        final q = qs.single;
        final distractors =
            q.options.where((d) => d.id != q.correct.id).toList();
        if (q.correct.clade == 'Theropoda') {
          expect(distractors.every((d) => d.clade != 'Theropoda'), isTrue,
              reason: 'tier 1 should prefer different-clade distractors');
        }
      }
    });
  });

  test('QuizConfig.tierForQuestion maps question numbers correctly', () {
    expect(_config.tierForQuestion(1).tier, 1);
    expect(_config.tierForQuestion(2).tier, 1);
    expect(_config.tierForQuestion(3).tier, 2);
    expect(_config.tierForQuestion(4).tier, 2);
  });
}
