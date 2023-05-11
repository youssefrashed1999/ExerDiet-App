import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

const BOX_DECORATION = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color.fromRGBO(125, 236, 216, 1),
      Color.fromRGBO(208, 251, 222, 1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 1],
  ),
);
MaterialColor MY_COLOR = const MaterialColor(
  0xFF61DBD5,
  <int, Color>{
    50: Color(0x0061DBD5),
    100: Color(0xFF61DBD5),
    200: Color(0xFF61DBD5),
    300: Color(0xFF61DBD5),
    400: Color(0xFF61DBD5),
    500: Color(0xFF61DBD5),
    600: Color(0xFF61DBD5),
    700: Color(0xFF61DBD5),
    800: Color(0xFF61DBD5),
    900: Color(0xFF61DBD5),
  },
);
const APP_NAME = 'ExerDiet';
const SLOGAN1 = 'Healthy life,';
const SLOGAN2 = 'Healthy Mind';

const BASE_URL = 'https://exerdiet.pythonanywhere.com/';
const ACCESS_KEY = 'access-key';
const REFRESH_KEY = 'refresh-key';

Future<bool> getUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessKey = prefs.getString(ACCESS_KEY);
  try {
    final response = await http.get(
      Uri.parse('${BASE_URL}core/trainees/me/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT $accessKey'
      },
    );
    //success response
    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      print('im here');
      print(user.dailyCaloriesNeeds);
      return true;
    }
    //unauthorized response
    else if (response.statusCode == 401) {
      print('invalid access');
    }
    //Server is down
    else if (response.statusCode == 500) {
      print('server is down');
    }
  }
  //no internet connection
  catch (_) {
    print('no internet connection');
    return false;
  }
  return false;
}
