
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';


class DietFoodItem extends StatelessWidget {
  //const DietFoodItem({super.key});

  final String id;
  final String name;
  final String imageUrl;
  final double calories;
  final double fats;
  final double protein;
  final double carbs;

  const DietFoodItem(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.calories,
      required this.fats,
      required this.protein,
      required this.carbs});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: deviceSize.width,
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.network(imageUrl, fit: BoxFit.fill),
              ),
              const SizedBox(
                width: 7,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name\n',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text('calories: $calories g'),
                  Text('fats: $fats g'),
                  Text('protien: $protein g'),
                  Text('carbs: $carbs g'),
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline_rounded),
                iconSize: 40,
                padding: const EdgeInsets.all(10),
                color: const Color.fromARGB(255, 97, 219, 213),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
