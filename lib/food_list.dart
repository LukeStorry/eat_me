import 'package:flutter/material.dart';

import 'models.dart';

class FoodList extends StatelessWidget {
  FoodList(this.kitchen, this.onFoodClick);

  final Kitchen kitchen;
  final EditFoodCallback onFoodClick;

  @override
  Widget build(BuildContext context) {
    // TODO use kitchen name too?
    return ListView(
      children: kitchen.foods.map((data) => foodListItem(data)).toList(),
      padding: const EdgeInsets.only(top: 20.0),
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget foodListItem(Food food) {
    final daysUntilExpiry = food.expiry.difference(DateTime.now()).inDays;

    final daysUntilExpiryString = daysUntilExpiry.toString() +
        " day" +
        (daysUntilExpiry.abs() > 1 ? "s" : "");

    final expiryWarningColor = daysUntilExpiry < 1
        ? Colors.red
        : daysUntilExpiry <= 2 ? Colors.amber : Colors.grey;

    return Padding(
        key: ValueKey(food.name),
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: expiryWarningColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(food.name),
            trailing: Text(daysUntilExpiryString),
            onTap: () => onFoodClick(food),
          ),
        ));
  }
}
