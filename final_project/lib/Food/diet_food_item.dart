import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/diet_food.dart';

class DietFoodItem extends StatelessWidget {
  //const DietFoodItem({super.key});

  final DietFood dietFood;
  late int mealId;
  late String mealDomain;

  DietFoodItem(
      {super.key,
      required this.dietFood,
      required this.mealId,
      required this.mealDomain});
  final GlobalKey<FormState> _formkey = GlobalKey();
  double amount = 0;
  void addFood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.post(
          Uri.parse('${BASE_URL}diet/$mealDomain/$mealId/food_instances/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'JWT $accessKey'
          },
          body: jsonEncode(
              <String, dynamic>{'food_id': dietFood.id, 'quantity': amount}));
      print('code is:${response.body.toString()}');
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
    } catch (_) {}
  }

  void submit() {
    if (!_formkey.currentState!.validate()) {
      // Invalid!
      return;
    }
    //valid form state
    //LogIn logic
    _formkey.currentState!.save();
    addFood();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    //Rating Dialog
    void showRating() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Rate this'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'rate this food so we can recommend you something simmilar',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildRating()
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        );

    void selectPortion() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Quantity',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Enter quantity',
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Row(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5 - 10,
                          child: TextFormField(
                            initialValue: 100.toString(),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (value) {
                              if (value!.isEmpty || double.parse(value) <= 0) {
                                return 'Quantity can\'t be negative';
                              }
                              return null;
                            },
                            onSaved: (newValue) =>
                                amount = double.parse(newValue!),
                          ),
                        ),
                        if (dietFood.category == 'F')
                          const Text('grams')
                        else if (dietFood.category == 'L')
                          const Text('mL')
                        else
                          const Text('tbsp'),
                      ]),
                      SizedBox(
                        width: deviceSize.width * 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40))),
                          onPressed: () {
                            submit();
                            Navigator.pop(context);
                          },
                          child: Text('ADD',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white, fontSize: 14)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: deviceSize.width,
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: dietFood.imageUrl == null
                    ? null
                    : Image.network('${BASE_URL}${dietFood.imageUrl!}',
                        fit: BoxFit.fill),
              ),
              const SizedBox(
                width: 7,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.29,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        '${dietFood.name}\n',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('calories: ${dietFood.calories} cal'),
                    Text('fats: ${dietFood.fats} g'),
                    Text('protien: ${dietFood.protein} g'),
                    Text('carbs: ${dietFood.carbs} g'),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      selectPortion();
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    iconSize: 40,
                    color: const Color.fromARGB(255, 97, 219, 213),
                  ),
                  IconButton(
                    onPressed: () {
                      showRating();
                    },
                    icon: const Icon(Icons.star),
                    iconSize: 40,
                    color: const Color.fromARGB(255, 97, 219, 213),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildRating() => RatingBar.builder(
      initialRating: 0,
      minRating: 0,
      direction: Axis.horizontal,
      updateOnDrag: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
