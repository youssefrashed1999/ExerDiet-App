import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';

class AddFoodScreen extends StatelessWidget {
  AddFoodScreen({super.key});
  static const routeName = '/add-food';
  Map<String, dynamic> _foodData = {
    'name': '',
    'calories': 0,
    'fats': 0,
    'protein': 0,
    'carbs': 0,
    'imageUrl': ''
  };
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new food'),
      ),
      body: Stack(
        children: [
          Container(
            width: _deviceSize.width,
            height: _deviceSize.height,
            decoration: BOX_DECORATION,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: _deviceSize.width,
                height: _deviceSize.height * 0.3,
                color: Colors.grey,
                child: const Center(
                  child: Icon(Icons.add_a_photo_sharp),
                ),
              ),
              Form(
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
                  ))
            ],
          )
        ],
      ),
    );
  }
}
