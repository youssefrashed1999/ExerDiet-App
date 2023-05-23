import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/diet_food.dart';
import 'diet_food_item.dart';
import 'package:http/http.dart' as http;

class FoodOverviewScreen extends StatefulWidget {
  static const routeName = '/food';

  @override
  State<FoodOverviewScreen> createState() => _FoodOverviewScreenState();
}

class _FoodOverviewScreenState extends State<FoodOverviewScreen> {
  List<DietFood> loadedfood = List.empty(growable: true);
  String? nextPage = "https://exerdiet.pythonanywhere.com/diet/foods/";
  bool is_food_clicked = true;
  // List<DietFood> displayloadedfood = List.from(loadedfood);
  // void updateList(String value) {
  //   setState(() {
  //     displayloadedfood = loadedfood
  //         .where((element) =>
  //             element.name.toLowerCase().contains(value.toLowerCase()))
  //         .toList();
  //   });
  // }
  void getFood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextPage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedfood
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {});
      }
    } catch (e) {
      print('problem is $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getFood();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(is_food_clicked ? 'Add Food' : 'Add recipe')),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(is_food_clicked ? 'Add Food' : 'Add recipe',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 97, 219, 213),
                fontSize: 20,
                fontFamily: 'Anton',
                fontWeight: FontWeight.normal,
              )),
          const SizedBox(
            height: 7,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: TextField(
              //onChanged: (value) => updateList(value),
              style: const TextStyle(
                  color: Color.fromARGB(255, 97, 219, 213), fontSize: 12),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0x00000000),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                hintText: "eg: Orange",
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: is_food_clicked
                        ? const Color.fromARGB(255, 97, 219, 213)
                        : Colors.white,
                    elevation: is_food_clicked ? 4 : 2,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.zero, left: Radius.circular(40))),
                  ),
                  onPressed: () {
                    setState(() {
                      is_food_clicked = true;
                    });
                  },
                  child: Text('Food',
                      style: TextStyle(
                          color: is_food_clicked
                              ? Colors.white
                              : const Color.fromARGB(255, 97, 219, 213)))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: is_food_clicked
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 97, 219, 213),
                    elevation: is_food_clicked ? 2 : 4,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.zero, right: Radius.circular(40))),
                  ),
                  onPressed: () {
                    setState(() {
                      is_food_clicked = false;
                    });
                  },
                  child: Text('Recipes',
                      style: TextStyle(
                          color: is_food_clicked
                              ? const Color.fromARGB(255, 97, 219, 213)
                              : Colors.white)))
            ],
          ),
          if (loadedfood.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: nextPage == null
                    ? loadedfood.length
                    : loadedfood.length + 1,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (nextPage!=null &&index == loadedfood.length) {
                    return ElevatedButton(
                        onPressed: () {
                          getFood();
                        },
                        child: const Text('Load more'));
                  } else {
                    return DietFoodItem(
                      id: loadedfood[index].id,
                      name: loadedfood[index].name,
                      imageUrl: loadedfood[index].imageUrl,
                      calories: loadedfood[index].calories,
                      fats: loadedfood[index].fats,
                      protein: loadedfood[index].protein,
                      carbs: loadedfood[index].carbs,
                    );
                  }
                },
                scrollDirection: Axis.vertical,
              ),
            )
          else
            const CircularProgressIndicator(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(40), left: Radius.circular(40))),
              ),
              onPressed: () {},
              child: Text(
                  is_food_clicked ? 'create new food' : 'create new recipe',
                  style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
