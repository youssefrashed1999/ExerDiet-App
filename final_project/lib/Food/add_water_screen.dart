import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../models/user.dart';

class AddWater extends StatefulWidget {
  static const routeName = '/add_water';
  const AddWater({super.key});

  @override
  State<AddWater> createState() => _AddWaterState();
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
          'milli-Liter',
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

class _AddWaterState extends State<AddWater> {
  User _user = User.instance;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var amount = 250;

    void d() => showDialog(
          context: context,
          builder: (BuildContext context) {
            return Expanded(
              child: AlertDialog(
                title: Text(
                  'Measurements',
                  style: TextStyle(color: Color.fromRGBO(125, 236, 216, 1)),
                ),
                content: Text('pick your amount of choice'),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('250'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    amount = 250;
                                  });
                                },
                                icon: Icon(Icons.water))
                          ],
                        ),
                        Row(
                          children: [
                            Text('350'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    amount = 350;
                                  });
                                },
                                icon: Icon(Icons.water_drop))
                          ],
                        ),
                        Row(
                          children: [
                            Text('450'),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    amount = 450;
                                  });
                                },
                                icon: Icon(Icons.coffee_maker))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
    Icon iconpicker() {
      if (amount == 250) {
        return Icon(Icons.water);
      } else if (amount == 350) {
        return Icon(Icons.water_drop);
      } else {
        return Icon(Icons.coffee_maker);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Water'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(125, 236, 216, 1),
        foregroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
          Center(
            child: SizedBox(
              height: deviceSize.height * 0.3,
              width: deviceSize.width * 0.85,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 8,
                child: SizedBox(
                  width: deviceSize.width * 0.3,
                  height: deviceSize.height * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SleekCircularSlider(
                      initialValue: (_user.waterIntakeToday).toDouble(),
                      min: 0,
                      max: _user.dailyWaterNeeds.toDouble(),
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
                          _user.dailyWaterNeeds.toDouble(), context),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                d();
              },
              child: iconpicker())
        ],
      ),
    );
  }
}
