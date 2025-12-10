// lib/screens/meals_by_category_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/meals_provider.dart';
import '../models/favorite_meal.dart';
import '../widgets/meal_item.dart';


class MealsByCategoryScreen extends StatefulWidget {
  final String category;
  const MealsByCategoryScreen({required this.category, super.key});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<MealsProvider>(context, listen: false)
          .loadMeals(widget.category)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  void _goToRandomMeal(BuildContext context, MealsProvider mealsProv) {

    mealsProv.loadRandomMealDetail().then((randomMealDetail) {
      final favoriteMeal = FavoriteMeal(
        id: randomMealDetail.id,
        name: randomMealDetail.name,
        thumbnail: randomMealDetail.thumbnail,
        category: widget.category,
      );
      Navigator.of(context).pushNamed(
        '/meal-detail',
        arguments: favoriteMeal,
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch random meal.")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealsProv = Provider.of<MealsProvider>(context);
    final favoritesProv = Provider.of<FavoritesProvider>(context, listen: false);
    final meals = mealsProv.meals;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: "Random Recipe",
            onPressed: _isLoading ? null : () => _goToRandomMeal(context, mealsProv),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : meals.isEmpty
          ? const Center(child: Text("No meals found for this category."))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: meals.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) {
          final meal = meals[i];

          final favoriteMeal = FavoriteMeal(
            id: meal.id,
            name: meal.name,
            thumbnail: meal.thumbnail,
            category: widget.category,
          );

          return MealItem(
            meal: meal,
            onTap: () {
              Navigator.of(context).pushNamed(
                '/meal-detail',
                arguments: favoriteMeal,
              );
            },
            onToggleFavorite: () {
              favoritesProv.toggleFavorite(favoriteMeal);
            },
          );
        },
      ),
    );
  }
}