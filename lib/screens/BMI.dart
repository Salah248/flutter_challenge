import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_challenge/screens/result_screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  bool _isMale = true;
  double _heightValue = 150;
  int _weightValue = 50;
  int _ageValue = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Mass Index'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [genderType('male'), genderType('female')],
                ),
              ),
              Expanded(child: heightBox()),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    weightAndAgeType('weight'),
                    weightAndAgeType('age'),
                  ],
                ),
              ),
              Container(
                color: Colors.teal,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 16,
                child: TextButton(
                  onPressed: () {
                    var result = (_weightValue) / pow(_heightValue / 100, 2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ResultScreen(
                              gender: _isMale,
                              result: result,
                              age: _ageValue,
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    'Calculate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox genderType(String type) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Card(
        color:
            (_isMale && type == 'male') || (!_isMale && type == 'female')
                ? Colors.teal
                : Colors.blueGrey,
        child: InkWell(
          onTap: () {
            setState(() {
              _isMale = type == 'male' ? true : false;
            });
          },
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.teal,
          highlightColor: Colors.teal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type == 'male' ? Icons.male : Icons.female, size: 80),
              const SizedBox(height: 10),
              Text(
                type == 'male' ? 'Male' : 'Female',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox weightAndAgeType(String type) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Card(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type == 'weight' ? 'Weight' : 'Age',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                type == 'weight'
                    ? _weightValue.toString()
                    : _ageValue.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => setState(() {
                          if (type == 'weight') {
                            _weightValue--;
                          } else {
                            _ageValue--;
                          }
                        }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.remove),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => setState(() {
                          if (type == 'weight') {
                            _weightValue++;
                          } else {
                            _ageValue++;
                          }
                        }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox heightBox() {
    return SizedBox(
      width: double.infinity,
      height: 170,
      child: Card(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Height',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _heightValue.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'CM',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Slider(
              value: _heightValue,
              onChanged:
                  (value) => setState(() {
                    _heightValue = value;
                  }),
              min: 100,
              max: 220,
              activeColor: Colors.teal,
              inactiveColor: Colors.blueGrey,
              divisions: 120,
              label: _heightValue.toStringAsFixed(0),
            ),
          ],
        ),
      ),
    );
  }
}
