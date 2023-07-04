import 'dart:convert';
import 'package:final_project/Food/recipe_detailed_item.dart';
import 'package:final_project/models/diet_recipe.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/diet_food.dart';

class DietRecipeItem extends StatelessWidget {
  DietRecipe recipe;
  late int mealId;
  DietRecipeItem({super.key, required this.recipe, required this.mealId});
  void addRecipe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response =
          await http.post(Uri.parse('${BASE_URL}diet/meals/$mealId/recipes/'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'JWT $accessKey'
              },
              body: jsonEncode(<String, dynamic>{'id': recipe.id}));

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: 'Recipe added successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      } else {
        Fluttertoast.showToast(
            msg: 'Error adding food!\nTry again later!',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  width: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        addRecipe();
                      },
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      iconSize: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
