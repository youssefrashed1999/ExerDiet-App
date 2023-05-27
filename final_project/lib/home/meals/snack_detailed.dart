import 'package:final_project/Food/diet_recipe_item.dart';
import 'package:final_project/Food/food_overview_screen.dart';
import 'package:final_project/Food/recipe_detailed_item.dart';
import 'package:final_project/home/meals/food_instance_item.dart';
import 'package:final_project/models/diet_recipe.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/meal.dart';

class SnackDetailedScreen extends StatelessWidget {
  static const routeName = '/snack-detailed';
  late Meal meal;
  SnackDetailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    meal = ModalRoute.of(context)!.settings.arguments as Meal;
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(FoodOverviewScreen.routeName,
                    arguments: meal.id);
              },
              child: Text('Add more',
                  style: Theme.of(context).textTheme.titleMedium))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 7,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: meal.recipes.length + meal.food.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (index < meal.food.length) {
                  return FoodInstanceItem(food: meal.food[index]);
                } else {
                  return recipeItem(context, meal.recipes[index]);
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        ],
      ),
    );
  }
}

Widget recipeItem(BuildContext context, DietRecipe recipe) {
  final deviceSize = MediaQuery.of(context).size;
  return InkWell(
    onTap: () {
      Navigator.of(context)
          .pushNamed(RecipeDetailedItem.routeName, arguments: recipe);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: deviceSize.width,
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: recipe.imageUrl == null
                    ? null
                    : Image.network('$BASE_URL${recipe.imageUrl!}',
                        fit: BoxFit.fill),
              ),
              const SizedBox(
                width: 7,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.29,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        '${recipe.name}\n',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('calories: ${recipe.totalCalories} cal'),
                    Text('fats: ${recipe.totalFats} g'),
                    Text('protien: ${recipe.totalFats} g'),
                    Text('carbs: ${recipe.totalCarbs} g'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
