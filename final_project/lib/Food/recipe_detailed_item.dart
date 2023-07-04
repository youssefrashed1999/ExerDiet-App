import 'package:final_project/constants.dart';
import 'package:final_project/home/meals/food_instance_item.dart';
import 'package:flutter/material.dart';

import '../models/diet_recipe.dart';

class RecipeDetailedItem extends StatelessWidget {
  static const routeName = '/recipe-details';
  late DietRecipe recipe;
  RecipeDetailedItem({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    recipe = ModalRoute.of(context)!.settings.arguments as DietRecipe;
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: deviceSize.height * 0.2,
                child: recipe.imageUrl != null
                    ? Image.network(
                        '$BASE_URL${recipe.imageUrl}',
                        fit: BoxFit.fitHeight,
                      )
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 8.0,
                child: Container(
                  constraints: BoxConstraints(minWidth: deviceSize.width * 0.8),
                  width: deviceSize.width * 0.8,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(recipe.name),
                      const Divider(
                        color: Color.fromARGB(255, 213, 211, 211),
                        height: 2,
                        thickness: 1,
                        indent: 0,
                        endIndent: 5,
                      ),
                      Text(
                        'Instructions:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(recipe.instructions!),
                      const Divider(
                        color: Color.fromARGB(255, 213, 211, 211),
                        height: 2,
                        thickness: 1,
                        indent: 0,
                        endIndent: 5,
                      ),
                      Text('Nutritional Facts:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Total calories: ${recipe.totalCalories} cal'),
                      Text('Total Protein: ${recipe.totalProtein} g'),
                      Text('Total Carbs: ${recipe.totalCarbs} g'),
                      Text('Total Fats: ${recipe.totalFats} g')
                    ],
                  ),
                ),
              ),
              Container(
                child: Text('Ingredients',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recipe.ingredients.length,
                itemBuilder: (BuildContext context, int index) =>
                    FoodInstanceItem(food: recipe.ingredients[index]),
                scrollDirection: Axis.vertical,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
