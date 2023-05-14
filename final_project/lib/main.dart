import 'package:final_project/Food/add_food_screen.dart';
import 'package:final_project/auth/log_in_screen.dart';
import 'package:final_project/auth/open_screen.dart';
import 'package:final_project/auth/sign_up_screen.dart';
import 'package:final_project/Food/food_overview_screen.dart';
import 'package:final_project/healthQuiz/health_quiz_screen.dart';
import 'package:final_project/home/home_page_screen.dart';
import 'package:final_project/splash_screen.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

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
            bodyLarge: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 16),
            titleLarge: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            headlineLarge: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 26,
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
      home: FoodOverviewScreen(),
      routes: {
        OpenScreen.routeName: (context) => const OpenScreen(),
        LogInScreen.routeName: (context) => LogInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        HealthQuizScreen.routeName: (context) => HealthQuizScreen(),
        HomePageScreen.routeName: (context) => HomePageScreen(),
        FoodOverviewScreen.routeName: (context) => FoodOverviewScreen()
      },
    );
  }
}
