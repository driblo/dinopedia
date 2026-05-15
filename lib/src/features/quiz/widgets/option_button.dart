import 'package:flutter/material.dart';

enum OptionVisualState { idle, selectedCorrect, selectedWrong, revealCorrect, eliminated }

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.label,
    required this.audienceVote,
    required this.visualState,
    required this.onTap,
  });

  final String label;
  final double? audienceVote;
  final OptionVisualState visualState;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bg;
    Color fg;
    switch (visualState) {
      case OptionVisualState.selectedCorrect:
      case OptionVisualState.revealCorrect:
        bg = Colors.green.shade600;
        fg = Colors.white;
        break;
      case OptionVisualState.selectedWrong:
        bg = theme.colorScheme.errorContainer;
        fg = theme.colorScheme.onErrorContainer;
        break;
      case OptionVisualState.eliminated:
        bg = theme.colorScheme.surfaceContainerHighest;
        fg = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.45);
        break;
      case OptionVisualState.idle:
        bg = theme.colorScheme.surfaceContainerHigh;
        fg = theme.colorScheme.onSurface;
        break;
    }

    final disabled = visualState == OptionVisualState.eliminated || onTap == null;

    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: disabled ? null : onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                      decoration: visualState == OptionVisualState.eliminated
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                if (audienceVote != null) ...[
                  const SizedBox(width: 8),
                  _AudienceBar(percent: audienceVote!, color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AudienceBar extends StatelessWidget {
  const _AudienceBar({required this.percent, required this.color});

  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${(percent * 100).round()}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent.clamp(0, 1),
              minHeight: 4,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
