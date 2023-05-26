import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/diet_food.dart';

class DietFoodItem extends StatelessWidget {
  //const DietFoodItem({super.key});

  final DietFood dietFood;

  DietFoodItem({super.key, required this.dietFood});
  final GlobalKey<FormState> _formkey = GlobalKey();
  double amount = 0;
  void addFood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
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

    void selectPortion() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Quantity',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            content: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter quantity',
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor),
                  ),
                  Row(children: [
                    SizedBox(
                      width: 100,
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
                        onSaved: (newValue) => amount = double.parse(newValue!),
                      ),
                    ),
                    if (dietFood.category == 'F')
                      const Text('grams')
                    else if (dietFood.category == 'L')
                      const Text('mL')
                    else
                      const Text('tbsp'),
                  ]),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 20,color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        );
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
                    : Image.network(dietFood.imageUrl!, fit: BoxFit.fill),
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
                    Text('calories: ${dietFood.calories} g'),
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
