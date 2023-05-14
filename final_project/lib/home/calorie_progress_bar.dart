import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../models/user.dart';

class CaloriesProgressBar extends StatefulWidget {
  const CaloriesProgressBar({super.key});

  @override
  State<CaloriesProgressBar> createState() => _CaloriesProgressBarState();
}

Widget _innerWidget(double value, double max, BuildContext context) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${value.toInt()}/\n${max.toInt()}',
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.titleMedium?.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor)),
        Text(
          'Calories',
          style: TextStyle(
              fontFamily: Theme.of(context).textTheme.titleMedium?.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey),
        )
      ],
    ),
  );
}

class _CaloriesProgressBarState extends State<CaloriesProgressBar> {
  User _user = User.instance;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: deviceSize.height * 0.05,
        ),
        SizedBox(
          height: deviceSize.height * 0.3,
          width: deviceSize.width * 0.9,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.4,
                  height: deviceSize.height * 0.24,
                  child: SleekCircularSlider(
                    initialValue:
                        (_user.caloriesIntakeToday - _user.caloriesBurnedToday)
                            .toDouble(),
                    min: 0,
                    max: _user.dailyCaloriesNeeds.toDouble(),
                    appearance: CircularSliderAppearance(
                      startAngle: 270,
                      angleRange: 360,
                      customColors: CustomSliderColors(
                          trackColor: Colors.grey,
                          progressBarColors: const [
                            Color.fromRGBO(125, 236, 216, 1),
                            Color.fromRGBO(208, 251, 222, 1),
                          ],
                          hideShadow: true,
                          dotColor: Colors.white),
                    ),
                    innerWidget: (percentage) => _innerWidget(percentage,
                        _user.dailyCaloriesNeeds.toDouble(), context),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Icon(
                        Icons.flag,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Goal',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${_user.dailyCaloriesNeeds}',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      )
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      const Icon(
                        Icons.brunch_dining,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Food',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${_user.caloriesIntakeToday}',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      )
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      const Icon(Icons.fireplace_rounded, color: Colors.orange),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exercise',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${_user.caloriesBurnedToday}',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      )
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: deviceSize.height * 0.01,
        ),
        SizedBox(
          width: deviceSize.width * 0.9,
          height: deviceSize.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: deviceSize.width * 0.27,
                height: deviceSize.height * 0.15,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Carbs',
                        style: TextStyle(
                            fontFamily: 'RobotoCondensed',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      Text('${_user.carbsIntakeToday}/${_user.carbsNeeds}g',
                          style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor))
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: deviceSize.width * 0.27,
                height: deviceSize.height * 0.15,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Fats',
                        style: TextStyle(
                            fontFamily: 'RobotoCondensed',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      Text('${_user.fatsIntakeToday}/${_user.fatsNeeds}g',
                          style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor))
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: deviceSize.width * 0.27,
                height: deviceSize.height * 0.15,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Protein',
                        style: TextStyle(
                            fontFamily: 'RobotoCondensed',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      Text('${_user.proteinIntakeToday}/${_user.proteinNeeds}g',
                          style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor))
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
