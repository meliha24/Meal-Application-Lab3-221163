// lib/providers/meals_provider.dart
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';
import '../services/api_service.dart';

class MealsProvider with ChangeNotifier {
  final ApiService _api = ApiService();


  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> loadCategories() async {
    try {
      _categories = await _api.getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading categories: $e");
    }
  }


  List<Meal> _meals = [];
  List<Meal> get meals => _meals;

  Future<void> loadMeals(String category) async {
    try {
      _meals = await _api.getMealsByCategory(category);

      notifyListeners();
    } catch (e) {
      debugPrint("Error loading meals for $category: $e");
    }
  }


  Future<MealDetail> loadRandomMealDetail() async {
    return await _api.getRandomMeal();
  }


  Future<MealDetail> loadMealDetail(String id) async {
    return await _api.getMealDetail(id);
  }
}