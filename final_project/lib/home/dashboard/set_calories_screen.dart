import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/user.dart';

class SetCaloriesScreen extends StatefulWidget {
  static const routeName = '/set-calories';
  const SetCaloriesScreen({super.key});
  @override
  State<SetCaloriesScreen> createState() => _SetCaloriesScreenState();
}

class _SetCaloriesScreenState extends State<SetCaloriesScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  User user = User.instance;
  //to save user input
  int customCalories = 0;
  String? caloriesError;
  void _submit(BuildContext context) {
    //hide keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      caloriesError = null;
    });
    if (!_formkey.currentState!.validate()) {
      // Invalid!
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
      return;
    }
    //valid state
    _formkey.currentState!.save();
    setState(() {});
    _sendHttpRequest();
    setState(() {});
  }

  //set calories manually
  void _sendHttpRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.patch(
        Uri.parse('${BASE_URL}core/trainees/set_daily_calories_needs/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
        body: jsonEncode(<String, int>{"daily_calories_needs": customCalories}),
      );
      //success response
      if (response.statusCode == 200) {
        await getUserInfo();
        _btnController.success();
      }
      //user input error
      else if (response.statusCode == 400) {
        _btnController.error();
        setState(() {
          if (jsonDecode(response.body)["daily_calories_needs"] != null) {
            caloriesError =
                jsonDecode(response.body)["daily_calories_needs"][0];
          }
        });
        Timer(const Duration(seconds: 2), () {
          _btnController.reset();
        });
      }
      //server down
      else if (response.statusCode == 500) {
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

  //set calories automatically
  void _resetDailyCaloriesNeeds() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _btnController1.start();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse('${BASE_URL}core/trainees/reset_daily_calories_needs/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //calories reset successfully
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
          'Custom Calories',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: deviceSize.width,
        color: Colors.grey.shade200,
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'calories',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                      errorText: caloriesError),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 18),
                  initialValue: user.dailyCaloriesNeeds.toString(),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.contains('.') ||
                        int.parse(value) < 0) {
                      return 'Calories has to be an integer!';
                    }
                    return null;
                  },
                  onSaved: (newValue) => customCalories = int.parse(newValue!),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: deviceSize.width * 0.8,
                  child: RoundedLoadingButton(
                    height: 45,
                    controller: _btnController,
                    onPressed: () => _submit(context),
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
                    onPressed: _resetDailyCaloriesNeeds,
                    color: Theme.of(context).primaryColor,
                    borderRadius: 40,
                    child: const Text('Set Calories automatically',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
