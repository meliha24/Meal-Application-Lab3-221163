// lib/screens/meal_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/favorite_meal.dart';
import '../models/meal_detail.dart';
import '../providers/favorites_provider.dart';
import '../providers/meals_provider.dart';

class MealDetailScreen extends StatelessWidget {
  final FavoriteMeal meal;

  const MealDetailScreen({required this.meal, super.key});


  void _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProv = Provider.of<FavoritesProvider>(context);
    final mealsProv = Provider.of<MealsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        actions: [
          IconButton(
            icon: Icon(
              favoritesProv.isFavorite(meal.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              favoritesProv.toggleFavorite(meal);
            },
          ),
        ],
      ),
      body: FutureBuilder<MealDetail>(
        future: mealsProv.loadMealDetail(meal.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Failed to load meal details."));
          }

          final mealDetail = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Image.network(
                  mealDetail.thumbnail,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, size: 50)),
                ),

                const SizedBox(height: 10),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    mealDetail.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),


                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Состојки:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                ...mealDetail.ingredients.entries.map(
                      (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Text("${e.key} - ${e.value}"),
                  ),
                ),

                const SizedBox(height: 20),


                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Инструкции:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(mealDetail.instructions),
                ),

                const SizedBox(height: 20),


                if (mealDetail.youtube.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () => _openYoutube(mealDetail.youtube),
                      child: const Text(
                        "Гледај на YouTube",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}