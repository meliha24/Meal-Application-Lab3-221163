// lib/screens/categories_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meals_provider.dart';
import '../models/favorite_meal.dart';
import 'meals_by_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<MealsProvider>(context, listen: false)
          .loadCategories()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }


  Future<void> _fetchRandomMeal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<MealsProvider>(context, listen: false);
      final randomMealDetail = await provider.loadRandomMealDetail();

      setState(() {
        _isLoading = false;
      });


      final favoriteMeal = FavoriteMeal(
        id: randomMealDetail.id,
        name: randomMealDetail.name,
        thumbnail: randomMealDetail.thumbnail,
        category: "Random",
      );

      Navigator.of(context).pushNamed(
        '/meal-detail',
        arguments: favoriteMeal,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch random meal.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MealsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: "Random Recipe",
            onPressed: _isLoading ? null : _fetchRandomMeal,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: provider.categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) {
          final cat = provider.categories[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MealsByCategoryScreen(category: cat.name),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        cat.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      cat.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}