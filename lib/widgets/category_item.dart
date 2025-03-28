import 'package:flutter/material.dart';
import 'package:flutter_challenge/models/category_model.dart';
import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_challenge/screens/meals_screen.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    required this.onToggleFavorite,
    required this.availableMeals,
  });

  final Category category;
  final void Function(Meal meal)? onToggleFavorite;
  final List<Meal> availableMeals;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final filterDummyMeal =
            availableMeals
                .where((element) => element.categories.contains(category.id))
                .toList();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) =>
                    MealsScreen(title: category.title, meals: filterDummyMeal),
          ),
        );
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withAlpha((.54 * 255).round()),
              category.color.withAlpha((.9 * 255).round()),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
