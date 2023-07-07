import 'package:final_project/Food/add_water_screen.dart';

import 'package:final_project/home/meals/meals_screen.dart';
import 'package:final_project/home/meals/performed_workouts_screen.dart';
import 'package:flutter/material.dart';

import 'meals/snacks_screen.dart';

class AddingButtons extends StatelessWidget {
  const AddingButtons({super.key});
  void _navigateToFoodList(BuildContext context, String mealName) {
    Navigator.of(context).pushNamed(MealsScreen.routeName, arguments: mealName);
  }

  void _naviagateToSnackList(BuildContext context) {
    Navigator.of(context).pushNamed(SnackScreen.routeName);
  }

  void _navigateToAddWater(BuildContext context) {
    Navigator.of(context).pushNamed(AddWater.routeName);
  }

  void _navigateToAddWorkoutList(
      BuildContext context, String performedWorkoutName) {
    Navigator.of(context).pushNamed(PerformedWorkoutsScreen.routeName,
        arguments: performedWorkoutName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image:
                    const AssetImage('assets/images/breakfast_background.jpg'),
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken))),
        child: ListTile(
          title: Text(
            'Add Breakfast',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          trailing: const Icon(
            Icons.navigate_next_outlined,
            color: Colors.white,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onTap: () => _navigateToFoodList(context, 'breakfast'),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: const AssetImage('assets/images/lunch_background.jpeg'),
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken))),
        child: ListTile(
            title: Text(
              'Add Lunch',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            trailing: const Icon(
              Icons.navigate_next_outlined,
              color: Colors.white,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () => _navigateToFoodList(context, 'lunch')),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: const AssetImage('assets/images/dinner_background.jpg'),
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken))),
        child: ListTile(
            title: Text(
              'Add Dinner',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            trailing: const Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () => _navigateToFoodList(context, 'dinner')),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: const AssetImage('assets/images/snack_background.jpg'),
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken))),
        child: ListTile(
            title: Text(
              'Add Snack',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            trailing: const Icon(
              Icons.navigate_next_rounded,
              color: Colors.white,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () => _naviagateToSnackList(context)),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: const AssetImage('assets/images/workout_background.jpg'),
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken))),
        child: ListTile(
            title: Text(
              'Add Workout',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            trailing: const Icon(
              Icons.navigate_next_outlined,
              color: Colors.white,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () => _navigateToAddWorkoutList(context, 'workout')),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: const AssetImage('assets/images/water_background.jpg'),
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken))),
        child: ListTile(
            title: Text(
              'Add Water',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            trailing: const Icon(
              Icons.navigate_next_outlined,
              color: Colors.white,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onTap: () => _navigateToAddWater(context)),
      ),
    ]);
  }
}
