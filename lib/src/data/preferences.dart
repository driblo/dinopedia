import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hive_boxes.dart';

const _kSoundEnabled = 'sound_enabled';
const _kLocaleOverride = 'locale_override';

class SoundEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    return HiveBoxes.prefs.get(_kSoundEnabled, defaultValue: true) as bool;
  }

  Future<void> set(bool value) async {
    state = value;
    await HiveBoxes.prefs.put(_kSoundEnabled, value);
  }

  void toggle() => set(!state);
}

final soundEnabledProvider =
    NotifierProvider<SoundEnabledNotifier, bool>(SoundEnabledNotifier.new);

class LocaleOverrideNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final raw = HiveBoxes.prefs.get(_kLocaleOverride) as String?;
    if (raw == null || raw.isEmpty) return null;
    return Locale(raw);
  }

  Future<void> set(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await HiveBoxes.prefs.delete(_kLocaleOverride);
    } else {
      await HiveBoxes.prefs.put(_kLocaleOverride, locale.languageCode);
    }
  }
}

final localeOverrideProvider =
    NotifierProvider<LocaleOverrideNotifier, Locale?>(
        LocaleOverrideNotifier.new);

@visibleForTesting
const debugPrefsKeys = (_kSoundEnabled, _kLocaleOverride);
