import 'package:flutter/material.dart';

enum Healthiness { underweight, normal, overweight, obese }

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.gender,
    required this.result,
    required this.age,
  });

  final bool gender;
  final double result;
  final int age;

  String get healthinessText {
    if (result <= 18.5) {
      return 'Underweight';
    } else if (result >= 18.5 && result < 24.9) {
      return 'Normal';
    } else if (result >= 24.9 && result < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 58, 183, 152),
      ),
      body: SafeArea(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium!,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...resultsTexts.entries.map(
                  (e) => Text("${e.key}: ${e.value}"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, String> get resultsTexts => {
    'Gender': gender ? 'Male' : 'Female',
    'Result': result.toStringAsFixed(1),
    'Healthiness': healthinessText,
    'Age': age.toString(),
  };
}
