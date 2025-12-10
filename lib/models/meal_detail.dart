class MealDetail {
  final String id;
  final String name;
  final String instructions;
  final String thumbnail;
  final String youtube;
  final Map<String, String> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    Map<String, String> ingredients = {};
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredients[ingredient.toString()] = measure.toString();
      }
    }

    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      youtube: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}
