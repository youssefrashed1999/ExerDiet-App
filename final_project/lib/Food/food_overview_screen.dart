import 'package:final_project/Food/food_tab.dart';
import 'package:final_project/Food/recipe_tab.dart';
import 'package:final_project/Food/yolo.dart';

import 'package:flutter/material.dart';

enum Options { none, image, frame, vision }

class FoodOverviewScreen extends StatefulWidget {
  static const routeName = '/food';

  const FoodOverviewScreen({super.key});

  @override
  State<FoodOverviewScreen> createState() => _FoodOverviewScreenState();
}

class _FoodOverviewScreenState extends State<FoodOverviewScreen>
    with SingleTickerProviderStateMixin {
  //meal id
  late int mealId;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  late TabController controller;
  @override
  Widget build(BuildContext context) {
    mealId = ModalRoute.of(context)!.settings.arguments as int;
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        color: Colors.grey.shade200,
        child: TabBarView(controller: controller, children: [
          FoodTab(
            mealId: mealId,
            nextPage: "https://exerdiet.pythonanywhere.com/diet/foods/",
            category: 'Food',
            mealDomain: 'meals',
          ),
          RecipeTab(mealId: mealId),
          FoodTab(
            mealId: mealId,
            nextPage: "https://exerdiet.pythonanywhere.com/diet/custom_foods/",
            category: 'CustomFood',
            mealDomain: 'meals',
          )
        ]),
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.blue,
        child: IconButton(
          icon: const Icon(
            Icons.camera,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(Yolo.routeName, arguments: mealId);
          },
        ),
      ),
    );
  }
}
