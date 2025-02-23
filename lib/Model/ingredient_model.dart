class Ingredient {
  final String name;
  final String category;
  final double calories;
  final String imageUrl;

  Ingredient({
    required this.name,
    required this.category,
    required this.calories,
    required this.imageUrl,
  });

  factory Ingredient.fromFirestore(Map<String, dynamic> data) {
    return Ingredient(
      name: data['food_name'] ?? '',
      category: data['category'] ?? '',
      calories: (data['calories'] ?? 0).toDouble(),
      imageUrl: data['image_url'] ?? '',
    );
  }
}