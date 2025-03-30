import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/dummy_data.dart';
import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_challenge/widgets/category_item.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.availableMeals});
  final List<Meal> availableMeals;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
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
            onToggleFavorite: (meal) {},
            availableMeals: widget.availableMeals,
          );
        },
      ),
      builder:
          (context, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: const Offset(0, 0),
            ).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: child,
          ),
    );
  }
}
