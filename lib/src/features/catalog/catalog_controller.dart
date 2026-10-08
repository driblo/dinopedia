import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dino_model.dart';
import '../../data/dino_repository.dart';

/// Currently selected clade filter. `null` means "All".
final selectedCladeProvider = StateProvider<String?>((_) => null);

/// Free-text search query for the catalog.
final catalogQueryProvider = StateProvider<String>((_) => '');

/// Map of clade → count of dinos in that clade.
final cladeCountsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  final all = ref.watch(allDinosProvider);
  return all.whenData((dinos) {
    final counts = <String, int>{};
    for (final d in dinos) {
      if (d.clade != null) counts[d.clade!] = (counts[d.clade!] ?? 0) + 1;
    }
    return counts;
  });
});

/// Filtered + searched list derived from the bundled catalog.
final filteredDinosProvider = Provider<AsyncValue<List<DinoModel>>>((ref) {
  final all = ref.watch(allDinosProvider);
  final clade = ref.watch(selectedCladeProvider);
  final query = ref.watch(catalogQueryProvider).trim().toLowerCase();

  return all.whenData((dinos) {
    Iterable<DinoModel> result = dinos;
    if (clade != null) {
      result = result.where((d) => d.clade == clade);
    }
    if (query.isNotEmpty) {
      result = result.where(
        (d) =>
            d.name.toLowerCase().contains(query) ||
            (d.clade ?? '').toLowerCase().contains(query),
      );
    }
    return result.toList(growable: false);
  });
});
