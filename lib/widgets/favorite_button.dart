import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_meal.dart';
import '../providers/favorites_provider.dart';

class FavoriteButton extends StatelessWidget {
  final FavoriteMeal meal;

  const FavoriteButton({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoritesProvider>(context);
    final isFavorite = provider.isFavorite(meal.id);

    return IconButton(
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      color: Colors.red,
      onPressed: () => provider.toggleFavorite(meal),
    );
  }
}
