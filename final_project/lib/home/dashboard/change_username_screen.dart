import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class ChangeUsernameScreen extends StatefulWidget {
  static const routeName = '/change-username';
  const ChangeUsernameScreen({super.key});

  @override
  State<ChangeUsernameScreen> createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  //keys and controllers
  final GlobalKey<FormState> _formkey = GlobalKey();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  //map to save user's input
  Map<String, String> userData = {'password': '', 'new_username': ''};
  String? usernameError;
  String? passwordError;
  void _submit(BuildContext context) {
    setState(() {
      passwordError = null;
      usernameError = null;
    });
    //hide keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formkey.currentState!.validate()) {
      // Invalid!
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
      return;
    }
    //valid state
    _formkey.currentState!.save();
    setState(() {});
    _sendHttpRequest();
    setState(() {});
  }

  void _sendHttpRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.post(
        Uri.parse('${BASE_URL}auth/users/set_username/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
        body: jsonEncode(<String, String?>{
          'current_password': userData['password'],
          'new_username': userData['new_username']
        }),
      );
      //username changed
      if (response.statusCode == 204) {
        _btnController.success();
      }
      //error with either  password or new username
      else if (response.statusCode == 400) {
        _btnController.error();
        setState(() {
          if(jsonDecode(response.body)['current_password']!=null) {
            passwordError = jsonDecode(response.body)['current_password'][0];
          }
          if(jsonDecode(response.body)['new_username']!=null) {
            usernameError = jsonDecode(response.body)['new_username'][0];
          }
        });
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
    } catch (_) {
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change username',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: deviceSize.width,
        color: Colors.grey.shade200,
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'username',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                      errorText: usernameError),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 18),
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.contains(' ') ||
                        value.contains(';')) {
                      return '150 characters or fewer. Letters, digits and @/./+/-/_ only.';
                    }
                    return null;
                  },
                  onSaved: (newValue) => userData['new_username'] = newValue!,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                      errorText: passwordError),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required field!';
                    }
                    return null;
                  },
                  onSaved: (newValue) => userData['password'] = newValue!,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: deviceSize.width * 0.8,
                  child: RoundedLoadingButton(
                    height: 45,
                    controller: _btnController,
                    onPressed: () =>_submit(context),
                    color: Theme.of(context).primaryColor,
                    borderRadius: 40,
                    child: const Text('Submit',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
