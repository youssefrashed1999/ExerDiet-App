import 'package:final_project/auth/log_in_screen.dart';
import 'package:final_project/auth/sign_up_screen.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';

class OpenScreen extends StatelessWidget {
  const OpenScreen({super.key});
  static const routeName = '/open_screen';
  void navigateLogInScreen(BuildContext context) {
    Navigator.of(context).pushNamed(LogInScreen.routeName);
  }

  void navigateSignUpScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SignUpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/main_screen_background.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Container(
          height: deviceSize.height,
          width: deviceSize.width,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          //decoration: BOX_DECORATION,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                APP_NAME,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 5,
              ),
              Image.asset(
                'assets/images/main_icon.png',
                height: 60,
                width: 60,
              ),
              SizedBox(
                height: deviceSize.height * 0.3,
              ),
              Text(
                SLOGAN1,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                SLOGAN2,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                height: deviceSize.height * 0.05,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => navigateLogInScreen(context),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      backgroundColor: MY_COLOR.shade700,
                      foregroundColor: Colors.white),
                  child: const Text('LOGIN',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => navigateSignUpScreen(context),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      foregroundColor: MY_COLOR.shade700,
                      backgroundColor: Colors.white),
                  child: const Text(
                    'Register Now',
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
