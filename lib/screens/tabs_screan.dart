import 'package:flutter/material.dart';
import 'package:flutter_challenge/Providers/favotites_provider.dart';
import 'package:flutter_challenge/Providers/filter_provdier.dart';
import 'package:flutter_challenge/Providers/nav_bar_provider.dart';
import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_challenge/screens/category_screen.dart';
import 'package:flutter_challenge/screens/filter_Screen.dart';
import 'package:flutter_challenge/screens/meals_screen.dart';
import 'package:flutter_challenge/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScrean extends ConsumerWidget {
  const TabsScrean({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Meal> availableMeals = ref.watch(filterMealsProvider);
    final selectedPageIndex = ref.watch(navBarProvider);

    // Set the active page based on the selected index
    Widget activePage = CategoryScreen(availableMeals: availableMeals);
    var activePageTitle = 'Pick Your Category';
    if (selectedPageIndex == 1) {
      final List<Meal> favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(meals: favoriteMeals);
      activePageTitle = 'Favorites';
    }
    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      body: activePage,
      drawer: MainDrawer(
        onSelectScreen: (identifier) {
          // First close the drawer before changing the screen
          Navigator.of(context).pop();
          if (identifier == 'filters') {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FilterScreen()),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: ref.read(navBarProvider.notifier).setPageIndex,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
