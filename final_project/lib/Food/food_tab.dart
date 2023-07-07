import 'dart:convert';

import 'package:final_project/Food/filter_widget.dart';
import 'package:final_project/Food/sort_widget.dart';
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
  // ignore: prefer_final_fields
  Map<String, String> _filterData = {
    'search': '',
    'category': '',
    'calories_less_than': '',
    'calories_greater_than': '',
    'protein_less_than': '',
    'protein_greater_than': '',
    'carbs_less_than': '',
    'carbs_greater_than': '',
    'fats_less_than': '',
    'fats_greater_than': '',
    'ordering': '',
  };
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

  void searchFood() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessKey = prefs.getString(ACCESS_KEY);
    String query = createSearchQuery();
    try {
      final response = await http.get(
        Uri.parse('${nextFoodPage!}?$query'),
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

  void setFilteredData(Map<String, String> data) {
    _filterData['category'] = data['category']!;
    _filterData['calories_less_than'] = data['calories_less_than']!;
    _filterData['calories_greater_than'] = data['calories_greater_than']!;
    _filterData['protein_less_than'] = data['protein_less_than']!;
    _filterData['protein_greater_than'] = data['protein_greater_than']!;
    _filterData['carbs_less_than'] = data['carbs_less_than']!;
    _filterData['carbs_greater_than'] = data['carbs_greater_than']!;
    _filterData['fats_less_than'] = data['fats_less_than']!;
    _filterData['fats_greater_than'] = data['fats_greater_than']!;
  }

  void resetFilteredData() {
    foodController.text = '';
    _filterData['category'] = '';
    _filterData['calories_less_than'] = '';
    _filterData['calories_greater_than'] = '';
    _filterData['protein_less_than'] = '';
    _filterData['protein_greater_than'] = '';
    _filterData['carbs_less_than'] = '';
    _filterData['carbs_greater_than'] = '';
    _filterData['fats_less_than'] = '';
    _filterData['fats_greater_than'] = '';
    _filterData['search'] = '';
    _filterData['ordering'] = '';
  }

  void setOrderingMethod(String value) {
    _filterData['ordering'] = value;
  }

  String createSearchQuery() {
    String query = 'category=${_filterData['category']}'
        '&calories__gte=${_filterData['calories_greater_than']}'
        '&calories__lte=${_filterData['calories_less_than']}'
        '&carbs__gte=${_filterData['carbs_greater_than']}'
        '&carbs__lte=${_filterData['carbs_less_than']}'
        '&fats__gte=${_filterData['fats_greater_than']}'
        '&fats__lte=${_filterData['fats_less_than']}'
        '&protein__gte=${_filterData['protein_greater_than']}'
        '&protein__lte=${_filterData['protein_less_than']}'
        '&search=${_filterData['search']}'
        '&ordering=${_filterData['ordering']}';
    return query;
  }

  void onSearchClicked() {
    setState(() {
      //reset nextPage
      nextFoodPage = widget.nextPage;
      loadedfood = List.empty(growable: true);
      isFoodLoadingComplete = false;
    });
    searchFood();
  }

  @override
  void initState() {
    super.initState();
    getFood();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      color: BACKGROUND_COLOR,
      width: deviceSize.width,
      height: deviceSize.height,
      child: Column(
        children: [
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: foodController,
                    textInputAction: TextInputAction.search,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _filterData['search'] = foodController.text;
                      onSearchClicked();
                    },
                    //onChanged: (value) => updateList(value),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 12),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0x00000000),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        hintText: "eg: Orange",
                        suffixIcon: InkWell(
                          child: const Icon(Icons.search),
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _filterData['search'] = foodController.text;
                            onSearchClicked();
                          },
                        )),
                  ),
                ),
              ),
              InkWell(
                child: const Icon(Icons.filter_alt),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => FilterWidget(
                            filterData: _filterData,
                            setFilteredData: setFilteredData,
                            onSearchClicked: onSearchClicked,
                            resetFilteredData: resetFilteredData,
                          ));
                },
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                child: const Icon(Icons.sort),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SortWidget(
                            selectedSortMethod: _filterData['ordering']!,
                            setOrderingMethod: setOrderingMethod,
                            onSearchClicked: onSearchClicked,
                          ));
                },
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          if (isFoodLoadingComplete == false)
            const CircularProgressIndicator()
          else if (isFoodLoadingComplete == true && loadedfood.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
