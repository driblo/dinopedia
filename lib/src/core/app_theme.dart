import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _seed = Color(0xFF56C568); // jungle green

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: brightness,
  );

  final baseText = brightness == Brightness.dark
      ? ThemeData.dark().textTheme
      : ThemeData.light().textTheme;

  final textTheme = GoogleFonts.nunitoTextTheme(baseText).copyWith(
    displayLarge: GoogleFonts.nunito(
        fontSize: 57, fontWeight: FontWeight.w800, letterSpacing: -0.25),
    displayMedium: GoogleFonts.nunito(
        fontSize: 45, fontWeight: FontWeight.w800),
    headlineLarge: GoogleFonts.nunito(
        fontSize: 32, fontWeight: FontWeight.w800),
    headlineMedium: GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w700),
    titleLarge: GoogleFonts.nunito(
        fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: GoogleFonts.nunito(
        fontSize: 16, fontWeight: FontWeight.w700),
    titleSmall: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w600),
    labelLarge: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w700),
    labelMedium: GoogleFonts.nunito(
        fontSize: 12, fontWeight: FontWeight.w600),
    labelSmall: GoogleFonts.nunito(
        fontSize: 11, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w500),
    bodyMedium: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500),
    bodySmall: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w500),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: textTheme,
    cardTheme: CardThemeData(
      elevation: 3,
      shadowColor: scheme.shadow.withAlpha(80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide.none,
      labelStyle: GoogleFonts.nunito(
          fontSize: 13, fontWeight: FontWeight.w700),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: scheme.onSurface,
      ),
      toolbarHeight: 60,
    ),
    navigationBarTheme: const NavigationBarThemeData(height: 68),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: GoogleFonts.nunito(
            fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  );
}

// Consistent per-clade color derived from the clade name.
Color cladeColor(String clade) {
  const palette = [
    Color(0xFF43A047), // green
    Color(0xFF1E88E5), // blue
    Color(0xFFE53935), // red
    Color(0xFF8E24AA), // purple
    Color(0xFFFF8F00), // amber
    Color(0xFF00897B), // teal
    Color(0xFFD81B60), // pink
    Color(0xFF3949AB), // indigo
    Color(0xFF6D4C41), // brown
    Color(0xFF039BE5), // light blue
  ];
  return palette[clade.hashCode.abs() % palette.length];
}
