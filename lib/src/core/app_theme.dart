import 'package:flutter/material.dart';

const _seed = Color(0xFF5D4037); // earthy brown — prehistoric warmth

ThemeData buildTheme(Brightness brightness) => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        // Keep bottom bar visible — no edge-to-edge hiding
        height: 64,
      ),
    );
