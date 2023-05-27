import 'dart:convert';

import 'package:final_project/home/meals/snack_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../Food/food_overview_screen.dart';
import '../../constants.dart';
import '../../models/meal.dart';

class SnackScreen extends StatefulWidget {
  static const routeName = '/snacks/meals';
  const SnackScreen({super.key});

  @override
  State<SnackScreen> createState() => _SnackScreenState();
}

class _SnackScreenState extends State<SnackScreen> with RouteAware {
  bool isLoadingComplete = false;
  List<Meal> meal = List.empty(growable: true);
  String? nextPage =
      '${BASE_URL}diet/meals/?search=snack&time_eaten__gte=${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    //check if there is a meal created today with the same name
    try {
      final response = await http.get(
        Uri.parse(nextPage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      if (response.statusCode == 200) {
        nextPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['count'];
        for (int i = 0; i < count; i++) {
          meal.add(Meal.fromjson(jsonDecode(response.body)['results'][i]));
        }

        setState(() {
          isLoadingComplete = true;
        });
      } else {
        Fluttertoast.showToast(
            msg: 'Error occured!\nPlease try again later.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      }
    } catch (_) {}
  }

  void createMeal() async {
    int mealId = 0;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessKey = prefs.getString(ACCESS_KEY);
      final response = await http.post(Uri.parse('${BASE_URL}diet/meals/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'JWT $accessKey'
          },
          body: jsonEncode(<String, String>{'name': 'snack'}));
      if (response.statusCode == 201) {
        mealId = jsonDecode(response.body)['id'];
      } else {
        Fluttertoast.showToast(
            msg: 'Error occured!\nPlease try again later.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        return;
      }
    } catch (_) {}

    if (!context.mounted) return;
    Navigator.of(context)
        .pushNamed(FoodOverviewScreen.routeName, arguments: mealId);
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snacks'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          if (isLoadingComplete == false)
            const CircularProgressIndicator()
          else if (isLoadingComplete == true && (meal.isEmpty))
            const Center(child: Text('No Snacks added today!'))
          else
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: nextPage == null ? meal.length : meal.length + 1,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (nextPage != null && index == meal.length) {
                    return ElevatedButton(
                        onPressed: () {
                          loadData();
                        },
                        child: const Text('Load more'));
                  } else {
                    return SnackItem(meal: meal[index]);
                  }
                },
                scrollDirection: Axis.vertical,
              ),
            ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(40),
                          left: Radius.circular(40))),
                ),
                onPressed: () {
                  createMeal();
                },
                child: const Text('Add more',
                    style: TextStyle(color: Colors.white))),
          )
        ],
      ),
    );
  }
}
