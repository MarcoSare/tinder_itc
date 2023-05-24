import 'package:flutter/material.dart';

class StylesSettings {
  static final lightTheme = ThemeData(
      fontFamily: 'Mukta',
      useMaterial3: true,
      primaryColorDark: const Color(0xFF1F1A1D),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF1F1A1D)),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 231, 141, 156)),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD21D35)),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD21D35)),
            borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(color: Color(0xFF1F1A1D)),
        labelStyle: const TextStyle(
          color: Color(0xFF1F1A1D),
        ),
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFB61F39),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFFFDADA),
        onPrimaryContainer: Color(0xFF40000B),
        secondary: Color(0xFF765657),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFFFDADA),
        onSecondaryContainer: Color(0xFF2C1516),
        tertiary: Color(0xFFB91938),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFFFDADA),
        onTertiaryContainer: Color(0xFF40000B),
        error: Color(0xFFBA1A1A),
        errorContainer: Color(0xFFFFDAD6),
        onError: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFF410002),
        background: Color(0xFFFFFBFF),
        onBackground: Color(0xFF201A1A),
        surface: Color(0xFFFFFBFF),
        onSurface: Color(0xFF201A1A),
        surfaceVariant: Color(0xFFF4DDDD),
        onSurfaceVariant: Color(0xFF524343),
        outline: Color(0xFF857373),
        onInverseSurface: Color(0xFFFBEEED),
        inverseSurface: Color(0xFF362F2F),
        inversePrimary: Color(0xFFFFB3B5),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFFB61F39),
        outlineVariant: Color(0xFFD7C1C1),
        scrim: Color(0xFF000000),
      ));

  static final darkTheme = ThemeData(
    fontFamily: 'Mukta',
    useMaterial3: true,
    primaryColorDark: const Color(0xFFEAE0E3),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFEAE0E3)),
          borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFFB3B5)),
          borderRadius: BorderRadius.circular(20)),
      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF680018)),
          borderRadius: BorderRadius.circular(20)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF680018)),
          borderRadius: BorderRadius.circular(20)),
      hintStyle: const TextStyle(color: Color(0xFFEAE0E3)),
      labelStyle: const TextStyle(
        color: Color(0xFFEAE0E3),
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB3B5),
      onPrimary: Color(0xFF680018),
      primaryContainer: Color(0xFF920025),
      onPrimaryContainer: Color(0xFFFFDADA),
      secondary: Color(0xFFE6BDBD),
      onSecondary: Color(0xFF44292A),
      secondaryContainer: Color(0xFF5D3F40),
      onSecondaryContainer: Color(0xFFFFDADA),
      tertiary: Color(0xFFFFB3B5),
      onTertiary: Color(0xFF680018),
      tertiaryContainer: Color(0xFF920025),
      onTertiaryContainer: Color(0xFFFFDADA),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
      onError: Color(0xFF690005),
      onErrorContainer: Color(0xFFFFDAD6),
      background: Color(0xFF201A1A),
      onBackground: Color(0xFFECE0DF),
      surface: Color(0xFF201A1A),
      onSurface: Color(0xFFECE0DF),
      surfaceVariant: Color(0xFF524343),
      onSurfaceVariant: Color(0xFFD7C1C1),
      outline: Color(0xFF9F8C8C),
      onInverseSurface: Color(0xFF201A1A),
      inverseSurface: Color(0xFFECE0DF),
      inversePrimary: Color(0xFFB61F39),
      shadow: Color(0xFF000000),
      surfaceTint: Color(0xFFFFB3B5),
      outlineVariant: Color(0xFF524343),
      scrim: Color(0xFF000000),
    ),
  );
}
