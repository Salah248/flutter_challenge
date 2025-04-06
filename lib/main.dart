import 'package:flutter/material.dart';
import 'package:flutter_challenge/widgets/grocery_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: GoogleFonts.latoTextTheme(),
        scaffoldBackgroundColor: const Color(0xFF1E1E2E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF81C784),
          surface: const Color(0xFF2A2D3E),
          brightness: Brightness.dark,
        ),
      ),
      home: const GroceryList(),
    );
  }
}
