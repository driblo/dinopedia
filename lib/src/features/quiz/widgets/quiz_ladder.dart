import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../data/quiz_config.dart';

class QuizLadder extends StatelessWidget {
  const QuizLadder({
    super.key,
    required this.config,
    required this.currentQuestion,
  });

  final QuizConfig config;

  /// 1-indexed current question.
  final int currentQuestion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    int cumulative = 0;
    final rows = <Widget>[];
    // Build top-down (Tier N → Tier 1) so harder tiers are at the top.
    final tiers = config.tiers.toList()..sort((a, b) => b.tier.compareTo(a.tier));
    final ascending = config.tiers; // for cumulative math
    final cumulatives = <int, int>{};
    var running = 0;
    for (final t in ascending) {
      running += t.questions;
      cumulatives[t.tier] = running;
    }

    for (final t in tiers) {
      final endsAt = cumulatives[t.tier]!;
      final startsAt = endsAt - t.questions + 1;
      final isCurrent =
          currentQuestion >= startsAt && currentQuestion <= endsAt;
      final isCleared = currentQuestion > endsAt;
      final isCheckpoint = config.checkpoints.contains(endsAt);

      Color bg;
      Color fg;
      if (isCurrent) {
        bg = theme.colorScheme.primary;
        fg = theme.colorScheme.onPrimary;
      } else if (isCleared) {
        bg = theme.colorScheme.primaryContainer;
        fg = theme.colorScheme.onPrimaryContainer;
      } else {
        bg = theme.colorScheme.surfaceContainerHighest;
        fg = theme.colorScheme.onSurfaceVariant;
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${t.tier}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(color: fg),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t.label,
                    style: theme.textTheme.bodyMedium?.copyWith(color: fg),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCheckpoint)
                  Icon(Icons.flag, size: 16, color: fg),
                const SizedBox(width: 6),
                Text(
                  '${t.points}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: fg,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            l10n.quizTier(config.tierForQuestion(currentQuestion).tier),
            style: theme.textTheme.labelLarge,
          ),
        ),
        ...rows,
      ],
    );
  }
}
