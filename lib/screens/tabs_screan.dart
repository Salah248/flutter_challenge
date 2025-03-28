import 'package:flutter/material.dart';
import 'package:flutter_challenge/Providers/favotites_provider.dart';
import 'package:flutter_challenge/Providers/meals_provider.dart';
import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_challenge/screens/category_screen.dart';
import 'package:flutter_challenge/screens/filter_Screen.dart';
import 'package:flutter_challenge/screens/meals_screen.dart';
import 'package:flutter_challenge/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegeterian: false,
};

class TabsScrean extends ConsumerStatefulWidget {
  const TabsScrean({super.key});

  @override
  ConsumerState<TabsScrean> createState() => _TabsScreanState();
}

class _TabsScreanState extends ConsumerState<TabsScrean> {
  int _selectedPageIndex = 0;

  Map<Filter, bool> _selectedFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegeterian: false,
  };

  void _setScreen(String identifier) {
    // First close the drawer before changing the screen
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder:
                  (context) => FilterScreen(currentFilters: _selectedFilters),
            ),
          )
          // After push the new screen, update the filters with the new values from the screen
          .then(
            (value) =>
                setState(() => _selectedFilters = value ?? kInitialFilters),
          );
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the meals from the provider and filter them
    final meals = ref.watch(mealsProvider);
    // Filter the meals based on the selected filters
    final availableMeals =
        meals.where((element) {
          if (_selectedFilters[Filter.glutenFree]! && !element.isGlutenFree) {
            return false;
          }
          if (_selectedFilters[Filter.lactoseFree]! && !element.isLactoseFree) {
            return false;
          }
          if (_selectedFilters[Filter.vegan]! && !element.isVegan) {
            return false;
          }
          if (_selectedFilters[Filter.vegeterian]! && !element.isVegetarian) {
            return false;
          }
          return true;
        }).toList();
    // Set the active page based on the selected index
    Widget activePage = CategoryScreen(availableMeals: availableMeals);
    var activePageTitle = 'Pick Your Category';
    if (_selectedPageIndex == 1) {
      final List<Meal> favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(meals: favoriteMeals);
      activePageTitle = 'Favorites';
    }
    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      body: activePage,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
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
