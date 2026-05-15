import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dino_model.dart';

class DinoRepository {
  const DinoRepository();

  Future<List<DinoModel>> loadAll() async {
    final raw = await rootBundle.loadString('assets/data/dinosaurs.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .cast<Map<String, dynamic>>()
        .map(DinoModel.fromJson)
        .toList(growable: false);
  }
}

final dinoRepositoryProvider = Provider<DinoRepository>(
  (ref) => const DinoRepository(),
);

final allDinosProvider = FutureProvider<List<DinoModel>>((ref) async {
  return ref.read(dinoRepositoryProvider).loadAll();
});

final allCladesProvider = FutureProvider<List<String>>((ref) async {
  final dinos = await ref.watch(allDinosProvider.future);
  final clades = <String>{for (final d in dinos) d.clade}.toList()..sort();
  return clades;
});
