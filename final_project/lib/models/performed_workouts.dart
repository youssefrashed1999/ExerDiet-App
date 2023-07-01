import 'package:final_project/models/workout.dart';
import 'package:final_project/models/exercise_instance.dart';

class PerformedWorkout {
  int id;
  String name;
  String timePerformed;
  List<Workout> workouts;
  List<ExerciseInstance> exercise;
  int totalCaloriesBurnt;

  PerformedWorkout({
    required this.id,
    required this.name,
    required this.timePerformed,
    required this.workouts,
    required this.exercise,
    required this.totalCaloriesBurnt,
  });
  factory PerformedWorkout.fromjson(Map<String, dynamic> json) {
    List<Workout> workoutList = List.empty(growable: true);
    List<ExerciseInstance> exerciseList = List.empty(growable: true);
    for (int i = 0; i < json['exercise_instances'].length; i++) {
      exerciseList
          .add(ExerciseInstance.fromjson(json['exercise_instances'][i]));
    }
    for (int i = 0; i < json['workouts'].length; i++) {
      workoutList.add(Workout.fromjson(json['workouts'][i]));
    }
    return PerformedWorkout(
      id: json['id'],
      name: json['name'],
      timePerformed: json['time_performed'].toString(),
      workouts: workoutList,
      exercise: exerciseList,
      totalCaloriesBurnt: json['total_calories'].toInt(),
    );
  }
}
