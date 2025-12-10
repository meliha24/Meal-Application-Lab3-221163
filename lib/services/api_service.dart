import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const base = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> getCategories() async {
    final res = await http.get(Uri.parse("$base/categories.php"));
    final body = jsonDecode(res.body);
    return (body["categories"] as List)
        .map((e) => Category.fromJson(e))
        .toList();
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final res = await http.get(Uri.parse("$base/filter.php?c=$category"));
    final body = jsonDecode(res.body);
    return (body["meals"] as List)
        .map((e) => Meal.fromJsonFilter(e))
        .toList();
  }

  Future<MealDetail> getMealDetail(String id) async {
    final res = await http.get(Uri.parse("$base/lookup.php?i=$id"));
    final data = jsonDecode(res.body);
    return MealDetail.fromJson(data["meals"][0]);
  }

  Future<MealDetail> getRandomMeal() async {
    final res = await http.get(Uri.parse("$base/random.php"));
    final data = jsonDecode(res.body);
    return MealDetail.fromJson(data["meals"][0]);
  }

}
