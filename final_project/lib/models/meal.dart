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
}
