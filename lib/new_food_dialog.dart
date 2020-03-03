import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models.dart';

class FoodDialog extends StatelessWidget {
  static final dateFormat = DateFormat("yyyy-MM-dd");
  final TextEditingController nameController;
  final TextEditingController expiryController;
  final Food food;
  final DeleteFoodCallback deleteFoodCallback;

  FoodDialog.asNew()
      : food = Food(),
        deleteFoodCallback = null,
        nameController = new TextEditingController(),
        expiryController = new TextEditingController();

  FoodDialog.asEdit(this.food, this.deleteFoodCallback)
      : nameController = new TextEditingController(text: food.name),
        expiryController =
            new TextEditingController(text: dateFormat.format(food.expiry));

  @override
  Widget build(BuildContext context) {
    Widget form = SingleChildScrollView(
        child: Column(children: <Widget>[
      TextField(
        decoration: InputDecoration(labelText: 'Food Name'),
        autofocus: deleteFoodCallback == null,
        controller: nameController,
      ),
      DateTimeField(
        decoration: InputDecoration(labelText: 'Expiry Date'),
        controller: expiryController,
        format: dateFormat,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
        },
      ),
    ]));

    var buttons = <Widget>[
      FlatButton(
        child: Text('Save'),
        onPressed: () {
          // TODO validation
          food.name = nameController.value.text;
          food.expiry = DateTime.parse(expiryController.value.text);
          return Navigator.of(context).pop(food);
        },
      ),
      FlatButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];

    if (deleteFoodCallback != null)
      buttons.insert(
          0,
          FlatButton(
              child: Text('Delete'),
              onPressed: () {
                deleteFoodCallback(food);
                Navigator.of(context).pop();
              }));

    return AlertDialog(
      content: form,
      actions: buttons,
    );
  }
}
