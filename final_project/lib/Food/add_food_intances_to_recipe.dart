import 'dart:convert';
import 'package:final_project/home/home_page_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/diet_food.dart';
import 'diet_food_item.dart';

class AddFoodInsances extends StatefulWidget {
  static const routeName = '/add-food-instance-to-recipe';
  const AddFoodInsances({super.key});

  @override
  State<AddFoodInsances> createState() => _AddFoodInsancesState();
}

class _AddFoodInsancesState extends State<AddFoodInsances>
    with SingleTickerProviderStateMixin {
  //food tab controllers and attributes
  List<DietFood> loadedfood = List.empty(growable: true);
  String? nextFoodPage = "https://exerdiet.pythonanywhere.com/diet/foods/";
  TextEditingController foodController = TextEditingController();
  bool isFoodLoadingComplete = false;
  //custom food tab controllers and attributes
  List<DietFood> loadedcustomfood = List.empty(growable: true);
  TextEditingController customFoodController = TextEditingController();
  String? nextCustomFoodPage =
      "https://exerdiet.pythonanywhere.com/diet/custom_foods/";
  bool isCustomFoodLoadingComplete = false;
  //meal id
  late int recipeId;
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
    } catch (_) {}
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
    } catch (_) {}
  }

  //search methods
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
    } catch (_) {}
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
    } catch (_) {}
  }

  //widgets
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
                    dietFood: loadedfood[index],
                    mealId: recipeId,
                    mealDomain: 'recipes',
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

  Widget customFoodTab() {
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
                    dietFood: loadedcustomfood[index],
                    mealId: recipeId,
                    mealDomain: 'recipes',
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Custom Food found on Database!')),
      ],
    );
  }

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
    getFood();
    getCustomFood();
  }

  late TabController controller;
  @override
  Widget build(BuildContext context) {
    recipeId = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(HomePageScreen.routeName);
              },
              child: Text(
                'Done',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ))
        ],
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
                  padding: EdgeInsets.only(bottom: 2), child: Text('My Food')),
            ]),
      ),
      body: TabBarView(
          controller: controller, children: [foodTab(), customFoodTab()]),
    );
  }
}
