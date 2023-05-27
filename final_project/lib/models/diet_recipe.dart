import 'package:final_project/models/food_instance.dart';

class DietRecipe {
  final int id;
  final String name;
  final List<FoodInstance> ingredients;
  final String? instructions;
  final String? imageUrl;
  final int totalCalories;
  final double totalCarbs;
  final double totalProtein;
  final double totalFats;

  DietRecipe(
      {required this.id,
      required this.name,
      required this.instructions,
      required this.imageUrl,
      required this.ingredients,
      required this.totalCalories,
      required this.totalCarbs,
      required this.totalFats,
      required this.totalProtein});
  factory DietRecipe.fromjson(Map<String, dynamic> json) {
    List<FoodInstance> dummyList = List.empty(growable: true);
    for (int i = 0; i < json['food_instances'].length; i++) {
      dummyList.add(FoodInstance.fromjson(json['food_instances'][i]));
    }
    return DietRecipe(
        id: json['id'],
        name: json['name'],
        instructions: json['instructions'],
        imageUrl: json['image'],
        ingredients: dummyList,
        totalCalories: json['total_calories'].toInt(),
        totalCarbs: json['total_carbs'].toDouble(),
        totalFats: json['total_fats'].toDouble(),
        totalProtein: json['total_protein'].toDouble());
  }
}
