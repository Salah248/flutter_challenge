import 'package:flutter/material.dart';
import 'package:flutter_challenge/screens/home_bage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF00061a),
        shadowColor: const Color(0xFF001456),
        splashColor: const Color(0xFF4169e8),
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontSize: 28),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 52),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
