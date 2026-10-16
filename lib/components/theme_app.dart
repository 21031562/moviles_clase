import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData warmTheme() {
    final theme = ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: Brightness.dark,
        primary: Colors.orange,
        onPrimary: const Color.fromARGB(255, 119, 22, 22),
        secondary: Colors.deepOrange,
        onSecondary: const Color.fromARGB(255, 204, 110, 39),
        error: const Color.fromARGB(255, 224, 17, 3),
        onError: const Color.fromARGB(255, 230, 4, 4),
        surface: const Color.fromARGB(255, 160, 180, 12),
        onSurface: const Color.fromARGB(255, 13, 29, 21),
      ),
    ); //copyWith permite modificar el tema
    return theme;
  }
}
