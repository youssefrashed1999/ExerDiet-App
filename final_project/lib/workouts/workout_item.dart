import 'dart:convert';
import 'package:final_project/workouts/workout_detailed_item.dart';
import 'package:final_project/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/exercise.dart';

class WorkoutItem extends StatelessWidget {
  Workout workout;
  late int exerciseId;
  WorkoutItem({super.key, required this.workout, required this.exerciseId});
  void addWorkout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.post(
          Uri.parse('${BASE_URL}gym/performed_workouts/$exerciseId/workouts/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'JWT $accessKey'
          },
          body: jsonEncode(<String, dynamic>{'id': workout.id}));

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: 'Workout added successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      } else {
        Fluttertoast.showToast(
            msg: 'Error adding exercise!\nTry again later!',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      }
    } catch (_) {}
  }

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
                  width: MediaQuery.of(context).size.width * 0.29,
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
                const SizedBox(
                  width: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        addWorkout();
                      },
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      iconSize: 40,
                      color: const Color.fromARGB(255, 97, 219, 213),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
