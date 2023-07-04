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
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
              Card(
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 8.0,
                child: Container(
                  constraints: BoxConstraints(minWidth: deviceSize.width * 0.8),
                  width: deviceSize.width * 0.8,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(workout.name),
                      const Divider(
                        color: Color.fromARGB(255, 213, 211, 211),
                        height: 2,
                        thickness: 1,
                        indent: 0,
                        endIndent: 5,
                      ),
                      Text(
                        'Instructions:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(workout.instructions!),
                      const Divider(
                        color: Color.fromARGB(255, 213, 211, 211),
                        height: 2,
                        thickness: 1,
                        indent: 0,
                        endIndent: 5,
                      ),
                      Text('Nutritional Facts:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'Total Calories Burnt: ${workout.totalCaloriesBurnt} cal'),
                    ],
                  ),
                ),
              ),
              Container(
                child: Text('Ingredients',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
