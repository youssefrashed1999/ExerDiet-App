import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/user.dart';

class ChangeGoalScreen extends StatefulWidget {
  static const routeName = '/change-goal';
  const ChangeGoalScreen({super.key});

  @override
  State<ChangeGoalScreen> createState() => _ChangeGoalScreenState();
}

class _ChangeGoalScreenState extends State<ChangeGoalScreen> {
  //keys and controllers
  final GlobalKey<FormState> _formkey = GlobalKey();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  User user = User.instance;
  Map<String, dynamic> userData = {
    'weight': 0.0,
    'height': 0.0,
    'activity_level': '',
    'goal': ''
  };
  @override
  void initState() {
    userData['activity_level'] = user.activityLevel;
    userData['goal'] = user.goal;
  }

  void submit(BuildContext context) {
    //FocusManager.instance.primaryFocus?.unfocus();
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
    sendHttpRequest();
    setState(() {});
  }

  sendHttpRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.patch(
        Uri.parse('${BASE_URL}/core/trainees/me/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
        body: jsonEncode(<String, dynamic>{
          'height': userData['height'].toDouble(),
          'weight': userData['weight'].toDouble(),
          'activity_level': userData['activity_level'],
          'goal': userData['goal']
        }),
      );
      if (response.statusCode == 200) {
        User.fromJson(jsonDecode(response.body));
        _btnController.success();
      } else if (response.statusCode == 400) {
        _btnController.error();
        Fluttertoast.showToast(
            msg: 'Error Occured!\nCheck your answers and try again.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        Timer(const Duration(seconds: 2), () {
          _btnController.reset();
        });
      }
      //Server is down
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
    } catch (e) {
      _btnController.error();
      print('Look here you idiot: $e');
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(10),
          width: deviceSize.width,
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weight',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                TextFormField(
                  initialValue: user.weight.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 16),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  validator: (value) {
                    if (value!.isEmpty || double.parse(value) <= 0) {
                      return 'Required Field!';
                    }
                    return null;
                  },
                  onSaved: (newValue) =>
                      userData['weight'] = double.parse(newValue!),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text('Height',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                TextFormField(
                  initialValue: user.height.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 16),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  validator: (value) {
                    if (value!.isEmpty || double.parse(value) <= 0) {
                      return 'Required Field!';
                    }
                    return null;
                  },
                  onSaved: (newValue) =>
                      userData['height'] = double.parse(newValue!),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text('Activity Level',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                DropdownButtonFormField(
                  value: user.activityLevel,
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'N',
                      child: Text('None'),
                    ),
                    DropdownMenuItem(
                      value: 'L',
                      child: Text('Low'),
                    ),
                    DropdownMenuItem(
                      value: 'M',
                      child: Text('Medium'),
                    ),
                    DropdownMenuItem(
                      value: 'H',
                      child: Text('High'),
                    ),
                    DropdownMenuItem(
                      value: 'E',
                      child: Text('Extreme'),
                    ),
                    DropdownMenuItem(
                      value: 'T',
                      child: Text('Tracked'),
                    ),
                  ],
                  onChanged: (value) => userData['activity_level'] = value!,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text('Goal',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                DropdownButtonFormField(
                  value: user.goal,
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'L',
                      child: Text('Lose weight'),
                    ),
                    DropdownMenuItem(
                      value: 'K',
                      child: Text('Keep weight'),
                    ),
                    DropdownMenuItem(
                      value: 'G',
                      child: Text('Gain weight'),
                    ),
                  ],
                  onChanged: (value) => userData['goal'] = value!,
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: deviceSize.width * 0.8,
                    child: RoundedLoadingButton(
                      height: 45,
                      controller: _btnController,
                      onPressed: () => submit(context),
                      color: Theme.of(context).primaryColor,
                      borderRadius: 40,
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
