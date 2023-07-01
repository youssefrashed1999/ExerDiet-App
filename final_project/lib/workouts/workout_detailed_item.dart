import 'package:final_project/constants.dart';
import 'package:final_project/workouts/exercise_instance_item.dart';
import 'package:flutter/material.dart';

import '../models/workout.dart';

class WorkoutDetailedItem extends StatelessWidget {
  static const routeName = '/workout-details';
  late Workout workout;
  WorkoutDetailedItem({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    workout = ModalRoute.of(context)!.settings.arguments as Workout;
    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: deviceSize.height * 0.2,
              child: workout.imageUrl != null
                  ? Image.network(
                      '$BASE_URL${workout.imageUrl}',
                      fit: BoxFit.fitHeight,
                    )
                  : null,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Name',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                workout.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Instructions',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                workout.instructions!,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Details',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Total calories burnt: ${workout.totalCaloriesBurnt} cal',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text('Exercises',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontSize: 16)),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workout.exerciseInstance.length,
              itemBuilder: (BuildContext context, int index) =>
                  ExerciseInstanceItem(
                      exercise: workout.exerciseInstance[index]),
              scrollDirection: Axis.vertical,
            ),
          ],
        ),
      ),
    );
  }
}
