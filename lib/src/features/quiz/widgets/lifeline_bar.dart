import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class LifelineBar extends StatelessWidget {
  const LifelineBar({
    super.key,
    required this.fiftyFiftyLeft,
    required this.audienceLeft,
    required this.skipLeft,
    required this.onFiftyFifty,
    required this.onAudience,
    required this.onSkip,
  });

  final int fiftyFiftyLeft;
  final int audienceLeft;
  final int skipLeft;
  final VoidCallback onFiftyFifty;
  final VoidCallback onAudience;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Pill(
          icon: Icons.exposure_zero,
          label: l10n.quizLifelineFiftyFifty,
          available: fiftyFiftyLeft > 0,
          onTap: onFiftyFifty,
        ),
        _Pill(
          icon: Icons.groups,
          label: l10n.quizLifelineAudience,
          available: audienceLeft > 0,
          onTap: onAudience,
        ),
        _Pill(
          icon: Icons.skip_next,
          label: l10n.quizLifelineSkip,
          available: skipLeft > 0,
          onTap: onSkip,
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.available,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = available
        ? theme.colorScheme.secondaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    final fg = available
        ? theme.colorScheme.onSecondaryContainer
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    return Semantics(
      button: true,
      enabled: available,
      label: label,
      child: Opacity(
        opacity: available ? 1 : 0.5,
        child: Material(
          color: bg,
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: available ? onTap : null,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(color: fg),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
