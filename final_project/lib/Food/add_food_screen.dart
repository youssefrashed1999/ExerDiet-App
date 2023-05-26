import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';

class AddFoodScreen extends StatefulWidget {
  AddFoodScreen({super.key});
  static const routeName = '/add-food';

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  Map<String, dynamic> _foodData = {
    'name': '',
    'calories': 0,
    'fats': 0,
    'proteins': 0,
    'carbs': 0,
    'imageUrl': ''
  };
  final _formKey = GlobalKey<FormState>();
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
              child: Container(
                margin: const EdgeInsets.all(15),
                width: 150,
                height: 150,
                color: Color.fromARGB(134, 158, 158, 158),
                child: const Center(
                  child: Icon(Icons.add_a_photo_sharp),
                ),
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
                        decoration: const InputDecoration(
                            hintText: 'calories', suffix: Text('/100 gm')),
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
                        decoration: const InputDecoration(
                            hintText: 'fats', suffix: Text('/100 gm')),
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
                        decoration: const InputDecoration(
                            hintText: 'proteins', suffix: Text('/100 gm')),
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
                        decoration: const InputDecoration(
                            hintText: 'carbs', suffix: Text('/100 gm')),
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
