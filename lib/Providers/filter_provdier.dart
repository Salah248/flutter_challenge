import 'package:flutter_challenge/Providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// this enum contains all the filters that can be applied to the meals
enum Filters { glutenFree, lactoseFree, vegan, vegeterian }

class FilterMealsProvider extends StateNotifier<Map<Filters, bool>> {
  FilterMealsProvider(super._state);

  /// This function is used to set the filter from the previous screen to the current screen.
  /// When the filter is set to true, it will be applied to the meals.
  /// When the filter is set to false, it will be removed from the meals.
  void setFilter(Filters filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  // this function is used to set the filters from the previous screen TO the current screen
  void setFilters(Map<Filters, bool> filters) {
    state = filters;
  }
}

final filterMeals =
    StateNotifierProvider<FilterMealsProvider, Map<Filters, bool>>((ref) {
      return FilterMealsProvider({
        Filters.glutenFree: false,
        Filters.lactoseFree: false,
        Filters.vegan: false,
        Filters.vegeterian: false,
      });
    });

// Filter the meals based on the selected filters
final filterMealsProvider = Provider((ref) {
  // Get the meals from the provider and filter them
  final meals = ref.watch(mealsProvider);

  final Map<Filters, bool> selectedFilters = ref.watch(filterMeals);

  return meals.where((element) {
    if (selectedFilters[Filters.glutenFree]! && !element.isGlutenFree) {
      return false;
    }
    if (selectedFilters[Filters.lactoseFree]! && !element.isLactoseFree) {
      return false;
    }
    if (selectedFilters[Filters.vegan]! && !element.isVegan) {
      return false;
    }
    if (selectedFilters[Filters.vegeterian]! && !element.isVegetarian) {
      return false;
    }
    return true;
  }).toList();
});
