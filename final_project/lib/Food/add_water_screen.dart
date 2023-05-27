import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/user.dart';

class AddWater extends StatefulWidget {
  static const routeName = '/add_water';
  const AddWater({super.key});

  @override
  State<AddWater> createState() => _AddWaterState();
}

Widget _innerWidget(double value, double max, BuildContext context) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${value.toInt()}/\n${max.toInt()}',
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.titleMedium?.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor)),
        Text(
          'milli-Liter',
          style: TextStyle(
              fontFamily: Theme.of(context).textTheme.titleMedium?.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey),
        )
      ],
    ),
  );
}

class _AddWaterState extends State<AddWater> {
  User _user = User.instance;
  int amount = 250;

  void add_water_amount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.post(Uri.parse('${BASE_URL}diet/waters/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'JWT $accessKey'
          },
          body: jsonEncode(<String, int>{'amount': amount.toInt()}));
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: 'Water added successfully!',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        await getUserInfo();
        setState(() {
          _user = User.instance;
        });
      } else {
        Fluttertoast.showToast(
            msg: 'Error occurred!\n please try again later.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      }
    } catch (_) {
      Fluttertoast.showToast(
          msg: 'Error occurred!\n please try again later.',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: MY_COLOR[300]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    void change_cup_measurements() => showDialog(
          context: context,
          builder: (BuildContext context) {
            return Expanded(
              child: AlertDialog(
                title: const Text(
                  'Measurements',
                  style: TextStyle(color: Color.fromRGBO(125, 236, 216, 1)),
                ),
                content: const Text('pick your amount of choice'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('250'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    amount = 250;
                                  });
                                },
                                icon: Image.asset('assets/icons/cup-250.png'))
                          ],
                        ),
                        Row(
                          children: [
                            const Text('350'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  amount = 350;
                                });
                              },
                              icon: Image.asset('assets/icons/bottle-350.png'),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text('450'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    amount = 450;
                                  });
                                },
                                icon:
                                    Image.asset('assets/icons/bottle-450.png'))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
    Image iconpicker() {
      if (amount == 250) {
        return Image.asset('assets/icons/cup-250.png');
      } else if (amount == 350) {
        return Image.asset('assets/icons/bottle-350.png');
      } else {
        return Image.asset('assets/icons/bottle-450.png');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Water'),
      ),
      /*
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(125, 236, 216, 1),
        foregroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.add),
      ),*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
          Center(
            child: SizedBox(
              height: deviceSize.height * 0.3,
              width: deviceSize.width * 0.85,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 8,
                child: SizedBox(
                  width: deviceSize.width * 0.3,
                  height: deviceSize.height * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SleekCircularSlider(
                      initialValue: _user.waterIntakeToday.toDouble(),
                      min: 0,
                      max: _user.dailyWaterNeeds.toDouble(),
                      appearance: CircularSliderAppearance(
                        startAngle: 270,
                        angleRange: 360,
                        customColors: CustomSliderColors(
                            trackColor: Colors.grey,
                            progressBarColors: const [
                              Color.fromRGBO(125, 236, 216, 1),
                              Color.fromRGBO(208, 251, 222, 1),
                            ],
                            hideShadow: true,
                            dotColor: Colors.white),
                      ),
                      innerWidget: (percentage) => _innerWidget(percentage,
                          _user.dailyWaterNeeds.toDouble(), context),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: deviceSize.height * 0.4,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      add_water_amount();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromRGBO(125, 236, 216, 1)),
                    child: const Icon(Icons.add),
                  ),
                  IconButton(
                      onPressed: () {
                        change_cup_measurements();
                      },
                      icon: iconpicker()),
                  /* ElevatedButton(
                    onPressed: () {
                      change_cup_measurements();
                    },
                    child: iconpicker(),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.transparent),
                  ),*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
