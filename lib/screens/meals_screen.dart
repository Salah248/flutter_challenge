import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_challenge/screens/meals_details_screan.dart';
import 'package:flutter_challenge/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    required this.onToggleFavorite,
  });

  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal)? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return title == null
        ? Content(meals: meals, onToggleFavorite: onToggleFavorite)
        : Scaffold(
          appBar: AppBar(title: Text(title!)),
          body: Content(meals: meals, onToggleFavorite: onToggleFavorite),
        );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.meals,
    required this.onToggleFavorite,
  });

  final List<Meal> meals;
  final void Function(Meal meal)? onToggleFavorite;

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
                          builder:
                              (context) => MealsDetailsScrean(
                                meal: meal,
                                onToggleFavorite: onToggleFavorite,
                              ),
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
