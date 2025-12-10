// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProv = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProv.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorite meals yet."))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (ctx, i) {
          final meal = favorites[i];
          return ListTile(
            leading: Image.network(
              meal.thumbnail,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
            ),
            title: Text(meal.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                favoritesProv.toggleFavorite(meal);
              },
            ),
            onTap: () {

              Navigator.of(context).pushNamed(
                '/meal-detail',
                arguments: meal,
              );
            },
          );
        },
      ),
    );
  }
}