import 'package:flutter_riverpod/flutter_riverpod.dart';

// this enum contains all the filters that can be applied to the meals
enum Filters { glutenFree, lactoseFree, vegan, vegeterian }

class FilterMealsProvider extends StateNotifier<Map<Filters, bool>> {
  FilterMealsProvider()
    : super({
        Filters.glutenFree: false,
        Filters.lactoseFree: false,
        Filters.vegan: false,
        Filters.vegeterian: false,
      });

  void setFilter(Filters filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  void setFilters(Map<Filters, bool> filters) {
    state = filters;
  }
}

final filterMeals =
    StateNotifierProvider<FilterMealsProvider, Map<Filters, bool>>((ref) {
      return FilterMealsProvider();
    });
