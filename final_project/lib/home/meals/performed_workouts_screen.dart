import 'dart:convert';

import 'package:final_project/workouts/exercise_instance_item.dart';
import 'package:final_project/models/workout.dart';
import 'package:final_project/models/exercise_instance.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../workouts/exercise_overview_screen.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/performed_workouts.dart';

class PerformedWorkoutsScreen extends StatefulWidget with RouteAware {
  static const routeName = '/performedworkout-screen';
  const PerformedWorkoutsScreen({super.key});

  @override
  State<PerformedWorkoutsScreen> createState() =>
      _PerformedWorkoutsScreenState();
}

class _PerformedWorkoutsScreenState extends State<PerformedWorkoutsScreen>
    with RouteAware {
  List<ExerciseInstance> loadedExercise = List.empty(growable: true);
  List<Workout> loadedWorkout = List.empty(growable: true);
  bool isLoadingComplete = false;
  int performedWorkoutId = -1;
  late String performedWorkoutName;
  PerformedWorkout? performedWorkout;
  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    //check if there is a performed workout created today with the same name
    try {
      final response = await http.get(
        Uri.parse(
            '${BASE_URL}gym/performed_workouts/?search=$performedWorkoutName&time_performed__gte=${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['count'] == 1) {
          performedWorkoutId = jsonDecode(response.body)['results'][0]['id'];
          int exerciseInstancesCount = jsonDecode(response.body)['results'][0]
                  ['exercise_instances']
              .length;
          for (int i = 0; i < exerciseInstancesCount; i++) {
            loadedExercise.add(ExerciseInstance.fromjson(
                jsonDecode(response.body)['results'][0]['exercise_instances']
                    [i]));
          }
          //TO-DO
          //Display recipes also
          performedWorkout = PerformedWorkout(
            id: jsonDecode(response.body)['results'][0]['id'],
            name: jsonDecode(response.body)['results'][0]['name'],
            timePerformed: jsonDecode(response.body)['results'][0]
                ['time_performed'],
            workouts: loadedWorkout,
            exercise: loadedExercise,
            totalCaloriesBurnt: jsonDecode(response.body)['results'][0]
                ['total_calories'],
          );
        }
        setState(() {
          isLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  void createPerformedWorkout() async {
    if (performedWorkoutId == -1) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? accessKey = prefs.getString(ACCESS_KEY);
        final response = await http.post(
            Uri.parse('${BASE_URL}gym/performed_workouts/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'JWT $accessKey'
            },
            body: jsonEncode(<String, String>{'name': performedWorkoutName}));
        if (response.statusCode == 201) {
          performedWorkoutId = jsonDecode(response.body)['id'];
        }
      } catch (_) {}
    }
    if (!context.mounted) return;
    Navigator.of(context).pushNamed(ExerciseOverviewScreen.routeName,
        arguments: performedWorkoutId);
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
      loadedExercise = List.empty(growable: true);
      loadedWorkout = List.empty(growable: true);
      isLoadingComplete = false;
      setState(() {
        loadData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    performedWorkoutName = ModalRoute.of(context)!.settings.arguments as String;
    void showDetails() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Rate this'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  performedWorkout!.name,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Eaten in: ${DateFormat('EEE yyyy-MM-dd hh:mm a').format(DateTime.parse(performedWorkout!.timePerformed))}'),
                    Text(
                        'total Calories Burnt: ${performedWorkout!.totalCaloriesBurnt} cal'),
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
        title: Text(performedWorkoutName),
        actions: [
          if (performedWorkoutId != -1)
            TextButton(
                onPressed: () {
                  showDetails();
                },
                child: Text(
                    'Total calories Burnt: ${performedWorkout!.totalCaloriesBurnt.toString()}',
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
              (loadedWorkout.isEmpty && loadedExercise.isEmpty))
            Center(child: Text('No workout added today!'))
          else
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: loadedExercise.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                    ExerciseInstanceItem(exercise: loadedExercise[index]),
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
                  createPerformedWorkout();
                },
                child: const Text('Add more',
                    style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}
