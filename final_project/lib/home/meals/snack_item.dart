import 'package:final_project/home/meals/snack_detailed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/meal.dart';

class SnackItem extends StatelessWidget {
  Meal meal;
  SnackItem({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(SnackDetailedScreen.routeName, arguments: meal);
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
                const SizedBox(
                  width: 7,
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          '${meal.name}\n',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FittedBox(
                          child: Text(
                              'Eaten in: ${DateFormat('EEE yyyy-MM-dd hh:mm a').format(DateTime.parse(meal.timeEaten))}')),
                      FittedBox(
                          child:
                              Text('total calories: ${meal.totalCalories} g')),
                      FittedBox(child: Text('total fats: ${meal.totalFats} g')),
                      FittedBox(
                          child: Text('total protien: ${meal.totalProtein} g')),
                      FittedBox(
                          child: Text('total carbs: ${meal.totalCarbs} g')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
