
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Name',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                recipe.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Instructions',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                recipe.instructions!,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Nutrition Facts',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Total calories: ${recipe.totalCalories} cal',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Total Protein: ${recipe.totalProtein} g',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Total Carbs: ${recipe.totalCarbs} g',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Total Fats: ${recipe.totalFats} g',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Ingredients',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 16)),
              ),
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
    );
  }
}
