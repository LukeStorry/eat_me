import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'food_list.dart';
import 'models.dart';
import 'new_food_dialog.dart';

class FoodListScreen extends StatefulWidget {
  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  // TODO kitchen selection per-user
  final Stream<DocumentSnapshot> kitchenStream =
      Firestore.instance.collection('kitchens').document('kitch01').snapshots();

  _editFood(Food food) {
    print(food);
  }

  _addFood() async {
    final food = await showDialog<Food>(
      context: context,
      builder: (BuildContext context) {
        return NewFoodDialog();
      },
    );

    print(food);

    if (food != null) {
      // TODO send to firebase
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eat Me')),
      body: FoodList(kitchenStream, _editFood),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addFood,
      ),
    );
  }
}
