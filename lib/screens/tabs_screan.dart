import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/dummy_data.dart';
import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_challenge/screens/category_screen.dart';
import 'package:flutter_challenge/screens/filter_Screen.dart';
import 'package:flutter_challenge/screens/meals_screen.dart';
import 'package:flutter_challenge/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegeterian: false,
};

class TabsScrean extends StatefulWidget {
  const TabsScrean({super.key});

  @override
  State<TabsScrean> createState() => _TabsScreanState();
}

class _TabsScreanState extends State<TabsScrean> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  Map<Filter, bool> _selectedFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegeterian: false,
  };

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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

  void _toggleFavorite(Meal meal) {
    // Check if the meal is already a favorite
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage('Marked as a favorite.');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the meals based on the selected filters
    final availableMeals =
        dummyMeals.where((element) {
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
    Widget activePage = CategoryScreen(
      onToggleFavorite: _toggleFavorite,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Pick Your Category';
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleFavorite,
      );
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
