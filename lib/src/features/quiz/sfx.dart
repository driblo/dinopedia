import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/preferences.dart';

enum SfxKind { correct, wrong, win, checkpoint }

class SfxPlayer {
  SfxPlayer(this._enabled);

  bool _enabled;
  final Map<SfxKind, AudioPlayer> _players = {};
  static const Map<SfxKind, String> _assets = {
    SfxKind.correct: 'assets/audio/correct.mp3',
    SfxKind.wrong: 'assets/audio/wrong.mp3',
    SfxKind.win: 'assets/audio/win.mp3',
    SfxKind.checkpoint: 'assets/audio/checkpoint.mp3',
  };

  void updateEnabled(bool enabled) => _enabled = enabled;

  Future<void> play(SfxKind kind) async {
    if (!_enabled) return;
    try {
      final player = _players.putIfAbsent(kind, AudioPlayer.new);
      await player.setAsset(_assets[kind]!);
      await player.seek(Duration.zero);
      await player.play();
    } catch (e) {
      // Audio assets are optional. Fail silently to avoid breaking the quiz.
      if (kDebugMode) {
        debugPrint('SfxPlayer: failed to play ${kind.name}: $e');
      }
    }
  }

  Future<void> dispose() async {
    for (final p in _players.values) {
      await p.dispose();
    }
    _players.clear();
  }
}

final sfxPlayerProvider = Provider<SfxPlayer>((ref) {
  final enabled = ref.watch(soundEnabledProvider);
  final player = SfxPlayer(enabled);
  ref.listen<bool>(soundEnabledProvider, (_, next) {
    player.updateEnabled(next);
  });
  ref.onDispose(player.dispose);
  return player;
});
