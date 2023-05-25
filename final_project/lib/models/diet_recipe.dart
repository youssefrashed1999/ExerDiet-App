import 'package:final_project/models/food_instance.dart';

class DietRecipe {
  final String id;
  final String name;
  final List<FoodInstance> ingredients;
  final String instructions;
  final String imageUrl;

  DietRecipe(
      this.id, this.name, this.instructions, this.imageUrl, this.ingredients);
}
