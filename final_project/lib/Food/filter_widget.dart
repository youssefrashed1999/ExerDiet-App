import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  //used only to fill inital values of the textfields
  final Map<String, String> filterData;
  final Function(Map<String, String>) setFilteredData;
  final Function() resetFilteredData;
  final Function() onSearchClicked;
  const FilterWidget(
      {super.key,
      required this.filterData,
      required this.setFilteredData,
      required this.onSearchClicked,
      required this.resetFilteredData});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  //to save user's choices of filtered data
  // ignore: prefer_final_fields
  Map<String, String> _filterData = {
    'category': '',
    'calories_less_than': '',
    'calories_greater_than': '',
    'protein_less_than': '',
    'protein_greater_than': '',
    'carbs_less_than': '',
    'carbs_greater_than': '',
    'fats_less_than': '',
    'fats_greater_than': '',
  };
  //submit form
  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    widget.setFilteredData(_filterData);
    Navigator.of(context).pop();
    widget.onSearchClicked();
  }

  //reset function
  void _reset() {
    FocusManager.instance.primaryFocus?.unfocus();
    widget.resetFilteredData();
    Navigator.of(context).pop();
    widget.onSearchClicked();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Container(
          color: BACKGROUND_COLOR,
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
                value: widget.filterData['category'],
                items: const [
                  DropdownMenuItem(
                    value: '',
                    child: Text('Any'),
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
                onSaved: (newValue) => _filterData['category'] = newValue!,
                onChanged: (String? value) {
                  _filterData['category'] = value!;
                },
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
                        initialValue: widget.filterData['calories_less_than'],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isNotEmpty && int.parse(value) < 0) {
                            return 'Calories can\'t be less than 0!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue!.isEmpty) {
                            _filterData['calories_less_than'] = '';
                          } else {
                            _filterData['calories_less_than'] = newValue;
                          }
                        },
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
                        initialValue:
                            widget.filterData['calories_greater_than'],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isNotEmpty && int.parse(value) < 0) {
                            return 'Calories can\'t be less than 0!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue!.isEmpty) {
                            _filterData['calories_greater_than'] = '';
                          } else {
                            _filterData['calories_greater_than'] = newValue;
                          }
                        },
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
                        initialValue: widget.filterData['protein_less_than'],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isNotEmpty && double.parse(value) < 0) {
                            return 'Protein can\'t be less than 0!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue!.isEmpty) {
                            _filterData['protein_less_than'] = '';
                          } else {
                            _filterData['protein_less_than'] = newValue;
                          }
                        },
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
                        initialValue: widget.filterData['protein_greater_than'],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isNotEmpty && double.parse(value) < 0) {
                            return 'Protein can\'t be less than 0!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue!.isEmpty) {
                            _filterData['protein_greater_than'] = '';
                          } else {
                            _filterData['protein_greater_than'] = newValue;
                          }
                        },
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
                        initialValue: widget.filterData['carbs_less_than'],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isNotEmpty && double.parse(value) < 0) {
                            return 'Carbs can\'t be less than 0!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue!.isEmpty) {
                            _filterData['carbs_less_than'] = '';
                          } else {
                            _filterData['carbs_less_than'] = newValue;
                          }
                        },
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
                        initialValue: widget.filterData['carbs_greater_than'],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isNotEmpty && double.parse(value) < 0) {
                            return 'Carbs can\'t be less than 0!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue!.isEmpty) {
                            _filterData['carbs_greater_than'] = '';
                          } else {
                            _filterData['carbs_greater_than'] = newValue;
                          }
                        },
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
                        initialValue: widget.filterData['fats_less_than'],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isNotEmpty && double.parse(value) < 0) {
                            return 'Fats can\'t be less than 0!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue!.isEmpty) {
                            _filterData['fats_less_than'] = '';
                          } else {
                            _filterData['fats_less_than'] = newValue;
                          }
                        },
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
                        initialValue: widget.filterData['fats_greater_than'],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isNotEmpty && double.parse(value) < 0) {
                            return 'Fats can\'t be less than 0!';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue!.isEmpty) {
                            _filterData['fats_greater_than'] = '';
                          } else {
                            _filterData['fats_greater_than'] = newValue;
                          }
                        },
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
                      onPressed: () => _submit(),
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
                      onPressed: () => _reset(),
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
