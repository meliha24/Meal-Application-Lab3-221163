class Meal {
  final String id;
  final String name;
  final String thumbnail;
  bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.isFavorite = false, // default value
  });

  factory Meal.fromJsonFilter(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }
}
