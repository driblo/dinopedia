import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/dino_model.dart';
import '../../data/dino_repository.dart';
import '../../l10n/app_localizations.dart';
import 'catalog_controller.dart';
import 'widgets/dino_card.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(catalogQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = ref.watch(filteredDinosProvider);
    final clades = ref.watch(allCladesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalogTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(catalogQueryProvider.notifier).state =
                                  '';
                            },
                          ),
                    hintText: l10n.catalogSearchHint,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) {
                    ref.read(catalogQueryProvider.notifier).state = value;
                    setState(() {}); // refresh suffix clear button
                  },
                ),
              ),
              SizedBox(
                height: 48,
                child: clades.when(
                  data: (list) => _CladeChipsBar(clades: list),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: filtered.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorView(
          message: l10n.errorGeneric,
          retryLabel: l10n.errorRetry,
          onRetry: () => ref.invalidate(allDinosProvider),
        ),
        data: (dinos) {
          if (dinos.isEmpty) {
            return _EmptyView(query: ref.watch(catalogQueryProvider));
          }
          return _DinoGrid(dinos: dinos);
        },
      ),
    );
  }
}

class _CladeChipsBar extends ConsumerWidget {
  const _CladeChipsBar({required this.clades});

  final List<String> clades;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedCladeProvider);

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: clades.length + 1,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return FilterChip(
            label: Text(l10n.catalogFilterAll),
            selected: selected == null,
            onSelected: (_) =>
                ref.read(selectedCladeProvider.notifier).state = null,
          );
        }
        final clade = clades[index - 1];
        return FilterChip(
          label: Text(clade),
          selected: selected == clade,
          onSelected: (chosen) => ref
              .read(selectedCladeProvider.notifier)
              .state = chosen ? clade : null,
        );
      },
    );
  }
}

class _DinoGrid extends StatelessWidget {
  const _DinoGrid({required this.dinos});

  final List<DinoModel> dinos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 900
            ? 4
            : width >= 600
                ? 3
                : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: dinos.length,
          itemBuilder: (context, index) {
            final dino = dinos[index];
            return DinoCard(
              dino: dino,
              onTap: () => context.go('/catalog/dino/${dino.id}'),
            );
          },
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              query.isEmpty ? '—' : '"$query"',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onRetry,
            child: Text(retryLabel),
          ),
        ],
      ),
    );
  }
}
