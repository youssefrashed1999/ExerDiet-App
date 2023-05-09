import 'dart:convert';
import 'package:final_project/auth/sign_up_screen.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';

class LogInScreen extends StatelessWidget {
  static const routeName = '/Log-in-screen';
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BOX_DECORATION,
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
                child: LogInCard(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LogInCard extends StatefulWidget {
  const LogInCard({
    Key? key,
  }) : super(key: key);

  @override
  _LogInCardState createState() => _LogInCardState();
}

class _LogInCardState extends State<LogInCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
  }

  void _sendHttpRequest() async {
    final response = await http.post(
      Uri.parse('${BASE_URL}auth/jwt/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'username': _authData['email'],
        'password': _authData['password']
      }),
    );
    //success response
    if (response.statusCode == 200) {
      //get response and save it in local storage
      Token token = Token.fromJson(jsonDecode(response.body));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(ACCESS_KEY, token.access);
      await prefs.setString(REFRESH_KEY, token.refresh);
    }
    //unauthorized response
    else if (response.statusCode == 401) {
      final message = jsonDecode(response.body)['detail'];
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.white,
          textColor: MY_COLOR[300]);
    }
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    //TO-DO
    //LogIn logic
    _sendHttpRequest();
    setState(() {
      _isLoading = false;
    });
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
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      //padding: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'E-Mail'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
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
                    const SizedBox(
                      height: 30,
                    ),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: 290,
                        child: ElevatedButton(
                          onPressed: () => _submit(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                          ),
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
