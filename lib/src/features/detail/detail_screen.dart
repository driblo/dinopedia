import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dino_model.dart';
import '../../data/dino_repository.dart';
import '../../data/wiki_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_localizations_ext.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.dinoId});

  final String dinoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dinosAsync = ref.watch(allDinosProvider);

    return Scaffold(
      body: dinosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (dinos) {
          final dino = dinos.where((d) => d.id == dinoId).firstOrNull;
          if (dino == null) {
            return Center(child: Text(l10n.errorGeneric));
          }
          return _DetailBody(dino: dino);
        },
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.dino});

  final DinoModel dino;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final summary = ref.watch(
      wikiSummaryProvider((slug: dino.wikipediaSlug, locale: locale)),
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 280,
          title: Text(dino.name),
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'dino-image-${dino.id}',
              child: _HeaderImage(
                primaryUrl: summary.asData?.value.imageUrl,
                fallbackUrl: dino.thumbnailUrl,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _FactGrid(dino: dino, l10n: l10n),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: summary.when(
              loading: () => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.detailLoadingWiki),
                  ],
                ),
              ),
              error: (err, _) => _WikiError(
                message: l10n.detailWikiUnavailable,
                retryLabel: l10n.errorRetry,
                onRetry: () => ref.invalidate(wikiSummaryProvider),
              ),
              data: (wiki) => Text(
                wiki.summary.isEmpty
                    ? l10n.detailWikiUnavailable
                    : wiki.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: summary.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (wiki) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: FilledButton.tonalIcon(
                  onPressed: () => _copyLink(context, wiki.pageUrl, l10n),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.detailWikipediaSource),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Text(
              l10n.detailWikiAttribution,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _copyLink(
    BuildContext context,
    String url,
    AppLocalizations l10n,
  ) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(url), behavior: SnackBarBehavior.floating),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  const _HeaderImage({required this.primaryUrl, required this.fallbackUrl});

  final String? primaryUrl;
  final String? fallbackUrl;

  @override
  Widget build(BuildContext context) {
    final url = primaryUrl ?? fallbackUrl;
    final bg = Theme.of(context).colorScheme.surfaceContainerHighest;
    if (url == null || url.isEmpty) {
      return Container(color: bg);
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      memCacheWidth: 1080,
      placeholder: (_, _) => Container(color: bg),
      errorWidget: (_, _, _) => Container(color: bg),
    );
  }
}

class _FactGrid extends StatelessWidget {
  const _FactGrid({required this.dino, required this.l10n});

  final DinoModel dino;
  final AppLocalizations l10n;

  String _diet(DinoModel d, AppLocalizations l10n) {
    switch (d.diet.toLowerCase()) {
      case 'carnivore':
        return l10n.dietCarnivore;
      case 'herbivore':
        return l10n.dietHerbivore;
      case 'omnivore':
        return l10n.dietOmnivore;
      default:
        return d.diet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final facts = <(String, String)>[
      (l10n.detailClade, dino.clade),
      (l10n.detailPeriod, dino.period),
      (l10n.detailDiet, _diet(dino, l10n)),
      if (dino.lengthM != null)
        (l10n.detailLength, '${dino.lengthM!.toStringAsFixed(1)} m'),
      if (dino.weightKg != null)
        (l10n.detailWeight, '${dino.weightKg!.toStringAsFixed(0)} kg'),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (label, value) in facts)
          _FactChip(label: label, value: value),
      ],
    );
  }
}

class _FactChip extends StatelessWidget {
  const _FactChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label · ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WikiError extends StatelessWidget {
  const _WikiError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(message)),
        TextButton(onPressed: onRetry, child: Text(retryLabel)),
      ],
    );
  }
}
