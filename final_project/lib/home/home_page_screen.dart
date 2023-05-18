import 'package:final_project/constants.dart';
import 'package:final_project/home/calorie_progress_bar.dart';
import 'package:final_project/home/adding_buttons.dart';
import 'package:final_project/home/dashboard/dashboard_main_screen.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({super.key});
  static const routeName = '/Home-page';

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  User user = User.instance;
  int selectedIndex = 0;
  bool isVisible = true;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      isVisible = index == 0 ? true : false;
    });
  }

  List<Widget> pages = [
    Stack(
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
              children: [CaloriesProgressBar(), AddingButtons()],
            ),
          ),
        ),
      ],
    ),
    DashboardMainScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isVisible
          ? AppBar(
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
                      '${user.dailyStreak}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )
              ],
            )
          : null,
      body: IndexedStack(index: selectedIndex,children: pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
        currentIndex: selectedIndex,
        onTap: (index) => onItemTapped(index),
      ),
    );
  }
}
