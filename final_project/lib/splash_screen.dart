import 'dart:async';
import 'dart:convert';

import 'package:final_project/auth/open_screen.dart';
import 'package:final_project/constants.dart';
import 'package:final_project/home/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Widget> _decideRoute() async {
    print('im here');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    final String? refreshKey = prefs.getString(REFRESH_KEY);
    //if no access key is stored navigate to open screen to signup/login
    if (refreshKey == null) {
      print('null refresh key');
      return const OpenScreen();
    } else {
      try {
        print('before making request');
        final response = await http.post(
          Uri.parse('${BASE_URL}auth/jwt/refresh'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'refresh': refreshKey}),
        );
        //success response
        if (response.statusCode == 200) {
          print('perfect request');
          //save new access
          String newAccessKey = jsonDecode(response.body)['access'];
          await prefs.setString(ACCESS_KEY, newAccessKey);
          //get user info
          await getUserInfo();
        }
        //refresh key is outdated
        else if (response.statusCode == 401) {
          print('wrong access key');
          await prefs.remove(ACCESS_KEY);
          await prefs.remove(REFRESH_KEY);
          return const OpenScreen();
        }
        //Server is down
        else if (response.statusCode == 500) {
          print('server is down');
          Fluttertoast.showToast(
              msg: 'System is down at the moment!\nTry again later.',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.white,
              textColor: MY_COLOR[300]);
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        }
      }
      //no internet connection
      catch (_) {
        Fluttertoast.showToast(
            msg: 'No Internet Connection!\nTry again later.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
    }
    return HomePageScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedSplashScreen.withScreenFunction(
        splash: 'assets/images/main_icon.png',
        duration: 2500,
        screenFunction: _decideRoute,
        splashTransition: SplashTransition.rotationTransition,
        animationDuration: const Duration(seconds: 0),
        backgroundColor: MY_COLOR.shade700,
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      )
    ]);
  }
}
