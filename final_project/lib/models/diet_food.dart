class DietFood {
  final int id;
  final String name;
  final String category;
  final int calories;
  final double fats;
  final double protein;
  final double carbs;
  final String? imageUrl;
  final int rate;

  DietFood(
      {required this.id,
      required this.name,
      this.category = 'food',
      required this.calories,
      required this.fats,
      required this.protein,
      required this.carbs,
      required this.imageUrl,
      this.rate = 0});
  factory DietFood.fromjson(Map<String, dynamic> json) {
    return DietFood(
        id: json['id'],
        name: json['name'],
        calories: json['calories'].toInt(),
        fats: json['fats'].toDouble(),
        protein: json['protein'].toDouble(),
        carbs: json['carbs'].toDouble(),
        imageUrl: json['image']);
  }
}
