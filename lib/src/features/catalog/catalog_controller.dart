import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dino_model.dart';
import '../../data/dino_repository.dart';

/// Currently selected clade filter. `null` means "All".
final selectedCladeProvider = StateProvider<String?>((_) => null);

/// Free-text search query for the catalog.
final catalogQueryProvider = StateProvider<String>((_) => '');

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
            d.clade.toLowerCase().contains(query),
      );
    }
    return result.toList(growable: false);
  });
});
