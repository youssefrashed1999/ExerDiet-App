import 'package:final_project/models/exercise_instance.dart';

class Workout {
  final int id;
  final String name;
  final String? instructions;
  final int totalCaloriesBurnt;
  final List<ExerciseInstance> exerciseInstance;
  final String? imageUrl;

  Workout(
      {required this.id,
      required this.name,
      required this.instructions,
      required this.totalCaloriesBurnt,
      required this.exerciseInstance,
      required this.imageUrl});

  factory Workout.fromjson(Map<String, dynamic> json) {
    List<ExerciseInstance> dummyList = List.empty(growable: true);
    for (int i = 0; i < json['exercise_instances'].length; i++) {
      dummyList.add(ExerciseInstance.fromjson(json['exercise_instances'][i]));
    }
    return Workout(
      id: json['id'],
      name: json['name'],
      instructions: json['instructions'],
      imageUrl: json['image'],
      exerciseInstance: dummyList,
      totalCaloriesBurnt: json['total_calories'].toInt(),
    );
  }
}
