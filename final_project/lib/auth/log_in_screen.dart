import 'dart:async';
import 'dart:convert';
import 'package:final_project/auth/sign_up_screen.dart';
import 'package:final_project/constants.dart';
import 'package:final_project/healthQuiz/health_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_page_screen.dart';
import '../models/token.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = '/Log-in-screen';

  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isForgotPassword = false;
  void toggleWidgets() {
    setState(() {
      //toggle the boolean
      isForgotPassword = !isForgotPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: deviceSize.width,
            height: deviceSize.height,
            decoration: BOX_DECORATION,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          'ExerDiet',
                          style: TextStyle(
                            color: Color.fromARGB(214, 255, 255, 255),
                            fontSize: 28,
                            fontFamily: 'RobotoCondensed',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 1,
                    ),
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? Image.asset(
                      'assets/images/main_icon.png',
                      height: 60,
                      width: 60,
                    )
                  : const SizedBox(
                      height: 1,
                    ),
            ],
          ),
          if (!isForgotPassword)
            Align(
              alignment: Alignment.center,
              child: _LogInCard(
                toggleWidgets: toggleWidgets,
              ),
            )
          else
            const Align(
              alignment: Alignment.center,
              child: _ForgotPasswordWigdet(),
            ),
        ],
      ),
    );
  }
}

class _LogInCard extends StatefulWidget {
  final Function() toggleWidgets;
  const _LogInCard({Key? key, required this.toggleWidgets}) : super(key: key);

  @override
  _LogInCardState createState() => _LogInCardState();
}

class _LogInCardState extends State<_LogInCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };

  final _passwordController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
  }

  void _sendHttpRequest() async {
    _btnController.start();
    try {
      final response = await http.post(
        Uri.parse('${BASE_URL}auth/jwt/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'username': _authData['username'],
          'password': _authData['password']
        }),
      );
      //success response
      if (response.statusCode == 200) {
        _btnController.success();
        //get response and save it in local storage
        Token token = Token.fromJson(jsonDecode(response.body));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(ACCESS_KEY, token.access);
        await prefs.setString(REFRESH_KEY, token.refresh);
        //get user info
        int status = await getUserInfo();
        //navigate to home screen if old user
        if (status == 1) {
          if (!context.mounted) return;
          Navigator.of(context).pushReplacementNamed(HomePageScreen.routeName);
        }
        //navigate to health quiz screen if new user
        else if (status == 2) {
          if (!context.mounted) return;
          Navigator.of(context)
              .pushReplacementNamed(HealthQuizScreen.routeName);
        }
        //display toast if can't retrieve user's info
        else if (status == 3) {
          _btnController.error();
          Fluttertoast.showToast(
              msg:
                  'Error occurred while retreiving user\'s information!\nTry again later.',
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.white,
              textColor: MY_COLOR[300]);
          Timer(const Duration(seconds: 2), () {
            _btnController.reset();
          });
        }
      }
      //unauthorized response
      else if (response.statusCode == 401) {
        _btnController.error();
        final message = jsonDecode(response.body)['detail'];
        Fluttertoast.showToast(
            msg: message,
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
    }
    //no internet connection
    catch (_) {
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

  void _submit(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
      return;
    }
    //valid form state
    //LogIn logic
    _formKey.currentState!.save();
    setState(() {});
    _sendHttpRequest();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 8.0,
            child: Container(
              //height: _authMode == AuthMode.Signup ? 700 : 347,
              constraints: BoxConstraints(minWidth: deviceSize.width * 0.85),
              width: deviceSize.width * 0.85,
              padding: const EdgeInsets.all(20),
              //padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 26.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color.fromARGB(255, 97, 219, 213),
                          fontSize: 20,
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Invalid username!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['username'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent),
                        onPressed: () => widget.toggleWidgets(),
                        child: const Text('Forgot password?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 97, 219, 213),
                                fontSize: 13)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 290,
                      child: RoundedLoadingButton(
                        controller: _btnController,
                        onPressed: () => _submit(context),
                        color: MY_COLOR[300],
                        borderRadius: 40,
                        child: const Text('LOGIN',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      onPressed: () => navigateToSignUpScreen(context),
                      child: const Text('dont have an account? signup',
                          style: TextStyle(
                              color: Color.fromARGB(255, 97, 219, 213),
                              fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ForgotPasswordWigdet extends StatefulWidget {
  const _ForgotPasswordWigdet();

  @override
  State<_ForgotPasswordWigdet> createState() => __ForgotPasswordWigdetState();
}

class __ForgotPasswordWigdetState extends State<_ForgotPasswordWigdet> {
  final _formKey = GlobalKey();
  final _btnController = RoundedLoadingButtonController();
  String? email;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 8.0,
          child: Container(
            //height: _authMode == AuthMode.Signup ? 700 : 347,
            constraints: BoxConstraints(minWidth: deviceSize.width * 0.85),
            width: deviceSize.width * 0.85,
            padding: const EdgeInsets.all(20),
            //padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 26.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Color.fromARGB(255, 97, 219, 213),
                        fontSize: 20,
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid Email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 290,
                    child: RoundedLoadingButton(
                      controller: _btnController,
                      onPressed: () {},
                      color: MY_COLOR[300],
                      borderRadius: 40,
                      child: const Text('SUBMIT',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
