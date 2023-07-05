import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/exercise.dart';

class ExerciseItem extends StatelessWidget {
  //const DietFoodItem({super.key});

  final Execise exercise;
  late int exerciseId;
  late String exerciseDomain;

  ExerciseItem(
      {super.key,
      required this.exercise,
      required this.exerciseId,
      required this.exerciseDomain});
  final GlobalKey<FormState> _formkey = GlobalKey();
  double duration = 0;
  double sets = 0;
  void addExercise() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.post(
          Uri.parse(
              '${BASE_URL}gym/$exerciseDomain/$exerciseId/exercise_instances/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'JWT $accessKey'
          },
          body: jsonEncode(<String, dynamic>{
            'exercise_id': exercise.id,
            'duration': duration,
            'sets': sets,
          }));
      print('code is:${response.body.toString()}');
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: 'Exercise added successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      } else {
        Fluttertoast.showToast(
            msg: 'Error adding Exercise!\nTry again later!',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      }
    } catch (_) {}
  }

  void submit() {
    if (!_formkey.currentState!.validate()) {
      // Invalid!
      return;
    }
    //valid form state
    //LogIn logic
    _formkey.currentState!.save();
    addExercise();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    //Rating Dialog
    void showRating() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Rate this'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'rate this Exercise so we can recommend you something simmilar',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildRating()
              ],
            ),
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

    void selectDurationAndSets() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Duration and Sets',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            content: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter Duration',
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor),
                  ),
                  Row(children: [
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: 100.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isEmpty || double.parse(value) <= 0) {
                            return 'Duration can\'t be negative';
                          }
                          return null;
                        },
                        onSaved: (newValue) =>
                            duration = double.parse(newValue!),
                      ),
                    ),
                    if (exercise.isRepetitive == 'T')
                      const Text('reps')
                    else
                      const Text('sec'),
                  ]),
                  Text(
                    'Enter Sets',
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor),
                  ),
                  Row(children: [
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: 100.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isEmpty || double.parse(value) <= 0) {
                            return 'Sets can\'t be negative';
                          }
                          return null;
                        },
                        onSaved: (newValue) => sets = double.parse(newValue!),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    submit();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        );
    return Padding(
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
                child: exercise.imageUrl == null
                    ? null
                    : Image.network('${BASE_URL}${exercise.imageUrl}',
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
                        '${exercise.name}\n',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('calories Burnt: ${exercise.caloriesBurnt} cal'),
                    Text('bodyPart: ${exercise.bodypart}'),
                    Text('is Repetitive: ${exercise.isRepetitive}'),
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
                      selectDurationAndSets();
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    iconSize: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    onPressed: () {
                      showRating();
                    },
                    icon: const Icon(Icons.star),
                    iconSize: 40,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildRating() => RatingBar.builder(
      initialRating: 0,
      minRating: 0,
      direction: Axis.horizontal,
      updateOnDrag: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
