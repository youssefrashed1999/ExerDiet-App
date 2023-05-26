import 'diet_food.dart';

class FoodInstance {
  int id;
  DietFood food;
  double quantity;
  int totalCalories;
  double totalCarbs;
  double totalFats;
  double totalProtein;
  FoodInstance(
      {required this.id,
      required this.food,
      required this.quantity,
      required this.totalCalories,
      required this.totalCarbs,
      required this.totalFats,
      required this.totalProtein});
  factory FoodInstance.fromjson(Map<String, dynamic> json) {
    return FoodInstance(
        id: json['id'],
        food: DietFood.fromjsonMeal(json['food']),
        quantity: json['quantity'],
        totalCalories: json['total_calories'].toInt(),
        totalCarbs: json['total_carbs'].toDouble(),
        totalFats: json['total_fats'].toDouble(),
        totalProtein: json['total_protein']);
  }
}
