import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
