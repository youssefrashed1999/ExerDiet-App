import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:final_project/auth/log_in_screen.dart';
import 'package:final_project/healthQuiz/health_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/sign-up-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(125, 236, 216, 1),
              Color.fromRGBO(208, 251, 222, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MediaQuery.of(context).viewInsets.bottom == 0
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? const Center(
                      child: Text(
                        'ExerDiet',
                        style: TextStyle(
                          color: Color.fromARGB(214, 255, 255, 255),
                          fontSize: 36,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
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
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: SignUpCard(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpCard extends StatefulWidget {
  const SignUpCard({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstname': '',
    'lastname': '',
    'username': '',
  };
  String? _emailErrorText = null;
  String? _usernameErrorText = null;
  String? _passwordErrorText = null;

  void navigateToLogInScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(LogInScreen.routeName);
  }

  final _passwordController = TextEditingController();

  void _sendHttpRequest() async {
    _btnController.start();
    try {
      final response = await http.post(
        Uri.parse('${BASE_URL}auth/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'WWW-Authenticate': 'JWT realm="api"'
        },
        body: jsonEncode(<String, String?>{
          'username': _authData['username'],
          'password': _authData['password'],
          'email': _authData['email'],
          'first_name': _authData['firstname'],
          'last_name': _authData['lastname']
        }),
      );
      print('status code:${response.statusCode}');
      //account created successfully
      if (response.statusCode == 201) {
        _btnController.success();
        Fluttertoast.showToast(
            msg: 'Successful Signup.',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
        Timer(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.of(context).pushReplacementNamed(LogInScreen.routeName);
        });
      }
      //bad request
      else if (response.statusCode == 400) {
        _btnController.error();
        //check what makes it a bad request
        setState(() {
          if (jsonDecode(response.body)['username'] != null) {
            _usernameErrorText = jsonDecode(response.body)['username'][0];
          }
          if (jsonDecode(response.body)['email'] != null) {
            _emailErrorText = jsonDecode(response.body)['email'][0];
          }
          if (jsonDecode(response.body)['password'] != null) {
            _passwordErrorText = jsonDecode(response.body)['password'][0];
          }
        });
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

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _emailErrorText = null;
      _usernameErrorText = null;
      _passwordErrorText = null;
    });
    //validate form
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
      return;
    }
    //signup logic
    _formKey.currentState!.save();
    setState(() {});
    //send the request
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
                        'Create Account',
                        style: TextStyle(
                          color: Color.fromARGB(255, 97, 219, 213),
                          fontSize: 20,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Firstname is required!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['firstname'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lastname is required!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['lastname'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Username', errorText: _usernameErrorText),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username is required!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['username'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'E-Mail', errorText: _emailErrorText),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password', errorText: _passwordErrorText),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 290,
                      child: RoundedLoadingButton(
                        controller: _btnController,
                        onPressed: _submit,
                        color: Theme.of(context).primaryColor,
                        child: const Text('SIGN UP',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      onPressed: () => navigateToLogInScreen(context),
                      child: const Text('already have an account? Login',
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
