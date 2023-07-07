import 'dart:convert';

import 'package:final_project/workouts/add_exercise_screen.dart';
import 'package:final_project/workouts/add_workout_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/workouts/filter.dart';
import 'package:final_project/workouts/sort.dart';
import '../constants.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import 'exercise_item.dart';
import 'workout_item.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  static const routeName = '/exercise';

  const ExerciseOverviewScreen({super.key});

  @override
  State<ExerciseOverviewScreen> createState() => _ExerciseOverviewScreenState();
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen>
    with SingleTickerProviderStateMixin {
  Map<String, String> _filterData = {
    'search': '',
    'body_part': '',
    'calories_less_than': '',
    'calories_greater_than': '',
    'ordering': '',
  };
  //exercise tab controllers and attributes

  List<Execise> loadedexercise = List.empty(growable: true);
  String? nextExercisePage =
      "https://exerdiet.pythonanywhere.com/gym/exercises/";
  TextEditingController exerciseController = TextEditingController();
  bool isExerciseLoadingComplete = false;

  //workout tab controllers and attributes
  List<Workout> loadedworkout = List.empty(growable: true);
  TextEditingController workoutController = TextEditingController();
  String? nextWorkoutPage = "https://exerdiet.pythonanywhere.com/gym/workouts/";
  bool isWorkoutLoadingComplete = false;
  //custom exercise tab controllers and attributes
  List<Execise> loadedcustomexercise = List.empty(growable: true);
  TextEditingController customExerciseController = TextEditingController();
  String? nextCustomExercisePage =
      "https://exerdiet.pythonanywhere.com/gym/custom_exercises/";
  bool isCustomExerciseLoadingComplete = false;

  //exercise id
  late int exerciseId;
  //get exercise-workouts-custom exercise functions
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

  void getWorkout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextWorkoutPage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextWorkoutPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedworkout
              .add(Workout.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isWorkoutLoadingComplete = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
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
          loadedcustomexercise
              .add(Execise.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isCustomExerciseLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  //search methods
  void searchExercise() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    String query = createSearchQuery();
    try {
      final response = await http.get(
        Uri.parse('${nextExercisePage!}?$query'),
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

  void setFilteredData(Map<String, String> data) {
    _filterData['body_part'] = data['body_part']!;
    _filterData['calories_less_than'] = data['calories_less_than']!;
    _filterData['calories_greater_than'] = data['calories_greater_than']!;
  }

  void resetFilteredData() {
    exerciseController.text = '';
    _filterData['body_part'] = '';
    _filterData['calories_less_than'] = '';
    _filterData['calories_greater_than'] = '';
    _filterData['search'] = '';
    _filterData['ordering'] = '';
  }

  void setOrderingMethod(String value) {
    _filterData['ordering'] = value;
  }

  String createSearchQuery() {
    String query = 'body_part=${_filterData['body_part']}'
        '&calories__gte=${_filterData['calories_greater_than']}'
        '&calories__lte=${_filterData['calories_less_than']}'
        '&search=${_filterData['search']}'
        '&ordering=${_filterData['ordering']}';
    return query;
  }

  void onSearchClicked() {
    setState(() {
      //reset nextPage
      nextExercisePage = "https://exerdiet.pythonanywhere.com/gym/exercises/";
      loadedexercise = List.empty(growable: true);
      isExerciseLoadingComplete = false;
    });
    searchExercise();
  }

  void searchWorkout(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse('${nextWorkoutPage!}?search=$value'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextWorkoutPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedworkout
              .add(Workout.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isWorkoutLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  void searchCustomExercise(String value) async {
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
          loadedcustomexercise
              .add(Execise.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isCustomExerciseLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  //widgets
  Widget exerciseTab() {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: TextField(
                  controller: exerciseController,
                  //onChanged: (value) => updateList(value),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 12),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0x00000000),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "eg: Pushups",
                    suffixIcon: InkWell(
                      child: const Icon(Icons.search),
                      onTap: () {
                        _filterData['search'] = exerciseController.text;
                        onSearchClicked();
                      },
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              child: const Icon(Icons.filter_alt),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Filter(
                          filterData: _filterData,
                          setFilteredData: setFilteredData,
                          onSearchClicked: onSearchClicked,
                          resetFilteredData: resetFilteredData,
                        ));
              },
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              child: const Icon(Icons.sort),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Sort(
                          selectedSortMethod: _filterData['ordering']!,
                          setOrderingMethod: setOrderingMethod,
                          onSearchClicked: onSearchClicked,
                        ));
              },
            ),
            const SizedBox(
              width: 5,
            ),
          ],
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
                    exerciseId: exerciseId,
                    exerciseDomain: 'performed_workouts',
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

  Widget workoutTab() {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
            controller: workoutController,
            //onChanged: (value) => updateList(value),
            style:  TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0x00000000),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              hintText: "eg: swimmer workout",
              suffixIcon: InkWell(
                child: const Icon(Icons.search),
                onTap: () {
                  setState(() {
                    nextWorkoutPage =
                        "https://exerdiet.pythonanywhere.com/gym/workouts/";
                    loadedworkout = List.empty(growable: true);
                    isWorkoutLoadingComplete = false;
                  });
                  searchWorkout(workoutController.text);
                },
              ),
            ),
          ),
        ),
        if (isWorkoutLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isWorkoutLoadingComplete == true && loadedworkout.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: nextWorkoutPage == null
                  ? loadedworkout.length
                  : loadedworkout.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextWorkoutPage != null && index == loadedworkout.length) {
                  return ElevatedButton(
                      onPressed: () {
                        getWorkout();
                      },
                      child: const Text('Load more'));
                } else {
                  return WorkoutItem(
                    workout: loadedworkout[index],
                    exerciseId: exerciseId,
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Workouts found on Database!')),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(40), left: Radius.circular(40))),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddWorkoutScreen.routeName);
              },
              child: const Text('create new workout',
                  style: TextStyle(color: Colors.white))),
        ),
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
            style:  TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0x00000000),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              hintText: "eg: my monday exercise",
              suffixIcon: InkWell(
                child: const Icon(Icons.search),
                onTap: () {
                  setState(() {
                    nextCustomExercisePage =
                        "https://exerdiet.pythonanywhere.com/gym/custom_exercises/";
                    loadedcustomexercise = List.empty(growable: true);
                    isCustomExerciseLoadingComplete = false;
                  });
                  searchCustomExercise(customExerciseController.text);
                },
              ),
            ),
          ),
        ),
        if (isCustomExerciseLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isCustomExerciseLoadingComplete == true &&
            loadedcustomexercise.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: nextCustomExercisePage == null
                  ? loadedcustomexercise.length
                  : loadedcustomexercise.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextCustomExercisePage != null &&
                    index == loadedcustomexercise.length) {
                  return ElevatedButton(
                      onPressed: () {
                        getCustomExercise();
                      },
                      child: const Text('Load more'));
                } else {
                  return ExerciseItem(
                    exercise: loadedcustomexercise[index],
                    exerciseId: exerciseId,
                    exerciseDomain: 'performed_workouts',
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Custom Exercise found on Database!')),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(40), left: Radius.circular(40))),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AddExerciseScreen.routeName);
              },
              child: const Text('create new Exercise',
                  style: TextStyle(color: Colors.white))),
        ),
      ],
    );
  }

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
    getExercise();
    getWorkout();
    getCustomExercise();
  }

  late TabController controller;
  @override
  Widget build(BuildContext context) {
    exerciseId = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add exercise'),
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
                  padding: EdgeInsets.only(bottom: 2), child: Text('Workout')),
              Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text('My Exercise')),
            ]),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: TabBarView(
            controller: controller,
            children: [exerciseTab(), workoutTab(), customExerciseTab()]),
      ),
    );
  }
}
