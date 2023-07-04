import 'package:final_project/constants.dart';
import 'package:final_project/models/exercise_instance.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ExerciseInstanceItem extends StatelessWidget {
  ExerciseInstance exercise;
  ExerciseInstanceItem({super.key, required this.exercise});

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
                  'rate this exercise so we can recommend you something simmilar',
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
                width: deviceSize.width * 0.22,
                height: deviceSize.height * 0.25,
                child: exercise.execise.imageUrl == null
                    ? null
                    : Image.network('$BASE_URL${exercise.execise.imageUrl!}',
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
                        '${exercise.execise.name}\n',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    FittedBox(
                        child: Text(
                            'total calories burnt: ${exercise.totalCalories} cal')),
                    FittedBox(
                        child: Text('body part: ${exercise.execise.bodypart}')),
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
