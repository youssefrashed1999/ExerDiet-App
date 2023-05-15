import 'package:flutter/material.dart';
import '../models/exercise.dart';
import 'exercise_item.dart';

class ExerciseOverviewScreen extends StatefulWidget {
  //const ExerciseOverviewScreen({super.key});
  static const routeName = '/execise';

  @override
  State<ExerciseOverviewScreen> createState() => _ExerciseOverviewScreenState();
}

class _ExerciseOverviewScreenState extends State<ExerciseOverviewScreen> {
  static List<Execise> loadedExercise = [
    Execise(
        id: '1',
        name: 'pushups',
        bodypart: 'arms',
        caloriesBurnt: 100,
        imageUrl: 'https://blog.nasm.org/hubfs/power-pushups.jpg',
        isRepetitive: true),
    Execise(
        id: '2',
        name: 'Lunge',
        bodypart: 'legs',
        caloriesBurnt: 120,
        imageUrl:
            'https://hips.hearstapps.com/hmg-prod/images/muscular-man-training-his-legs-doing-lunges-with-royalty-free-image-1677586874.jpg',
        isRepetitive: true),
    Execise(
        id: '3',
        name: 'squats',
        bodypart: 'legs',
        caloriesBurnt: 140,
        imageUrl:
            'https://www.eatthis.com/wp-content/uploads/sites/4/2022/10/fitness-woman-performing-squats.jpg?quality=82&strip=1',
        isRepetitive: true),
    Execise(
        id: '4',
        name: 'running',
        bodypart: 'legs',
        caloriesBurnt: 130,
        imageUrl:
            'https://post.healthline.com/wp-content/uploads/2020/01/Runner-training-on-running-track-732x549-thumbnail.jpg',
        isRepetitive: false)
  ];
  bool is_exercise_clicked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(is_exercise_clicked ? 'Add Exercise' : 'Add Workout'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(is_exercise_clicked ? 'Add Exercise' : 'Add Workout',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 97, 219, 213),
                fontSize: 20,
                fontFamily: 'Anton',
                fontWeight: FontWeight.normal,
              )),
          const SizedBox(
            height: 7,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: TextField(
              //onChanged: (value) => updateList(value),
              style: const TextStyle(
                  color: Color.fromARGB(255, 97, 219, 213), fontSize: 12),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0x00000000),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                hintText: "eg: squats",
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: is_exercise_clicked
                        ? const Color.fromARGB(255, 97, 219, 213)
                        : Colors.white,
                    elevation: is_exercise_clicked ? 4 : 2,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.zero, left: Radius.circular(40))),
                  ),
                  onPressed: () {
                    setState(() {
                      is_exercise_clicked = true;
                    });
                  },
                  child: Text('Exercise',
                      style: TextStyle(
                          color: is_exercise_clicked
                              ? Colors.white
                              : const Color.fromARGB(255, 97, 219, 213)))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: is_exercise_clicked
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 97, 219, 213),
                    elevation: is_exercise_clicked ? 2 : 4,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.zero, right: Radius.circular(40))),
                  ),
                  onPressed: () {
                    setState(() {
                      is_exercise_clicked = false;
                    });
                  },
                  child: Text('Workouts',
                      style: TextStyle(
                          color: is_exercise_clicked
                              ? const Color.fromARGB(255, 97, 219, 213)
                              : Colors.white)))
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: loadedExercise.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => ExerciseItem(
                  id: loadedExercise[index].id,
                  name: loadedExercise[index].name,
                  bodypart: loadedExercise[index].bodypart,
                  caloriesBurnt: loadedExercise[index].caloriesBurnt,
                  isRepetitive: loadedExercise[index].isRepetitive,
                  imageUrl: loadedExercise[index].imageUrl),
              scrollDirection: Axis.vertical,
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(40), left: Radius.circular(40))),
              ),
              onPressed: () {},
              child: Text(
                  is_exercise_clicked
                      ? 'create new exercise'
                      : 'create new workout',
                  style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
