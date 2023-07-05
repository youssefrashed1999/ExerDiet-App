import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'add_exercise_instances_to_workout.dart';

class AddWorkoutScreen extends StatefulWidget {
  static const routeName = '/add-workout';
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  Map<String, dynamic> _workoutData = {
    'name': '',
    'instructions': '',
    'imageUrl': '',
    'exerciseInstance': '',
  };
  var _myimage;
  int workoutId = -1;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  void submit() {
    if (!_formKey.currentState!.validate()) {
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
      return;
    }
    _formKey.currentState!.save();
    sendHttpRequest();
  }

  void sendHttpRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    late FormData formData;
    try {
      if (_myimage == null) {
        formData = FormData.fromMap({
          'name': _workoutData['name'].toString(),
          'instructions': _workoutData['instructions'].toString()
        });
      } else {
        File image = _myimage as File;
        formData = FormData.fromMap({
          'name': _workoutData['name'].toString(),
          'instructions': _workoutData['instructions'].toString(),
          'image': await MultipartFile.fromFile(image.path)
        });
        final dio = Dio();
        final response = await dio.post('${BASE_URL}gym/workouts/',
            options: Options(headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'JWT $accessKey'
            }),
            data: formData);
        if (response.statusCode == 201) {
          _btnController.success();
          workoutId = response.data['id'] as int;
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context)
                .pushNamed(AddExerciseInsances.routeName, arguments: workoutId);
          });
        } else {
          _btnController.error();
          Timer(const Duration(seconds: 2), () {
            _btnController.reset();
          });
        }
      }
    } catch (e) {
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
    }
  }

  _showOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Upload photo from',
                  style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text('Gallery'),
                      onTap: () {
                        _uploadFromGallery(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                      onTap: () {
                        _uploadFromCamera(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  Future _uploadFromGallery(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _myimage = File(image!.path);
    });
    Navigator.pop(context);
  }

  Future _uploadFromCamera(BuildContext context) async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _myimage = File(image!.path);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new workout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text('Create new workout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.normal,
                )),
            Center(
              child: _myimage != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      width: 150,
                      height: 150,
                      child: Image.file(
                        _myimage,
                        width: 150,
                        height: 150,
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      width: 150,
                      height: 150,
                      color: const Color.fromARGB(134, 158, 158, 158),
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              _showOption(context);
                            },
                            icon: const Icon(Icons.camera_alt_rounded)),
                      ),
                    ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 8.0,
              child: Container(
                constraints: BoxConstraints(minWidth: deviceSize.width * 0.75),
                width: deviceSize.width * 0.75,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'name'),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'name is required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _workoutData['name'] = value;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(hintText: 'instructions'),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 30,
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          if (value!.isEmpty) {
                            _workoutData['instructions'] = '';
                          } else {
                            _workoutData['instructions'] = value;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 290,
                        child: RoundedLoadingButton(
                          controller: _btnController,
                          onPressed: () => submit(),
                          color: MY_COLOR[300],
                          borderRadius: 40,
                          child: const Text('Save',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
