import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dino_repository.dart';
import '../../data/hive_boxes.dart';
import '../../data/quiz_state_entry.dart';
import 'data/quiz_config.dart';
import 'quiz_builder.dart';
import 'sfx.dart';

enum QuizPhase { intro, playing, revealing, checkpoint, gameOver, win }

class QuizState {
  const QuizState({
    required this.phase,
    required this.questions,
    required this.currentIndex,
    required this.score,
    required this.fiftyFiftyLeft,
    required this.audienceLeft,
    required this.skipLeft,
    required this.eliminated,
    required this.audienceVotes,
    required this.selectedOption,
    required this.wasCorrect,
    required this.checkpointTier,
    required this.highScore,
  });

  factory QuizState.intro({int highScore = 0, int checkpointTier = 0}) =>
      QuizState(
        phase: QuizPhase.intro,
        questions: const [],
        currentIndex: 0,
        score: 0,
        fiftyFiftyLeft: 0,
        audienceLeft: 0,
        skipLeft: 0,
        eliminated: const {},
        audienceVotes: null,
        selectedOption: null,
        wasCorrect: null,
        checkpointTier: checkpointTier,
        highScore: highScore,
      );

  final QuizPhase phase;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int score;
  final int fiftyFiftyLeft;
  final int audienceLeft;
  final int skipLeft;
  final Set<int> eliminated;
  final List<double>? audienceVotes;
  final int? selectedOption;
  final bool? wasCorrect;
  final int checkpointTier;
  final int highScore;

  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  int get totalQuestions => questions.length;

  QuizState copyWith({
    QuizPhase? phase,
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? score,
    int? fiftyFiftyLeft,
    int? audienceLeft,
    int? skipLeft,
    Set<int>? eliminated,
    List<double>? audienceVotes,
    bool clearAudienceVotes = false,
    int? selectedOption,
    bool clearSelectedOption = false,
    bool? wasCorrect,
    bool clearWasCorrect = false,
    int? checkpointTier,
    int? highScore,
  }) {
    return QuizState(
      phase: phase ?? this.phase,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      fiftyFiftyLeft: fiftyFiftyLeft ?? this.fiftyFiftyLeft,
      audienceLeft: audienceLeft ?? this.audienceLeft,
      skipLeft: skipLeft ?? this.skipLeft,
      eliminated: eliminated ?? this.eliminated,
      audienceVotes:
          clearAudienceVotes ? null : (audienceVotes ?? this.audienceVotes),
      selectedOption:
          clearSelectedOption ? null : (selectedOption ?? this.selectedOption),
      wasCorrect: clearWasCorrect ? null : (wasCorrect ?? this.wasCorrect),
      checkpointTier: checkpointTier ?? this.checkpointTier,
      highScore: highScore ?? this.highScore,
    );
  }
}

class QuizController extends Notifier<QuizState> {
  final _random = Random();
  Timer? _revealTimer;

  @override
  QuizState build() {
    ref.onDispose(() => _revealTimer?.cancel());
    final saved = HiveBoxes.quiz.get('latest');
    return QuizState.intro(
      highScore: saved?.highScore ?? 0,
      checkpointTier: saved?.checkpointTier ?? 0,
    );
  }

  Future<void> start({bool fromCheckpoint = false}) async {
    final config = await ref.read(quizConfigProvider.future);
    final dinos = await ref.read(allDinosProvider.future);
    final builder = QuizBuilder(random: _random);
    final questions = builder.build(catalog: dinos, config: config);
    if (questions == null) {
      // Not enough data — bounce back to intro.
      state = state.copyWith(phase: QuizPhase.intro);
      return;
    }

    int startIndex = 0;
    int startScore = 0;
    if (fromCheckpoint && state.checkpointTier > 0) {
      // Resume at the start of the next tier after the checkpoint.
      int passed = 0;
      for (final t in config.tiers) {
        if (t.tier <= state.checkpointTier) {
          passed += t.questions;
          startScore += t.points * t.questions;
        } else {
          break;
        }
      }
      startIndex = passed;
    }

    state = state.copyWith(
      phase: QuizPhase.playing,
      questions: questions,
      currentIndex: startIndex,
      score: startScore,
      fiftyFiftyLeft: config.lifelines.fiftyFifty,
      audienceLeft: config.lifelines.audience,
      skipLeft: config.lifelines.skip,
      eliminated: const {},
      clearAudienceVotes: true,
      clearSelectedOption: true,
      clearWasCorrect: true,
    );
  }

  Future<void> selectOption(int optionIndex) async {
    if (state.phase != QuizPhase.playing) return;
    final question = state.currentQuestion;
    if (question == null) return;

    final correct = optionIndex == question.correctIndex;
    final config = await ref.read(quizConfigProvider.future);
    final tierConfig = config.tiers.firstWhere((t) => t.tier == question.tier);

    final sfx = ref.read(sfxPlayerProvider);
    unawaited(sfx.play(correct ? SfxKind.correct : SfxKind.wrong));

    if (!correct) {
      state = state.copyWith(
        phase: QuizPhase.revealing,
        selectedOption: optionIndex,
        wasCorrect: false,
      );
      _revealTimer?.cancel();
      _revealTimer = Timer(const Duration(milliseconds: 1500), _finishWrong);
      return;
    }

    final newScore = state.score + tierConfig.points;
    state = state.copyWith(
      phase: QuizPhase.revealing,
      selectedOption: optionIndex,
      wasCorrect: true,
      score: newScore,
    );
    _revealTimer?.cancel();
    _revealTimer = Timer(
      const Duration(milliseconds: 1200),
      () => _advanceAfterCorrect(config),
    );
  }

  void _advanceAfterCorrect(QuizConfig config) {
    final nextIndex = state.currentIndex + 1;
    final completed = nextIndex; // 1-indexed question count.

    // Checkpoint hit? (checkpoints are 1-indexed question numbers)
    final hitCheckpoint = config.checkpoints.contains(completed);
    final newCheckpointTier = hitCheckpoint
        ? config.tierForQuestion(completed).tier
        : state.checkpointTier;

    if (nextIndex >= state.totalQuestions) {
      _onWin(newCheckpointTier);
      return;
    }

    if (hitCheckpoint) {
      unawaited(ref.read(sfxPlayerProvider).play(SfxKind.checkpoint));
      state = state.copyWith(
        phase: QuizPhase.checkpoint,
        currentIndex: nextIndex,
        checkpointTier: newCheckpointTier,
        eliminated: const {},
        clearAudienceVotes: true,
        clearSelectedOption: true,
        clearWasCorrect: true,
      );
      unawaited(_persist());
      return;
    }

    state = state.copyWith(
      phase: QuizPhase.playing,
      currentIndex: nextIndex,
      checkpointTier: newCheckpointTier,
      eliminated: const {},
      clearAudienceVotes: true,
      clearSelectedOption: true,
      clearWasCorrect: true,
    );
  }

  void resumeAfterCheckpoint() {
    if (state.phase != QuizPhase.checkpoint) return;
    state = state.copyWith(phase: QuizPhase.playing);
  }

  void _finishWrong() {
    final newHigh = state.score > state.highScore ? state.score : state.highScore;
    state = state.copyWith(phase: QuizPhase.gameOver, highScore: newHigh);
    unawaited(_persist());
  }

  void _onWin(int newCheckpointTier) {
    unawaited(ref.read(sfxPlayerProvider).play(SfxKind.win));
    final newHigh = state.score > state.highScore ? state.score : state.highScore;
    state = state.copyWith(
      phase: QuizPhase.win,
      highScore: newHigh,
      checkpointTier: newCheckpointTier,
      clearSelectedOption: true,
      clearWasCorrect: true,
    );
    unawaited(_persist());
  }

  Future<void> _persist() async {
    final entry = QuizStateEntry(
      highScore: state.highScore,
      checkpointTier: state.checkpointTier,
    );
    await HiveBoxes.quiz.put('latest', entry);
  }

  void useFiftyFifty() {
    if (state.phase != QuizPhase.playing || state.fiftyFiftyLeft <= 0) return;
    final q = state.currentQuestion;
    if (q == null) return;
    final wrongs = <int>[];
    for (var i = 0; i < q.options.length; i++) {
      if (i != q.correctIndex) wrongs.add(i);
    }
    wrongs.shuffle(_random);
    final eliminate = wrongs.take(2).toSet();
    state = state.copyWith(
      fiftyFiftyLeft: state.fiftyFiftyLeft - 1,
      eliminated: {...state.eliminated, ...eliminate},
    );
  }

  void useAudience() {
    if (state.phase != QuizPhase.playing || state.audienceLeft <= 0) return;
    final q = state.currentQuestion;
    if (q == null) return;
    // Bias votes toward the correct answer, with noise.
    final votes = List<double>.filled(q.options.length, 0);
    final correctShare = 0.55 + _random.nextDouble() * 0.25; // 55-80%
    votes[q.correctIndex] = correctShare;
    final remaining = 1.0 - correctShare;
    final wrongIndices = [
      for (var i = 0; i < q.options.length; i++)
        if (i != q.correctIndex && !state.eliminated.contains(i)) i,
    ];
    if (wrongIndices.isEmpty) {
      votes[q.correctIndex] = 1.0;
    } else {
      final weights = [for (final _ in wrongIndices) _random.nextDouble()];
      final wSum = weights.fold<double>(0, (a, b) => a + b);
      for (var i = 0; i < wrongIndices.length; i++) {
        votes[wrongIndices[i]] = remaining * (weights[i] / wSum);
      }
    }
    state = state.copyWith(
      audienceLeft: state.audienceLeft - 1,
      audienceVotes: votes,
    );
  }

  Future<void> useSkip() async {
    if (state.phase != QuizPhase.playing || state.skipLeft <= 0) return;
    final config = await ref.read(quizConfigProvider.future);
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.totalQuestions) {
      _onWin(state.checkpointTier);
      return;
    }
    final completed = nextIndex;
    final hitCheckpoint = config.checkpoints.contains(completed);
    final newCheckpointTier = hitCheckpoint
        ? config.tierForQuestion(completed).tier
        : state.checkpointTier;
    state = state.copyWith(
      phase: hitCheckpoint ? QuizPhase.checkpoint : QuizPhase.playing,
      currentIndex: nextIndex,
      skipLeft: state.skipLeft - 1,
      checkpointTier: newCheckpointTier,
      eliminated: const {},
      clearAudienceVotes: true,
      clearSelectedOption: true,
      clearWasCorrect: true,
    );
    if (hitCheckpoint) unawaited(_persist());
  }

  Future<void> restart() async {
    _revealTimer?.cancel();
    await start(fromCheckpoint: false);
  }

  Future<void> continueFromCheckpoint() async {
    _revealTimer?.cancel();
    await start(fromCheckpoint: true);
  }

  void backToIntro() {
    _revealTimer?.cancel();
    state = QuizState.intro(
      highScore: state.highScore,
      checkpointTier: state.checkpointTier,
    );
  }
}

final quizControllerProvider =
    NotifierProvider<QuizController, QuizState>(QuizController.new);
