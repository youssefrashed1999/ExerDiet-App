import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/diet_food.dart';
import 'diet_food_item.dart';
import 'package:http/http.dart' as http;

class FoodOverviewScreen extends StatefulWidget {
  static const routeName = '/food';

  @override
  State<FoodOverviewScreen> createState() => _FoodOverviewScreenState();
}

class _FoodOverviewScreenState extends State<FoodOverviewScreen>
    with SingleTickerProviderStateMixin {
  List<DietFood> loadedfood = List.empty(growable: true);
  List<DietFood> loadedrecipe = List.empty(growable: true);
  List<DietFood> loadedcustomfood = List.empty(growable: true);
  TextEditingController foodController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController customFoodController = TextEditingController();
  String? nextFoodPage = "https://exerdiet.pythonanywhere.com/diet/foods/";
  String? nextRecipePage = "https://exerdiet.pythonanywhere.com/diet/recipes/";
  String? nextCustomFoodPage =
      "https://exerdiet.pythonanywhere.com/diet/custom_foods/";
  bool isFoodLoadingComplete = false;
  bool isRecipeLoadingComplete = false;
  bool isCustomFoodLoadingComplete = false;
  void getFood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextFoodPage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextFoodPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedfood
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isFoodLoadingComplete = true;
        });
      }
    } catch (e) {
      print('problem is $e');
    }
  }

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
          loadedrecipe
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isRecipeLoadingComplete = true;
        });
      }
    } catch (e) {
      print('problem is $e');
    }
  }

  void getCustomFood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextCustomFoodPage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextCustomFoodPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedcustomfood
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isCustomFoodLoadingComplete = true;
        });
      }
    } catch (e) {
      print('problem is $e');
    }
  }

  void searchFood(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse('${nextFoodPage!}?search=$value'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextFoodPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedfood
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isFoodLoadingComplete = true;
        });
      }
    } catch (e) {
      print('problem is $e');
    }
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
          loadedrecipe
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isRecipeLoadingComplete = true;
        });
      }
    } catch (e) {
      print('problem is $e');
    }
  }

  void searchCustomFood(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse('${nextCustomFoodPage!}?search=$value'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextCustomFoodPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedcustomfood
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isCustomFoodLoadingComplete = true;
        });
      }
    } catch (e) {
      print('problem is $e');
    }
  }

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
    getFood();
    getRecipe();
    getCustomFood();
  }

  Widget foodTab() {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
            controller: foodController,
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
                    nextFoodPage =
                        "https://exerdiet.pythonanywhere.com/diet/foods/";

                    loadedfood = List.empty(growable: true);
                    isFoodLoadingComplete = false;
                  });
                  searchFood(foodController.text);
                },
              ),
            ),
          ),
        ),
        if (isFoodLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isFoodLoadingComplete == true && loadedfood.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: nextFoodPage == null
                  ? loadedfood.length
                  : loadedfood.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextFoodPage != null && index == loadedfood.length) {
                  return ElevatedButton(
                      onPressed: () {
                        getFood();
                      },
                      child: const Text('Load more'));
                } else {
                  return DietFoodItem(
                    id: loadedfood[index].id,
                    name: loadedfood[index].name,
                    imageUrl: loadedfood[index].imageUrl,
                    calories: loadedfood[index].calories,
                    fats: loadedfood[index].fats,
                    protein: loadedfood[index].protein,
                    carbs: loadedfood[index].carbs,
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Food found on Database!')),
      ],
    );
  }

  Widget recipeTab() {
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
                  return DietFoodItem(
                    id: loadedrecipe[index].id,
                    name: loadedrecipe[index].name,
                    imageUrl: loadedrecipe[index].imageUrl,
                    calories: loadedrecipe[index].calories,
                    fats: loadedrecipe[index].fats,
                    protein: loadedrecipe[index].protein,
                    carbs: loadedrecipe[index].carbs,
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
              onPressed: () {},
              child: const Text('create new recipe',
                  style: TextStyle(color: Colors.white))),
        ),
      ],
    );
  }

  Widget myFoodTab() {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
            controller: customFoodController,
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
                    nextCustomFoodPage =
                        "https://exerdiet.pythonanywhere.com/diet/custom_foods/";
                    loadedcustomfood = List.empty(growable: true);
                    isCustomFoodLoadingComplete = false;
                  });
                  searchCustomFood(customFoodController.text);
                },
              ),
            ),
          ),
        ),
        if (isCustomFoodLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isCustomFoodLoadingComplete == true &&
            loadedcustomfood.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: nextCustomFoodPage == null
                  ? loadedcustomfood.length
                  : loadedcustomfood.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextCustomFoodPage != null &&
                    index == loadedcustomfood.length) {
                  return ElevatedButton(
                      onPressed: () {
                        getCustomFood();
                      },
                      child: const Text('Load more'));
                } else {
                  return DietFoodItem(
                    id: loadedcustomfood[index].id,
                    name: loadedcustomfood[index].name,
                    imageUrl: loadedcustomfood[index].imageUrl,
                    calories: loadedcustomfood[index].calories,
                    fats: loadedcustomfood[index].fats,
                    protein: loadedcustomfood[index].protein,
                    carbs: loadedcustomfood[index].carbs,
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Custom Food found on Database!')),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(40), left: Radius.circular(40))),
              ),
              onPressed: () {},
              child: const Text('create new food',
                  style: TextStyle(color: Colors.white))),
        ),
      ],
    );
  }

  Widget tabWidget(List foodList, bool isLoadingComplete, String value,
      Function load, Function search) {
    TextEditingController controller = TextEditingController();
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
            controller: controller,
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
                    if (value == 'Food') {
                      nextFoodPage =
                          "https://exerdiet.pythonanywhere.com/diet/foods/";
                    } else if (value == 'Recipe') {
                      nextRecipePage =
                          "https://exerdiet.pythonanywhere.com/diet/recipes/";
                    } else {
                      nextCustomFoodPage =
                          "https://exerdiet.pythonanywhere.com/diet/custom_foods/";
                    }
                    foodList = List.empty(growable: true);
                    isLoadingComplete = false;
                  });
                  search(controller.value);
                },
              ),
            ),
          ),
        ),
        if (isLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isLoadingComplete == true && foodList.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount:
                  nextFoodPage == null ? foodList.length : foodList.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextFoodPage != null && index == loadedfood.length) {
                  return ElevatedButton(
                      onPressed: () {
                        load();
                      },
                      child: const Text('Load more'));
                } else {
                  return DietFoodItem(
                    id: loadedfood[index].id,
                    name: loadedfood[index].name,
                    imageUrl: loadedfood[index].imageUrl,
                    calories: loadedfood[index].calories,
                    fats: loadedfood[index].fats,
                    protein: loadedfood[index].protein,
                    carbs: loadedfood[index].carbs,
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          Center(child: Text('No $value found on Database!')),
        if (value != 'Food')
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(40),
                          left: Radius.circular(40))),
                ),
                onPressed: () {},
                child: Text('create new $value',
                    style: const TextStyle(color: Colors.white))),
          ),
      ],
    );
  }

  late TabController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        bottom: TabBar(
            controller: controller,
            unselectedLabelStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black, fontWeight: FontWeight.normal),
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            labelStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            tabs: const [
              Padding(padding: EdgeInsets.only(bottom: 2), child: Text('Food')),
              Padding(
                  padding: EdgeInsets.only(bottom: 2), child: Text('Recipe')),
              Padding(
                  padding: EdgeInsets.only(bottom: 2), child: Text('My Food')),
            ]),
      ),
      body: TabBarView(
          controller: controller,
          children: [foodTab(), recipeTab(), myFoodTab()]),
    );
  }
}
