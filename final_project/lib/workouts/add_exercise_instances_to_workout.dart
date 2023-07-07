import 'dart:convert';
import 'package:final_project/home/home_page_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/exercise.dart';
import 'exercise_item.dart';

class AddExerciseInsances extends StatefulWidget {
  static const routeName = '/add-exercise-instance-to-workout';
  const AddExerciseInsances({super.key});

  @override
  State<AddExerciseInsances> createState() => _AddExerciseInsancesState();
}

class _AddExerciseInsancesState extends State<AddExerciseInsances>
    with SingleTickerProviderStateMixin {
  //food tab controllers and attributes
  List<Execise> loadedexercise = List.empty(growable: true);
  String? nextExercisePage =
      "https://exerdiet.pythonanywhere.com/gym/exercises/";
  TextEditingController exerciseController = TextEditingController();
  bool isExerciseLoadingComplete = false;

  //custom food tab controllers and attributes
  List<Execise> loadedcustomExercise = List.empty(growable: true);
  TextEditingController customExerciseController = TextEditingController();
  String? nextCustomExercisePage =
      "https://exerdiet.pythonanywhere.com/gym/custom_exercises/";
  bool isCustomExerciseLoadingComplete = false;
  //meal id
  late int workoutId;
  void getExercise() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextExercisePage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextExercisePage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedexercise
              .add(Execise.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isExerciseLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  void getCustomExercise() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextCustomExercisePage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextCustomExercisePage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedcustomExercise
              .add(Execise.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isCustomExerciseLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  //search methods
  void searchFood(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse('${nextExercisePage!}?search=$value'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextExercisePage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedexercise
              .add(Execise.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isExerciseLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  void searchCustomFood(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse('${nextCustomExercisePage!}?search=$value'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextCustomExercisePage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedcustomExercise
              .add(Execise.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isCustomExerciseLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  //widgets
  Widget ExerciseTab() {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
            controller: exerciseController,
            //onChanged: (value) => updateList(value),
            style: const TextStyle(
                color: Color.fromARGB(255, 97, 219, 213), fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0x00000000),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              hintText: "eg: Push ups",
              suffixIcon: InkWell(
                child: const Icon(Icons.search),
                onTap: () {
                  setState(() {
                    nextExercisePage =
                        "https://exerdiet.pythonanywhere.com/gym/exercises/";

                    loadedexercise = List.empty(growable: true);
                    isExerciseLoadingComplete = false;
                  });
                  searchFood(exerciseController.text);
                },
              ),
            ),
          ),
        ),
        if (isExerciseLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isExerciseLoadingComplete == true && loadedexercise.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: nextExercisePage == null
                  ? loadedexercise.length
                  : loadedexercise.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextExercisePage != null &&
                    index == loadedexercise.length) {
                  return ElevatedButton(
                      onPressed: () {
                        getExercise();
                      },
                      child: const Text('Load more'));
                } else {
                  return ExerciseItem(
                    exercise: loadedexercise[index],
                    exerciseId: workoutId,
                    exerciseDomain: 'workouts',
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Exercise found on Database!')),
      ],
    );
  }

  Widget customExerciseTab() {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
            controller: customExerciseController,
            //onChanged: (value) => updateList(value),
            style: const TextStyle(
                color: Color.fromARGB(255, 97, 219, 213), fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0x00000000),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              hintText: "eg: Push ups",
              suffixIcon: InkWell(
                child: const Icon(Icons.search),
                onTap: () {
                  setState(() {
                    nextCustomExercisePage =
                        "https://exerdiet.pythonanywhere.com/gym/custom_exercises/";
                    loadedcustomExercise = List.empty(growable: true);
                    isCustomExerciseLoadingComplete = false;
                  });
                  searchCustomFood(customExerciseController.text);
                },
              ),
            ),
          ),
        ),
        if (isCustomExerciseLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isCustomExerciseLoadingComplete == true &&
            loadedcustomExercise.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: nextCustomExercisePage == null
                  ? loadedcustomExercise.length
                  : loadedcustomExercise.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextCustomExercisePage != null &&
                    index == loadedcustomExercise.length) {
                  return ElevatedButton(
                      onPressed: () {
                        getCustomExercise();
                      },
                      child: const Text('Load more'));
                } else {
                  return ExerciseItem(
                    exercise: loadedcustomExercise[index],
                    exerciseId: workoutId,
                    exerciseDomain: 'workouts',
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Custom Exercise found on Database!')),
      ],
    );
  }

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
    getExercise();
    getCustomExercise();
  }

  late TabController controller;
  @override
  Widget build(BuildContext context) {
    workoutId = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
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
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
        bottom: TabBar(
            controller: controller,
            unselectedLabelStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black, fontWeight: FontWeight.normal),
            unselectedLabelColor: Colors.grey.shade200,
            labelColor: Colors.white,
            labelStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            tabs: const [
              Padding(
                  padding: EdgeInsets.only(bottom: 2), child: Text('Exercise')),
              Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text('My Exercise')),
            ]),
      ),
      body: TabBarView(
          controller: controller,
          children: [ExerciseTab(), customExerciseTab()]),
    );
  }
}
