import 'dart:convert';

import 'package:final_project/Food/food_overview_screen.dart';
import 'package:final_project/home/meals/food_instance_item.dart';
import 'package:final_project/models/diet_recipe.dart';
import 'package:final_project/models/food_instance.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/meal.dart';

class MealsScreen extends StatefulWidget with RouteAware {
  static const routeName = '/meal-screen';
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> with RouteAware {
  
  List<FoodInstance> loadedfood = List.empty(growable: true);
  List<DietRecipe> loadedRecipe = List.empty(growable: true);
  bool isLoadingComplete = false;
  int mealId = -1;
  late String mealName;
  late Meal meal;
  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    //check if there is a meal created today with the same name
    try {
      final response = await http.get(
        Uri.parse(
            '${BASE_URL}diet/meals/?search=$mealName&time_eaten__gte=${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['count'] == 1) {
          mealId = jsonDecode(response.body)['results'][0]['id'];
          int foodInstancesCount =
              jsonDecode(response.body)['results'][0]['food_instances'].length;
          for (int i = 0; i < foodInstancesCount; i++) {
            loadedfood.add(FoodInstance.fromjson(
                jsonDecode(response.body)['results'][0]['food_instances'][i]));
          }
          meal = Meal(
            id: jsonDecode(response.body)['results'][0]['id'],
            name: jsonDecode(response.body)['results'][0]['name'],
            timeEaten: jsonDecode(response.body)['results'][0]['time_eaten'],
            recipes: loadedRecipe,
            food: loadedfood,
            totalCalories: jsonDecode(response.body)['results'][0]
                ['total_calories'],
            totalCarbs: jsonDecode(response.body)['results'][0]['total_carbs']
                .toDouble(),
            totalFats: jsonDecode(response.body)['results'][0]['total_fats']
                .toDouble(),
            totalProtein: jsonDecode(response.body)['results'][0]
                    ['total_protein']
                .toDouble(),
          );
        }
        setState(() {
          isLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    loadData();    
  }

  @override
  void didPopNext() {
    super.didPopNext();
    setState(() {
      print('im here and this function works and you suck');
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    mealName = ModalRoute.of(context)!.settings.arguments as String;
    void showDetails() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Rate this'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Eaten in: ${DateFormat('EEE yyyy-MM-dd hh:mm a').format(DateTime.parse(meal.timeEaten))}'),
                    Text('total Calories: ${meal.totalCalories} cal'),
                    Text('total protein: ${meal.totalProtein} g'),
                    Text('total fats: ${meal.totalFats} g'),
                    Text('total carbs: ${meal.totalCarbs} g'),
                  ],
                )
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(mealName),
        actions: [
          if (mealId != -1)
            TextButton(
                onPressed: () {
                  showDetails();
                },
                child: Text('Total calories: ${meal.totalCalories.toString()}',
                    style: Theme.of(context).textTheme.titleMedium)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          if (isLoadingComplete == false) const CircularProgressIndicator(),
          if (isLoadingComplete == true &&
              (loadedRecipe.isEmpty && loadedfood.isEmpty))
            Center(child: Text('No $mealName added today!'))
          else
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: loadedfood.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                    FoodInstanceItem(food: loadedfood[index]),
                scrollDirection: Axis.vertical,
              ),
            ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(40),
                          left: Radius.circular(40))),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(FoodOverviewScreen.routeName);
                },
                child: const Text('Add more',
                    style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}
