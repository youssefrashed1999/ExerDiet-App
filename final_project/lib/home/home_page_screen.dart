import 'package:final_project/constants.dart';
import 'package:final_project/home/calorie_progress_bar.dart';
import 'package:final_project/home/adding_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/user.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({super.key});
  static const routeName = '/Home-page';
  User _user = User.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ExerDiet'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: Center(
              child: Text(
                '${_user.dailyCaloriesNeeds}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BOX_DECORATION,
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //CaloriesProgressBar(),
                  AddingButtons()
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'scan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_sharp), label: 'Progress'),
        ],
      ),
    );
  }
}
