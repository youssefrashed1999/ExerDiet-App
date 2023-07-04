import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:http/http.dart' as http;

class YoloSubmitFood extends StatefulWidget {
  List results;
  int mealId;
  YoloSubmitFood({super.key, required this.results, required this.mealId});

  @override
  State<YoloSubmitFood> createState() => _YoloSubmitFoodState();
}

class _YoloSubmitFoodState extends State<YoloSubmitFood> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, double> finalResults = {};
  final Map<String, int> foodIds = {
    'Apple': 1,
    'Apple pie': 237,
    'Banana': 3,
    'Bell pepper': 41,
    'Bread': 7,
    'Broccoli': 6,
    'Carrot': 15,
    'Cheese': 104,
    'Chicken nugget': 239,
    'Chicken roast': 238,
    'Chips': 240,
    'Chocolate bar': 241,
    'Coke': 242,
    'Cookie': 150,
    'Cracker': 243,
    'Croissant': 244,
    'Cucumber': 19,
    'Deep fried chicken wing': 245,
    'Donuts': 246,
    'Fanta': 246,
    'French fries': 151,
    'Frutta secca': 262,
    'Grissini': 261,
    'Hamburger': 169,
    'Hot dog': 119,
    'Ice cream': 265,
    'Juice': 218,
    'Lasagna': 173,
    'Lemon': 266,
    'Mango': 54,
    'Milk': 13,
    'Muffin': 264,
    'Mushroom': 42,
    'Pasta': 55,
    'Orange': 22,
    'Pancake': 147,
    'Peach': 248,
    'Pear': 249,
    'Pineapple': 34,
    'Pizza': 135,
    'Popcorn': 250,
    'Potato': 138,
    'Cheese cake': 251,
    'Salad': 190,
    'Salatini': 263,
    'Sandwich': 128,
    'Spread': 253,
    'Steak': 89,
    'Strawberry': 30,
    'Tomato': 129,
    'Waffle': 254,
    'Watermelon': 134,
    'Zucchini': 44,
    'Flafel': 180,
    'Fool': 256,
    'Koshary': 257,
    'Molokhia': 258,
    'Roz-blabn': 259,
    'Wara-enab': 260,
  };
  void _submitData() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    print(finalResults);
    finalResults.forEach((key, value) {
      sendHttpRequest(foodIds[key]!, value);
    });
    Fluttertoast.showToast(
        msg: 'Food added successfully',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.white,
        textColor: MY_COLOR[300]);
    Navigator.of(context).pop();
  }

  void sendHttpRequest(int id, double amount) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.post(
          Uri.parse('${BASE_URL}diet/meals/${widget.mealId}/food_instances/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'JWT $accessKey'
          },
          body:
              jsonEncode(<String, dynamic>{'food_id': id, 'quantity': amount}));
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: 'Food added successfully',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      } else {
        Fluttertoast.showToast(
            msg: 'Error adding food!\nTry again later!',
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: MY_COLOR[300]);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height,
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 30,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      'Add Food',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.results.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  // Get the current result
                  var result = widget.results[index];

                  // Get the tag value
                  var tag = result['tag'];

                  return ListTile(
                    title: Text(
                        tag), // Assuming 'tag' is the key for the food item name
                    subtitle: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // Handle the input change
                        // You can access the associated result and entered weight here
                        // using the 'result' and 'value' variables
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter weight in grams',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (int.parse(value) < 0) {
                          return 'Please enter a positive value';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        finalResults.addAll(
                            <String, double>{tag: double.parse(newValue!)});
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: deviceSize.width * 0.9,
              child: ElevatedButton(
                onPressed: () => _submitData(),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white),
                child:
                    const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
