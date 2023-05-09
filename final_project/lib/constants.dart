import 'package:flutter/material.dart';

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
