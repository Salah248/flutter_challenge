import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text('Turn on/off two', textAlign: TextAlign.center),
                    Text('player mode', textAlign: TextAlign.center),
                  ],
                ),
                Switch(value: _value, onChanged: (value) {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
