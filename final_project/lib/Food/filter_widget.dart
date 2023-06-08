import 'package:flutter/material.dart';

import '../constants.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 30,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Column(children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text(
                        'Filter',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Category',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              DropdownButtonFormField(
                value: '',
                items: const [
                  DropdownMenuItem(
                    value: '',
                    child: Text('---'),
                  ),
                  DropdownMenuItem(
                    value: 'F',
                    child: Text('Food'),
                  ),
                  DropdownMenuItem(
                    value: 'B',
                    child: Text('Beverage'),
                  ),
                  DropdownMenuItem(
                    value: 'S',
                    child: Text('Seasoning'),
                  ),
                ],
                onChanged: (String? value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Calories is less than:',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                      width: deviceSize.width * 0.5 - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                      )),
                  Text('cal',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Calories is greater than:',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                      width: deviceSize.width * 0.5 - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                      )),
                  Text('cal',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Protein is less than:',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                      width: deviceSize.width * 0.5 - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                      )),
                  Text('g',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Protein is greater than:',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                      width: deviceSize.width * 0.5 - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                      )),
                  Text('g',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Carbs is less than:',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                      width: deviceSize.width * 0.5 - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                      )),
                  Text('g',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Carbs is greater than:',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                      width: deviceSize.width * 0.5 - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                      )),
                  Text('g',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Fats is less than:',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                      width: deviceSize.width * 0.5 - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                      )),
                  Text('g',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Fats is greater than:',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                      width: deviceSize.width * 0.5 - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                      )),
                  Text('g',
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: deviceSize.width * 0.45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white),
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.white),
                      child: Text('Reset',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    ));
  }
}
