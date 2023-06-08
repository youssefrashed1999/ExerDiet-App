import 'dart:convert';

import 'package:final_project/Food/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/diet_food.dart';
import 'add_food_screen.dart';
import 'diet_food_item.dart';

class FoodTab extends StatefulWidget {
  final int mealId;
  final String? nextPage;
  final String category;
  final String mealDomain;
  const FoodTab(
      {super.key,
      required this.mealId,
      required this.category,
      required this.nextPage,
      required this.mealDomain});

  @override
  State<FoodTab> createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> with AutomaticKeepAliveClientMixin {
  List<DietFood> loadedfood = List.empty(growable: true);
  late String? nextFoodPage = widget.nextPage;
  TextEditingController foodController = TextEditingController();
  bool isFoodLoadingComplete = false;
  void getFood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse(nextFoodPage!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextFoodPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedfood
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isFoodLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  void searchFood(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    try {
      final response = await http.get(
        Uri.parse('${nextFoodPage!}?search=$value'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'JWT $accessKey'
        },
      );
      //success response
      if (response.statusCode == 200) {
        nextFoodPage = jsonDecode(response.body)['next'];
        int count = jsonDecode(response.body)['results'].length;
        for (int i = 0; i < count; i++) {
          loadedfood
              .add(DietFood.fromjson(jsonDecode(response.body)['results'][i]));
        }
        setState(() {
          isFoodLoadingComplete = true;
        });
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    getFood();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 7,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: TextField(
            controller: foodController,
            //onChanged: (value) => updateList(value),
            style: const TextStyle(
                color: Color.fromARGB(255, 97, 219, 213), fontSize: 12),
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0x00000000),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                hintText: "eg: Orange",
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          nextFoodPage = widget.nextPage;

                          loadedfood = List.empty(growable: true);
                          isFoodLoadingComplete = false;
                        });
                        searchFood(foodController.text);
                      },
                    ),
                    InkWell(
                      child: const Icon(Icons.filter_alt),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => const FilterWidget());
                      },
                    ),
                  ],
                )),
          ),
        ),
        if (isFoodLoadingComplete == false)
          const CircularProgressIndicator()
        else if (isFoodLoadingComplete == true && loadedfood.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: nextFoodPage == null
                  ? loadedfood.length
                  : loadedfood.length + 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (nextFoodPage != null && index == loadedfood.length) {
                  return ElevatedButton(
                      onPressed: () {
                        getFood();
                      },
                      child: const Text('Load more'));
                } else {
                  return DietFoodItem(
                    dietFood: loadedfood[index],
                    mealId: widget.mealId,
                    mealDomain: widget.mealDomain,
                  );
                }
              },
              scrollDirection: Axis.vertical,
            ),
          )
        else
          const Center(child: Text('No Food found on Database!')),
        if (widget.category == 'CustomFood' && widget.mealDomain == 'meals')
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(40),
                          left: Radius.circular(40))),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddFoodScreen.routeName);
                },
                child: const Text('create new food',
                    style: TextStyle(color: Colors.white))),
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
