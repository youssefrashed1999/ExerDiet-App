import 'package:flutter/material.dart';

class SelectionListTile extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isSelected;
  final String? subText;

  const SelectionListTile(
      {Key? key,
      required this.text,
      required this.onTap,
      this.isSelected = false,
      this.subText = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ListTile(
            title: Text(
              text,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.headlineMedium?.color,
                  ),
            ),
            subtitle: subText == null
                ? null
                : Text(subText!,
                    style: Theme.of(context).textTheme.headlineSmall),
            trailing: isSelected
                ? Icon(
                    Icons.check,
                    size: 32,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  )
                : Container(
                    width: 32,
                    height: 10,
                  ),
            onTap: () => onTap.call(),
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
