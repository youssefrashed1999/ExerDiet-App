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
  String? nextPage = "https://exerdiet.pythonanywhere.com/diet/foods/";
  bool isFoodLoadingComplete = false;
  bool isRecipeLoadingComplete = false;
  bool isCustomFoodLoadingComplete = false;
  void getFood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextPage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextPage = jsonDecode(response.body)['next'];
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

  void getRecipe() async {}
  void getCustomFood() async {}

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
    getFood();
  }

  Widget tabWidget(List foodList, bool isLoadingComplete, String value) {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
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
                  print('im here');
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
                  nextPage == null ? foodList.length : foodList.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextPage != null && index == loadedfood.length) {
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
      body: TabBarView(controller: controller, children: [
        tabWidget(loadedfood, isFoodLoadingComplete, 'Food'),
        tabWidget(loadedrecipe, isRecipeLoadingComplete, 'Recipe'),
        tabWidget(loadedcustomfood, isCustomFoodLoadingComplete, 'Custom Food'),
      ]),
    );
  }
}
