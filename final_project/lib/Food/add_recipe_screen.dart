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
                          _recipeData['name'] = value;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(hintText: 'instructions'),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 30,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'instructions is required!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _recipeData['instructions'] = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: -1)),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Text('ingredients'),
                              Icon(Icons.arrow_right)
                            ],
                          )),
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
                          child: const Text('save',
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
