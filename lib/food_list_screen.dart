import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatme/food_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models.dart';
import 'new_food_dialog.dart';

class FoodListScreen extends StatefulWidget {
  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  Kitchen kitchen;
  final Firestore _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchKitchenOrCreateNew();
  }

  _fetchKitchenOrCreateNew() async {
    var userUid = await _auth.currentUser().then((user) => user.uid);
    print(userUid);
    var kitchenQuery = _db
        .collection('kitchens')
        .where("owners", arrayContains: userUid)
        .limit(1);

    var kitchenSnapshot = await kitchenQuery.getDocuments();
    if (kitchenSnapshot.documents.isNotEmpty) {
      kitchen = Kitchen.fromSnapshot(kitchenSnapshot.documents.first);
    } else {
      //TODO add new kitchen
      print("### NO KITCHENS FOR USER ####");
    }
    print(kitchen);
    setState(() {});
  }

  _editFood(Food oldFood) async {
    final editedFood = await showDialog<Food>(
      context: context,
      builder: (BuildContext context) {
        return FoodDialog.asEdit(oldFood, (food) => kitchen.deleteFood(food));
      },
    );

    if (editedFood != null) kitchen.editFood(editedFood);

    setState(() {});
  }

  _addFood() async {
    final newFood = await showDialog<Food>(
      context: context,
      builder: (BuildContext context) {
        return FoodDialog.asNew();
      },
    );

    if (newFood != null) {
      kitchen.addFood(newFood);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (kitchen == null)
          ? LinearProgressIndicator()
          : FoodList(kitchen, _editFood),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addFood,
      ),
    );
  }
}
