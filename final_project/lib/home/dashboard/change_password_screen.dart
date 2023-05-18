import 'dart:async';
import 'dart:convert';
import 'package:final_project/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = 'change-password';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //keys and controllers
  final GlobalKey<FormState> _formkey = GlobalKey();
  final _passwordController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String? passwordError;
  String? newPasswordError;
  //map to save user's input
  Map<String, String> userData = {'current_password': '', 'new_password': ''};
  void _submit(BuildContext context) {
    setState(() {
      passwordError = null;
      newPasswordError = null;
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
        Uri.parse('${BASE_URL}auth/users/set_password/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
        body: jsonEncode(<String, String?>{
          'new_password': userData['new_password'],
          'current_password': userData['current_password']
        }),
      );
      //password changed
      if (response.statusCode == 204) {
        _btnController.success();
      }
      //error with either current password or new password
      else if (response.statusCode == 400) {
        _btnController.error();
        setState(() {
          if (jsonDecode(response.body)['current_password'] != null) {
            passwordError = jsonDecode(response.body)['current_password'][0];
          }
          if (jsonDecode(response.body)['new_password'] != null) {
            newPasswordError = jsonDecode(response.body)['new_password'][0];
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
          'Change password',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: deviceSize.width,
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Current password',
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
                    if (value!.isEmpty) return 'Required field!';
                    return null;
                  },
                  onSaved: (newValue) =>
                      userData['current_password'] = newValue!,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'New password',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                      errorText: newPasswordError),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                  obscureText: true,
                  validator: (value) {
                    if (value!.length < 8) {
                      return 'Password should at least be 8 characters';
                    }
                    return null;
                  },
                  onSaved: (newValue) => userData['new_password'] = newValue!,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Confirm new password',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87)),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: deviceSize.width * 0.8,
                  child: RoundedLoadingButton(
                    height: 45,
                    controller: _btnController,
                    onPressed: () => _submit(context),
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
