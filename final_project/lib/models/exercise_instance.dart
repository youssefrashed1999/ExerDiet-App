import 'exercise.dart';

class ExerciseInstance {
  int id;
  Execise execise;
  double duration;
  double sets;
  int totalCalories;
  ExerciseInstance(
      {required this.id,
      required this.execise,
      required this.sets,
      required this.duration,
      required this.totalCalories});

  factory ExerciseInstance.fromjson(Map<String, dynamic> json) {
    return ExerciseInstance(
      id: json['id'],
      execise: Execise.fromjson(json['exercise']),
      duration: json['duration'].toDouble(),
      sets: json['sets'].toDouble(),
      totalCalories: json['total_calories'].toInt(),
    );
  }
}
