import 'dart:io';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodScreen extends StatefulWidget {
  AddFoodScreen({super.key});
  static const routeName = '/add-food';

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  Map<String, dynamic> _foodData = {
    'name': '',
    'category': 'F',
    'calories': 0,
    'fats': 0,
    'proteins': 0,
    'carbs': 0,
    'imageUrl': ''
  };
  final _formKey = GlobalKey<FormState>();
  //the function that determines the measurement unit based on food category//
  String selectedCategory = 'F';
  String measurmentPicker() {
    if (selectedCategory.contains('F')) {
      return '/100 gm';
    } else if (selectedCategory.contains('B')) {
      return '/100 ml';
    } else {
      return '/1 spoon';
    }
  }

  //.......................................................//
  var _myimage;
  _showOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Upload photo from',
                  style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Gallery'),
                      onTap: () {
                        _UploadFromGallery(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                      onTap: () {
                        _UploadFromCamera(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  Future _UploadFromGallery(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _myimage = File(image!.path);
    });
    Navigator.pop(context);
  }

  Future _UploadFromCamera(BuildContext context) async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _myimage = File(image!.path);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add new food'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Text('Add new food',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 97, 219, 213),
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
                value: _foodData['category'],

                items: <String>['F', 'B', 'S']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.contains('F')
                          ? 'food'
                          : value.contains('B')
                              ? 'beverage'
                              : 'seasoning',
                      style: const TextStyle(
                          fontSize: 16, color: Color.fromARGB(136, 0, 0, 0)),
                    ),
                  );
                }).toList(),
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    _foodData['category'] = newValue!;
                    selectedCategory = newValue;
                    print(_foodData['category']);
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
                constraints: BoxConstraints(minWidth: _deviceSize.width * 0.75),
                width: _deviceSize.width * 0.75,
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
                          _foodData['name'] = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'calories',
                            suffix: Text(measurmentPicker())),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'calories are required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _foodData['calories'] = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'fats', suffix: Text(measurmentPicker())),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'fats are required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _foodData['fats'] = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'proteins',
                            suffix: Text(measurmentPicker())),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'proteins are required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _foodData['proteins'] = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'carbs',
                            suffix: Text(measurmentPicker())),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'carbs are required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _foodData['carbs'] = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 290,
                        child: ElevatedButton(
                          onPressed: () =>
                              {if (_formKey.currentState!.validate()) {}},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                          ),
                          child: const Text('Save',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            /*Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Name: '),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null) {
                                  return 'Name field is required!';
                                }
                              },
                              onSaved: (newValue) {
                                _foodData['name'] = newValue;
                              },
                            )
                          ],
                        )
                      ],
                    ))*/
          ],
        ),
      ),
    );
  }
}
