import 'package:flutter/material.dart';

import 'models.dart';

class NewFoodDialog extends StatelessWidget {
  final nameController = new TextEditingController();

  // TODO add selected date
  final expiry = DateTime.now().add(Duration(days: 3));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
//      title: Text('New food'),
      content: SingleChildScrollView(
          child: Column(children: <Widget>[
        TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(labelText: 'Food Name'),
        )
        //, // TODO add date here
      ])),
      actions: <Widget>[
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            final newFood = new Food(nameController.value.text, expiry);

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
