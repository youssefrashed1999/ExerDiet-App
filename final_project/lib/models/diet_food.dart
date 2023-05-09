class DietFood {
  final String id;
  final String name;
  final double calories;
  final double fats;
  final double protein;
  final double carbs;
  final String imageUrl;
  final int rate;

  DietFood(
      {required this.id,
      required this.name,
      required this.calories,
      required this.fats,
      required this.protein,
      required this.carbs,
      required this.imageUrl,
      this.rate = 0});
}
