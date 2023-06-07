import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/diet_recipe.dart';
import 'package:http/http.dart' as http;

import 'add_recipe_screen.dart';
import 'diet_recipe_item.dart';

class RecipeTab extends StatefulWidget {
  final int mealId;
  const RecipeTab({super.key, required this.mealId});

  @override
  State<RecipeTab> createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab>
    with AutomaticKeepAliveClientMixin {
  List<DietRecipe> loadedrecipe = List.empty(growable: true);
  TextEditingController recipeController = TextEditingController();
  String? nextRecipePage = "https://exerdiet.pythonanywhere.com/diet/recipes/";
  bool isRecipeLoadingComplete = false;

  void getRecipe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextRecipePage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextRecipePage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedrecipe.add(
              DietRecipe.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isRecipeLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  void searchRecipe(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse('${nextRecipePage!}?search=$value'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextRecipePage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedrecipe.add(
              DietRecipe.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isRecipeLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    getRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
            controller: recipeController,
            //onChanged: (value) => updateList(value),
            style: const TextStyle(
                color: Color.fromARGB(255, 97, 219, 213), fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0x00000000),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              hintText: "eg: Orange",
              suffixIcon: InkWell(
                child: const Icon(Icons.search),
                onTap: () {
                  setState(() {
                    nextRecipePage =
                        "https://exerdiet.pythonanywhere.com/diet/recipes/";
                    loadedrecipe = List.empty(growable: true);
                    isRecipeLoadingComplete = false;
                  });
                  searchRecipe(recipeController.text);
                },
              ),
            ),
          ),
        ),
        if (isRecipeLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isRecipeLoadingComplete == true && loadedrecipe.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: nextRecipePage == null
                  ? loadedrecipe.length
                  : loadedrecipe.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextRecipePage != null && index == loadedrecipe.length) {
                  return ElevatedButton(
                      onPressed: () {
                        getRecipe();
                      },
                      child: const Text('Load more'));
                } else {
                  return DietRecipeItem(
                    recipe: loadedrecipe[index],
                    mealId: widget.mealId,
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Recipes found on Database!')),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(40), left: Radius.circular(40))),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddRecipeScreen.routeName);
              },
              child: const Text('create new recipe',
                  style: TextStyle(color: Colors.white))),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
