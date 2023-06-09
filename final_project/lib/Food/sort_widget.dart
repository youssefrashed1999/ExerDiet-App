import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SortWidget extends StatefulWidget {
  String selectedSortMethod;
  final Function(String) setOrderingMethod;
  final Function() onSearchClicked;
  SortWidget(
      {super.key,
      required this.selectedSortMethod,
      required this.onSearchClicked,
      required this.setOrderingMethod});

  @override
  State<SortWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  void onMethodChanged(String value) {
    setState(() {
      widget.selectedSortMethod = value;
    });
    widget.setOrderingMethod(widget.selectedSortMethod);
    Navigator.of(context).pop();
    widget.onSearchClicked();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
            RadioListTile(
              value: '',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Default'),
            ),
            RadioListTile(
              value: '-calories',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Calories : High to Low'),
            ),
            RadioListTile(
              value: 'calories',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Calories : Low to High'),
            ),
            RadioListTile(
              value: '-protein',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Protein : High to Low'),
            ),
            RadioListTile(
              value: 'protein',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Protein : Low to High'),
            ),
            RadioListTile(
              value: '-carbs',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Carbs : High to Low'),
            ),
            RadioListTile(
              value: 'carbs',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Carbs : Low to High'),
            ),
            RadioListTile(
              value: '-fats',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Fats : High to Low'),
            ),
            RadioListTile(
              value: 'fats',
              groupValue: widget.selectedSortMethod,
              onChanged: (value) => onMethodChanged(value!),
              title: const Text('Fats : Low to High'),
            )
          ],
        ),
      ),
    );
  }
}
