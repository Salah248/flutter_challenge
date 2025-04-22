import 'package:flutter/material.dart';
import 'package:flutter_challenge/screens/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 99, 8, 246),
  surface: const Color.fromARGB(255, 21, 24, 37),
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true).copyWith(
        textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
          titleLarge: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
          titleSmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        colorScheme: colorScheme,
      ),
      home: const Places(),
    );
  }
}
