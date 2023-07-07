import 'package:final_project/workouts/workout_detailed_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../constants.dart';
import '../models/workout.dart';

class WorkoutPerformedItem extends StatelessWidget {
  Workout workout;
  WorkoutPerformedItem({super.key,required this.workout});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(WorkoutDetailedItem.routeName, arguments: workout);
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
                  child: workout.imageUrl == null
                      ? null
                      : Image.network('$BASE_URL${workout.imageUrl!}',
                          fit: BoxFit.fill),
                ),
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
                          '${workout.name}\n',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text('calories Burnt: ${workout.totalCaloriesBurnt} cal'),
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
