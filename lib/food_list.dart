import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models.dart';

typedef EditFoodCallback = void Function(Food);

class FoodList extends StatelessWidget {
  FoodList(this.kitchenStream, this.onFoodClick);

  final Stream<DocumentSnapshot> kitchenStream;
  final EditFoodCallback onFoodClick;

  Widget _buildItem(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (!snapshot.hasData)
      return LinearProgressIndicator(); // TODO what if new user, want to make new

    final kitchen = Kitchen.fromSnapshot(snapshot);

    // TODO use kitchen name too?
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: kitchen.foods.map((data) => foodListItem(data)).toList(),
    );
  }

  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: kitchenStream,
      builder: _buildItem,
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
      ),
    );
  }
}
