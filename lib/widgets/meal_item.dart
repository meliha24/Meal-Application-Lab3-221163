// lib/widgets/meal_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../models/favorite_meal.dart';

class MealItem extends StatelessWidget {
  final Meal meal;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;
  final String category;

  const MealItem({
    super.key,
    required this.meal,
    required this.onToggleFavorite,
    this.onTap,
    this.category = 'N/A',
  });

  @override
  Widget build(BuildContext context) {

    final favoriteMeal = FavoriteMeal(
      id: meal.id,
      name: meal.name,
      thumbnail: meal.thumbnail,
      category: category,
    );

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                meal.thumbnail,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const SizedBox(height: 140, child: Center(child: Icon(Icons.broken_image))),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      meal.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Consumer<FavoritesProvider>(
                    builder: (ctx, provider, child) {
                      final isFavorite = provider.isFavorite(meal.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: onToggleFavorite,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}