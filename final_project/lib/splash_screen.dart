import 'dart:async';

import 'package:final_project/auth/open_screen.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed(OpenScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/main_icon.png',
      duration: 8000,
      nextScreen: OpenScreen(),
      splashTransition: SplashTransition.rotationTransition,
      animationDuration: Duration(seconds: 5),
      backgroundColor: MY_COLOR.shade700,
    );
  }
}
