import 'package:final_project/Food/food_tab.dart';
import 'package:final_project/home/home_page_screen.dart';

import 'package:flutter/material.dart';

class AddFoodInsances extends StatefulWidget {
  static const routeName = '/add-food-instance-to-recipe';
  const AddFoodInsances({super.key});

  @override
  State<AddFoodInsances> createState() => _AddFoodInsancesState();
}

class _AddFoodInsancesState extends State<AddFoodInsances>
    with SingleTickerProviderStateMixin {
  //meal id
  late int recipeId;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
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
      body: TabBarView(controller: controller, children: [
        FoodTab(
            mealId: recipeId,
            category: 'Food',
            nextPage: "https://exerdiet.pythonanywhere.com/diet/foods/",
            mealDomain: 'recipes'),
        FoodTab(
            mealId: recipeId,
            category: 'CustomFood',
            nextPage: "https://exerdiet.pythonanywhere.com/diet/custom_foods/",
            mealDomain: 'recipes')
      ]),
    );
  }
}
