import 'package:final_project/Food/add_food_intances_to_recipe.dart';
import 'package:final_project/Food/add_food_screen.dart';
import 'package:final_project/Food/add_recipe_screen.dart';
import 'package:final_project/Food/add_water_screen.dart';
import 'package:final_project/Food/recipe_detailed_item.dart';
import 'package:final_project/auth/log_in_screen.dart';
import 'package:final_project/auth/open_screen.dart';
import 'package:final_project/auth/sign_up_screen.dart';
import 'package:final_project/healthQuiz/health_quiz_screen.dart';
import 'package:final_project/home/dashboard/change_goal_screen.dart';
import 'package:final_project/home/dashboard/change_password_screen.dart';
import 'package:final_project/home/dashboard/change_ratios_screen.dart';
import 'package:final_project/home/dashboard/change_username_screen.dart';
import 'package:final_project/home/dashboard/set_calories_screen.dart';
import 'package:final_project/home/dashboard/set_water_intake_screen.dart';
import 'package:final_project/home/home_page_screen.dart';
import 'package:final_project/home/meals/meals_screen.dart';
import 'package:final_project/home/meals/snack_detailed.dart';
import 'package:final_project/home/meals/snacks_screen.dart';
import 'package:final_project/splash_screen.dart';
import 'package:final_project/workouts/exercise_overview_screen.dart';
import 'package:final_project/home/meals/performed_workouts_screen.dart';
import 'package:flutter/material.dart';
import 'Food/food_overview_screen.dart';
import 'package:final_project/workouts/add_workout_screen.dart';
import 'package:final_project/workouts/add_exercise_instances_to_workout.dart';
import 'package:final_project/workouts/add_exercise_screen.dart';
import 'package:final_project/workouts/workout_detailed_item.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExerDiet',
      theme: ThemeData(
          primarySwatch: MY_COLOR,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 18),
            titleLarge: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            headlineLarge: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            titleMedium: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            titleSmall: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          )),
      home: SplashScreen(),
      navigatorObservers: [routeObserver],
      routes: {
        OpenScreen.routeName: (context) => const OpenScreen(),
        LogInScreen.routeName: (context) => LogInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        HealthQuizScreen.routeName: (context) => const HealthQuizScreen(),
        HomePageScreen.routeName: (context) => HomePageScreen(),
        FoodOverviewScreen.routeName: (context) => const FoodOverviewScreen(),
        ExerciseOverviewScreen.routeName: (context) => ExerciseOverviewScreen(),
        ChangePasswordScreen.routeName: (context) =>
            const ChangePasswordScreen(),
        ChangeUsernameScreen.routeName: (context) =>
            const ChangeUsernameScreen(),
        SetCaloriesScreen.routeName: (context) => const SetCaloriesScreen(),
        SetWaterIntakeScreen.routeName: (context) =>
            const SetWaterIntakeScreen(),
        ChangeRatiosScreen.routeName: (context) => const ChangeRatiosScreen(),
        ChangeGoalScreen.routeName: (context) => const ChangeGoalScreen(),
        MealsScreen.routeName: (context) => const MealsScreen(),
        AddFoodScreen.routeName: (context) => AddFoodScreen(),
        AddFoodInsances.routeName: (context) => const AddFoodInsances(),
        AddRecipeScreen.routeName: (context) => const AddRecipeScreen(),
        RecipeDetailedItem.routeName: (context) => RecipeDetailedItem(),
        SnackScreen.routeName: (context) => const SnackScreen(),
        SnackDetailedScreen.routeName: (context) => SnackDetailedScreen(),
        AddWater.routeName: (context) => const AddWater(),
        PerformedWorkoutsScreen.routeName: (context) =>
            const PerformedWorkoutsScreen(),
        AddWorkoutScreen.routeName: (context) => const AddWorkoutScreen(),
        AddExerciseInsances.routeName: (context) => const AddExerciseInsances(),
        AddExerciseScreen.routeName: (context) => const AddExerciseScreen(),
        WorkoutDetailedItem.routeName: (context) => WorkoutDetailedItem(),
      },
    );
  }
}
