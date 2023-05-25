import 'package:flutter/material.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  Map<String, dynamic> _recipeData = {
    'name': '',
    'instructions': '',
    'imageUrl': '',
    'ingredients': '',
  };
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create new recipe'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Text('Create new recipe',
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
                constraints: BoxConstraints(minWidth: _deviceSize.width * 0.7),
                width: _deviceSize.width * 0.7,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'title'),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'name is required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          /*_foodData['name'] = value;*/
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'calories'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'calories are required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          /* _foodData['calories'] = value;*/
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'fats'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'fats are required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          /* _foodData['fats'] = value;*/
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'proteins'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'proteins are required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          /* _foodData['proteins'] = value;*/
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'carbs'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'carbs are required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          /*_foodData['carbs'] = value;*/
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 290,
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                          ),
                          child: const Text('Create',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
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
