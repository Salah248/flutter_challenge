import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<Meal>> {
  FavoritesNotifier(super.state);

  bool toggleFavorite(Meal meal) {
    // Check if the meal is already a favorite
    final isExisting = state.contains(meal);
    if (isExisting) {
      state = state.where((meal) => meal.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoritesNotifier, List<Meal>>((ref) {
      return FavoritesNotifier([]);
    });
