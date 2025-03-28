import 'package:flutter_challenge/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<Meal>> {
  FavoritesNotifier(super.state);

  void toggleFavorite(Meal meal) {
    // Check if the meal is already a favorite
    final isExisting = state.contains(meal);
    if (isExisting) {
      state = state.where((meal) => meal.id != meal.id).toList();

      // _showInfoMessage('Meal is no longer a favorite.');
    } else {
      state = [...state, meal];

      // _showInfoMessage('Marked as a favorite.');
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoritesNotifier, List<Meal>>((ref) {
      return FavoritesNotifier([]);
    });
