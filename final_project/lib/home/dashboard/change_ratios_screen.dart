import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../models/user.dart';

class ChangeRatiosScreen extends StatefulWidget {
  static const routeName = '/change-ratios';
  const ChangeRatiosScreen({super.key});

  @override
  State<ChangeRatiosScreen> createState() => _ChangeRatiosState();
}

class _ChangeRatiosState extends State<ChangeRatiosScreen> {
  User user = User.instance;
  int carbsRatio = 0;
  int proteinRatio = 35;
  int fatsRatio = 50;
  @override
  void initState() {
    carbsRatio = (user.carbsRatio * 100).toInt();
    fatsRatio = (user.fatsRatio * 100).toInt();
    proteinRatio = (user.proteinRatio * 100).toInt();
  }

  bool canProceed = true;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  void onValuesChanged() {
    if (carbsRatio + proteinRatio + fatsRatio == 100) {
      setState(() {
        canProceed = true;
      });
    } else {
      setState(() {
        canProceed = false;
      });
    }
  }

  void setMacronutrientsManually() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    _btnController.start();
    try {
      final response = await http.patch(
        Uri.parse('${BASE_URL}core/trainees/set_macronutrients_ratios/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
        body: jsonEncode(<String, double>{
          "carbs_ratio": carbsRatio.toDouble() / 100,
          "fats_ratio": fatsRatio.toDouble() / 100,
          "protein_ratio": proteinRatio.toDouble() / 100
        }),
      );
      if (response.statusCode == 200) {
        await getUserInfo();
        _btnController.success();
      } else if (response.statusCode == 400) {
        _btnController.error();
        Fluttertoast.showToast(
            msg: 'Error Occured!\nCheck your numbers and try again.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        Timer(const Duration(seconds: 2), () {
          _btnController.reset();
        });
      } else if (response.statusCode == 500) {
        _btnController.error();
        Fluttertoast.showToast(
            msg: 'Server is down at the moment!\nTry again later.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        Timer(const Duration(seconds: 2), () {
          _btnController.reset();
        });
      }
    } catch (_) {
      _btnController.error();
      Fluttertoast.showToast(
          msg: 'Check your internet connection!',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: MY_COLOR[300]);
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
    }
  }

  void setMacronutrientsAutomatically() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    _btnController1.start();
    try {
      final response = await http.get(
        Uri.parse('${BASE_URL}core/trainees/reset_macronutrients_ratios/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      if (response.statusCode == 200) {
        await getUserInfo();
        _btnController1.success();
      }
      //server down
      else if (response.statusCode == 500) {
        _btnController1.error();
        Fluttertoast.showToast(
            msg: 'Server is down at the moment!\nTry again later.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        Timer(const Duration(seconds: 2), () {
          _btnController1.reset();
        });
      }
    } catch (_) {
      _btnController1.error();
      Fluttertoast.showToast(
          msg: 'Check your internet connection!',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: MY_COLOR[300]);
      Timer(const Duration(seconds: 2), () {
        _btnController1.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Macronutrients',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text('Carbs',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          NumberPicker(
                              minValue: 0,
                              maxValue: 100,
                              value: carbsRatio,
                              onChanged: (value) {
                                carbsRatio = value;
                                onValuesChanged();
                              }),
                          const Text('%')
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text('Fats',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          NumberPicker(
                              minValue: 0,
                              maxValue: 100,
                              value: fatsRatio,
                              onChanged: (value) {
                                fatsRatio = value;
                                onValuesChanged();
                              }),
                          const Text('%')
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text('Protein',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          NumberPicker(
                              minValue: 0,
                              maxValue: 100,
                              value: proteinRatio,
                              onChanged: (value) {
                                proteinRatio = value;
                                onValuesChanged();
                              }),
                          const Text('%')
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                width: deviceSize.width * 0.8,
                child: RoundedLoadingButton(
                  height: 45,
                  controller: _btnController,
                  onPressed: canProceed ? setMacronutrientsManually : null,
                  color: Theme.of(context).primaryColor,
                  borderRadius: 40,
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'OR',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: deviceSize.width * 0.8,
                child: RoundedLoadingButton(
                  height: 45,
                  controller: _btnController1,
                  onPressed: setMacronutrientsAutomatically,
                  color: Theme.of(context).primaryColor,
                  borderRadius: 40,
                  child: const Text('Set Macronutrients automatically',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ));
  }
}
