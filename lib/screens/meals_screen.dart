import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_challenge/screens/meals_details_screan.dart';
import 'package:flutter_challenge/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});

  final String? title;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    return title == null
        ? Content(meals: meals)
        : Scaffold(
          appBar: AppBar(title: Text(title!)),
          body: Content(meals: meals),
        );
  }
}

class Content extends StatelessWidget {
  const Content({super.key, required this.meals});

  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children:
            meals
                .map(
                  (meal) => MealItem(
                    meal: meal,
                    onTap: (meal) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MealsDetailsScrean(meal: meal),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
      ),
    );
  }
}
