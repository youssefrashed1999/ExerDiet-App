import 'package:flutter/material.dart';
import '../models/diet_food.dart';
import 'diet_food_item.dart';

class FoodOverviewScreen extends StatefulWidget {
  static const routeName = '/food';

  @override
  State<FoodOverviewScreen> createState() => _FoodOverviewScreenState();
}

class _FoodOverviewScreenState extends State<FoodOverviewScreen> {
  static List<DietFood> loadedfood = [
    DietFood(
        id: '1',
        name: 'apple',
        calories: 21,
        fats: 23,
        protein: 2,
        carbs: 0,
        imageUrl:
            'https://images.everydayhealth.com/images/apples-101-about-1440x810.jpg'),
    DietFood(
        id: '2',
        name: 'banana',
        calories: 21,
        fats: 23,
        protein: 2,
        carbs: 0,
        imageUrl:
            'https://www.pureearete.com/wp-content/uploads/2020/06/banana_m.jpg'),
    DietFood(
        id: '3',
        name: 'orange',
        calories: 21,
        fats: 23,
        protein: 2,
        carbs: 0,
        imageUrl:
            'https://www.pittmandavis.com/images/xl/buy-navel-oranges-bo.jpg?v=1'),
    DietFood(
        id: '4',
        name: 'rice',
        calories: 23,
        fats: 22,
        protein: 0,
        carbs: 23,
        imageUrl:
            'https://www.budgetbytes.com/wp-content/uploads/2022/04/How-to-Cook-Rice-bowl.jpg'),
    DietFood(
        id: '5',
        name: 'pasta',
        calories: 23,
        fats: 33,
        protein: 0,
        carbs: 33,
        imageUrl:
            'https://thedizzycook.com/wp-content/uploads/2019/12/Boursin-pasta-500x500.jpg')
  ];
  bool is_food_clicked = true;
  List<DietFood> displayloadedfood = List.from(loadedfood);
  void updateList(String value) {
    setState(() {
      displayloadedfood = loadedfood
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
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
              onChanged: (value) => updateList(value),
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: displayloadedfood.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => DietFoodItem(
                id: loadedfood[index].id,
                name: loadedfood[index].name,
                imageUrl: loadedfood[index].imageUrl,
                calories: loadedfood[index].calories,
                fats: loadedfood[index].fats,
                protein: loadedfood[index].protein,
                carbs: loadedfood[index].carbs,
              ),
              scrollDirection: Axis.vertical,
            ),
          ),
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
