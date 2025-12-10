import 'package:flutter/material.dart';
import '../models/favorite_meal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesProvider extends ChangeNotifier {
  List<FavoriteMeal> _favorites = [];

  List<FavoriteMeal> get favorites => [..._favorites];


  bool isFavorite(String id) {
    return _favorites.any((meal) => meal.id == id);
  }


  void toggleFavorite(FavoriteMeal meal) {
    final existingIndex = _favorites.indexWhere((m) => m.id == meal.id);
    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add(meal);
    }
    notifyListeners();
    saveFavorites();
  }


  List<FavoriteMeal> mealsByCategory(String category) {
    return _favorites
        .where((meal) => meal.category == category)
        .toList();
  }


  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData =
    _favorites.map((meal) => json.encode(meal.toMap())).toList();
    await prefs.setStringList('favorites', encodedData);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = prefs.getStringList('favorites') ?? [];
    _favorites = encodedData
        .map((mealStr) => FavoriteMeal.fromMap(json.decode(mealStr)))
        .toList();
    notifyListeners();
  }
}
