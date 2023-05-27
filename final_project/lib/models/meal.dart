import 'package:final_project/models/diet_recipe.dart';
import 'package:final_project/models/food_instance.dart';

class Meal {
  int id;
  String name;
  String timeEaten;
  List<DietRecipe> recipes;
  List<FoodInstance> food;
  int totalCalories;
  double totalCarbs;
  double totalProtein;
  double totalFats;
  Meal({
    required this.id,
    required this.name,
    required this.timeEaten,
    required this.recipes,
    required this.food,
    required this.totalCalories,
    required this.totalCarbs,
    required this.totalFats,
    required this.totalProtein,
  });
  factory Meal.fromjson(Map<String, dynamic> json) {
    List<DietRecipe> recipeList = List.empty(growable: true);
    List<FoodInstance> foodList = List.empty(growable: true);
    for (int i = 0; i < json['food_instances'].length; i++) {
      foodList.add(FoodInstance.fromjson(json['food_instances'][i]));
    }
    for (int i = 0; i < json['recipes'].length; i++) {
      recipeList.add(DietRecipe.fromjson(json['recipes'][i]));
    }
    return Meal(
      id: json['id'],
      name: json['name'],
      timeEaten: json['time_eaten'].toString(),
      recipes: recipeList,
      food: foodList,
      totalCalories: json['total_calories'].toInt(),
      totalCarbs: json['total_carbs'].toDouble(),
      totalFats: json['total_fats'].toDouble(),
      totalProtein: json['total_protein'].toDouble()
    );
  }
}
