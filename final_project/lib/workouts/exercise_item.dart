import 'package:flutter/material.dart';

class ExerciseItem extends StatelessWidget {
  //const ExerciseItem({super.key});
  final String id;
  final String name;
  final String bodypart;
  final double caloriesBurnt;
  final bool isRepetitive;
  final String imageUrl;

  const ExerciseItem(
      {required this.id,
      required this.name,
      required this.bodypart,
      required this.caloriesBurnt,
      required this.isRepetitive,
      required this.imageUrl});

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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: deviceSize.width,
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name\n',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text('bodypart: $bodypart'),
                  Text('calories burnt: $caloriesBurnt'),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    iconSize: 40,
                    color: const Color.fromARGB(255, 97, 219, 213),
                  ),
                  IconButton(
                    onPressed: () {},
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
