import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/dummy_data.dart';
import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_challenge/widgets/category_item.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    super.key,
    required this.onToggleFavorite,
    required this.availableMeals,
  });
  final void Function(Meal meal)? onToggleFavorite;
  final List<Meal> availableMeals;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
        ),
        itemCount: availableCategories.length,
        itemBuilder: (context, index) {
          return CategoryItem(
            category: availableCategories[index],
            onToggleFavorite: onToggleFavorite,
            availableMeals: availableMeals,
          );
        },
      ),
    );
  }
}
