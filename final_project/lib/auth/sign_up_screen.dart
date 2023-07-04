// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'package:final_project/auth/log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

bool _isSignUpCompleted = false;

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up-screen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void setstate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: AUTH_BACKGROUND,
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
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
              if (!_isSignUpCompleted)
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: _SignUpCard(
                    setstate: setstate,
                  ),
                ),
              if (_isSignUpCompleted)
                SizedBox(
                  height: deviceSize.height * 0.15,
                ),
              if (_isSignUpCompleted) const _CompletedSignUp(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpCard extends StatefulWidget {
  final Function() setstate;
  const _SignUpCard({
    required this.setstate,
    Key? key,
  }) : super(key: key);

  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<_SignUpCard> {
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
  String? _emailErrorText;
  String? _usernameErrorText;
  String? _passwordErrorText;

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

      //account created successfully
      if (response.statusCode == 201) {
        _isSignUpCompleted = true;
        widget.setstate();
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
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontFamily: 'RobotoCondensed',
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
                        return null;
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
                      child: Text('already have an account? Login',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
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

class _CompletedSignUp extends StatelessWidget {
  const _CompletedSignUp();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 8.0,
      child: Container(
        width: deviceSize.width * 0.85,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
            Text(
              'Account created successfully!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 15,
            ),
            Text('An activation email is sent to your email address.',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.black, fontSize: 14)),
            Text('Activate your account to start your journey.',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.black, fontSize: 14)),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: deviceSize.width * 0.7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LogInScreen.routeName);
                },
                child: Text('Login',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white, fontSize: 14)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
