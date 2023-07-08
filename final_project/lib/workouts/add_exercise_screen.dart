import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_page_screen.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});
  static const routeName = '/add-execise';

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  Map<String, dynamic> _ExerciseData = {
    'name': '',
    'bodypart': 'CH',
    'caloriesBurnt': 0,
    'imageUrl': '',
    'isRepetitive': 'T'
  };
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  //the function that determines the measurement unit based on food category//
  String IsRepetitive = 'F';
  String measurmentPicker() {
    if (IsRepetitive.contains('T')) {
      return '/10 repetitions';
    } else {
      return '/1 min';
    }
  }

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
      //send request without the image
      if (_myimage == null) {
        formData = FormData.fromMap({
          'name': _ExerciseData['name'].toString(),
          'body_part': _ExerciseData['bodypart'].toString(),
          'calories_burned': int.parse(_ExerciseData['caloriesBurnt']),
          'is_repetitive': _ExerciseData['isRepetitive'].toString(),
        });
      }
      //send request with the image
      else {
        File image = _myimage as File;
        formData = FormData.fromMap({
          'name': _ExerciseData['name'].toString(),
          'body_part': _ExerciseData['bodypart'].toString(),
          'calories_burned': int.parse(_ExerciseData['caloriesBurnt']),
          'is_repetitive': _ExerciseData['isRepetitive'].toString(),
          'image': await MultipartFile.fromFile(image.path)
        });
      }
      final dio = Dio();
      final response = await dio.post('${BASE_URL}gym/custom_exercises/',
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'JWT $accessKey'
          }),
          data: formData);
      if (response.statusCode == 201) {
        _btnController.success();
        Timer(const Duration(seconds: 2), () {
          _btnController.reset();
        });
        Navigator.of(context)
                    .pushReplacementNamed(HomePageScreen.routeName);
      } else {
        _btnController.error();
        Timer(const Duration(seconds: 2), () {
          _btnController.reset();
        });
      }
    } catch (_) {
      _btnController.error();
      Timer(const Duration(seconds: 2), () {
        _btnController.reset();
      });
    }
  }

  //.......................................................//
  var _myimage;
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
                      leading: const Icon(Icons.camera),
                      title: const Text('Camera'),
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add new exercise'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text('Add new exercise',
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
            Center(
              child: DropdownButton<String>(
                value: _ExerciseData['isRepetitive'],
                items: <String>['T', 'F']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.contains('T') ? 'Repetitve' : 'Non Repetitve',
                      style: const TextStyle(
                          fontSize: 16, color: Color.fromARGB(136, 0, 0, 0)),
                    ),
                  );
                }).toList(),
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    _ExerciseData['isRepetitive'] = newValue!;
                    IsRepetitive = newValue;
                  });
                },
              ),
            ),
            Center(
              child: DropdownButton<String>(
                value: _ExerciseData['bodypart'],
                items: <String>['CH', 'BK', 'AR', 'LG', 'CR', 'SH', 'AB']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.contains('CH')
                          ? 'Chest'
                          : value.contains('BK')
                              ? 'Back'
                              : value.contains('AR')
                                  ? 'Arms'
                                  : value.contains('LG')
                                      ? 'Legs'
                                      : value.contains('CR')
                                          ? 'Cardio'
                                          : value.contains('SH')
                                              ? 'Shoulders'
                                              : 'Abs',
                      style: const TextStyle(
                          fontSize: 16, color: Color.fromARGB(136, 0, 0, 0)),
                    ),
                  );
                }).toList(),
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    _ExerciseData['bodypart'] = newValue!;
                  });
                },
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
                          _ExerciseData['name'] = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'calories',
                            suffix: Text(measurmentPicker())),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.contains('.') ||
                              int.parse(value) <= 0) {
                            return 'Calories must be a valid integer!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _ExerciseData['caloriesBurnt'] =value;
                        },
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
