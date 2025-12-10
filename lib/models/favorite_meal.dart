class FavoriteMeal {
  final String id;
  final String name;
  final String thumbnail;
  final String category;

  FavoriteMeal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'category': category,
    };
  }

  factory FavoriteMeal.fromMap(Map<String, dynamic> map) {
    return FavoriteMeal(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
