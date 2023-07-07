import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

final BOX_DECORATION = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Colors.grey.shade200,
      Colors.grey.shade200,

      //Color.fromRGBO(125, 236, 216, 1),
      //Color.fromRGBO(208, 251, 222, 1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 1],
  ),
);
const AUTH_BACKGROUND = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFF4A148C),
      Color(0xFF4A148C),

      //Color.fromRGBO(125, 236, 216, 1),
      //Color.fromRGBO(208, 251, 222, 1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 1],
  ),
);
final BACKGROUND_COLOR = Colors.grey.shade200;
MaterialColor MY_COLOR = const MaterialColor(
  0xFF4A148C,
  <int, Color>{
    50: Color(0xFF4A148C),
    100: Color(0xFF4A148C),
    200: Color(0xFF4A148C),
    300: Color(0xFF4A148C),
    400: Color(0xFF4A148C),
    500: Color(0xFF4A148C),
    600: Color(0xFF4A148C),
    700: Color(0xFF4A148C),
    800: Color(0xFF4A148C),
    900: Color(0xFF4A148C),
  },
);
const APP_NAME = 'ExerDiet';
const SLOGAN1 = 'Healthy life,';
const SLOGAN2 = 'Healthy Mind';

const BASE_URL = 'https://exerdiet.pythonanywhere.com/';
const ACCESS_KEY = 'access-key';
const REFRESH_KEY = 'refresh-key';

void getUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessKey = prefs.getString(ACCESS_KEY);
  try {
    final response = await http.get(
      Uri.parse('${BASE_URL}auth/users/me/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'JWT $accessKey'
      },
    );
    //success response
    if (response.statusCode == 200) {
      User user = User.instance;
      user.setUsername = jsonDecode(response.body)['username'].toString();
    }
  }
  //no internet connection
  catch (_) {}
}

Future<int> getUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessKey = prefs.getString(ACCESS_KEY);
  getUsername();
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
      return 1;
    }
    //unauthorized response
    else if (response.statusCode == 401) {
      return 3;
    }
    //new user
    else if (response.statusCode == 404) {
      return 2;
    }
    //Server is down
    else if (response.statusCode == 500) {
      return 3;
    }
  }
  //no internet connection
  catch (_) {
    return 3;
  }
  return 3;
}
