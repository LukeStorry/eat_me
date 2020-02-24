import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models.dart';

class NewFoodDialog extends StatelessWidget {
  final nameController = new TextEditingController();
  final expiryController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
          child: Column(children: <Widget>[
        TextField(
          decoration: InputDecoration(labelText: 'Food Name'),
          autofocus: true,
          controller: nameController,
        ),
        DateTimeField(
          decoration: InputDecoration(labelText: 'Expiry Date'),
          controller: expiryController,
          format: DateFormat("yyyy-MM-dd"),
          onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100),
            );
          },
        ),
      ])),
      actions: <Widget>[
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            final newFood = new Food(nameController.value.text,
                DateTime.parse(expiryController.value.text));
            return Navigator.of(context).pop(newFood);
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
