import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_ext.dart';
import 'data/quiz_config.dart';
import 'quiz_builder.dart';
import 'quiz_controller.dart';
import 'widgets/lifeline_bar.dart';
import 'widgets/option_button.dart';
import 'widgets/question_card.dart';
import 'widgets/quiz_ladder.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  late final ConfettiController _confetti;
  QuizPhase? _lastPhase;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizControllerProvider);
    final l10n = AppLocalizations.of(context);

    // Fire confetti on transition into checkpoint/win.
    if (_lastPhase != state.phase) {
      _lastPhase = state.phase;
      if (state.phase == QuizPhase.win ||
          state.phase == QuizPhase.checkpoint) {
        _confetti.play();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quizTitle),
        actions: [
          if (state.phase != QuizPhase.intro)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: l10n.errorRetry,
              onPressed: () =>
                  ref.read(quizControllerProvider.notifier).backToIntro(),
            ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: switch (state.phase) {
              QuizPhase.intro => _IntroView(state: state),
              QuizPhase.playing ||
              QuizPhase.revealing =>
                _PlayingView(state: state),
              QuizPhase.checkpoint => _CheckpointView(state: state),
              QuizPhase.gameOver => _GameOverView(state: state),
              QuizPhase.win => _WinView(state: state),
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 24,
              emissionFrequency: 0.05,
              gravity: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroView extends ConsumerWidget {
  const _IntroView({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey('intro'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.quiz, size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l10n.quizTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            if (state.highScore > 0)
              Text(
                '${l10n.quizHighScore}: ${state.highScore}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () =>
                  ref.read(quizControllerProvider.notifier).start(),
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.quizStart),
            ),
            if (state.checkpointTier > 0) ...[
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => ref
                    .read(quizControllerProvider.notifier)
                    .continueFromCheckpoint(),
                icon: const Icon(Icons.flag),
                label: Text(l10n.quizContinueCheckpoint),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              l10n.quizOfflineHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayingView extends ConsumerWidget {
  const _PlayingView({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final configAsync = ref.watch(quizConfigProvider);
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();
    final isRevealing = state.phase == QuizPhase.revealing;

    return SafeArea(
      key: const ValueKey('playing'),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final body = Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.quizScoreLabel(state.score),
                      style: theme.textTheme.titleMedium,
                    ),
                    if (configAsync.hasValue)
                      Text(
                        l10n.quizTier(configAsync.value!
                            .tierForQuestion(state.currentIndex + 1)
                            .tier),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                QuestionCard(
                  question: question,
                  questionNumber: state.currentIndex + 1,
                  totalQuestions: state.totalQuestions,
                ),
                const SizedBox(height: 16),
                ..._buildOptions(context, ref, question, isRevealing),
                const SizedBox(height: 12),
                LifelineBar(
                  fiftyFiftyLeft: state.fiftyFiftyLeft,
                  audienceLeft: state.audienceLeft,
                  skipLeft: state.skipLeft,
                  onFiftyFifty: () => ref
                      .read(quizControllerProvider.notifier)
                      .useFiftyFifty(),
                  onAudience: () =>
                      ref.read(quizControllerProvider.notifier).useAudience(),
                  onSkip: () =>
                      ref.read(quizControllerProvider.notifier).useSkip(),
                ),
              ],
            ),
          );

          if (!wide) {
            return SingleChildScrollView(child: body);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: SingleChildScrollView(child: body)),
              SizedBox(
                width: 220,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                  child: configAsync.when(
                    data: (cfg) => QuizLadder(
                      config: cfg,
                      currentQuestion: state.currentIndex + 1,
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildOptions(
    BuildContext context,
    WidgetRef ref,
    QuizQuestion question,
    bool isRevealing,
  ) {
    final options = question.options;
    return [
      for (var i = 0; i < options.length; i++) ...[
        OptionButton(
          label: options[i].name,
          audienceVote: state.audienceVotes?[i],
          visualState: _visualStateFor(i, question.correctIndex, isRevealing),
          onTap: isRevealing || state.eliminated.contains(i)
              ? null
              : () => ref
                  .read(quizControllerProvider.notifier)
                  .selectOption(i),
        ),
        if (i != options.length - 1) const SizedBox(height: 10),
      ],
    ];
  }

  OptionVisualState _visualStateFor(int i, int correctIndex, bool isRevealing) {
    if (state.eliminated.contains(i)) return OptionVisualState.eliminated;
    if (!isRevealing) return OptionVisualState.idle;
    if (i == correctIndex) return OptionVisualState.revealCorrect;
    if (i == state.selectedOption) return OptionVisualState.selectedWrong;
    return OptionVisualState.idle;
  }
}

class _CheckpointView extends ConsumerWidget {
  const _CheckpointView({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey('checkpoint'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(l10n.quizCheckpointReached,
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              l10n.quizScoreLabel(state.score),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref
                  .read(quizControllerProvider.notifier)
                  .resumeAfterCheckpoint(),
              child: Text(l10n.quizStart),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameOverView extends ConsumerWidget {
  const _GameOverView({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey('gameover'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.quizGameOver,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.quizScoreLabel(state.score),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () =>
                  ref.read(quizControllerProvider.notifier).restart(),
              child: Text(l10n.quizRestart),
            ),
            if (state.checkpointTier > 0) ...[
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(quizControllerProvider.notifier)
                    .continueFromCheckpoint(),
                child: Text(l10n.quizContinueCheckpoint),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WinView extends ConsumerWidget {
  const _WinView({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      key: const ValueKey('win'),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.emoji_events,
                size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              l10n.quizWin,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.quizScoreLabel(state.score),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () =>
                  ref.read(quizControllerProvider.notifier).restart(),
              child: Text(l10n.quizRestart),
            ),
          ],
        ),
      ),
    );
  }
}
