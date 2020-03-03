import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Kitchen {
  final String name;
  final List<Food> foods;
  final DocumentReference ref;

  Kitchen.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot.data != null),
        assert(snapshot.data['name'] != null),
        name = snapshot.data['name'],
        foods = snapshot.data['foods']
            .map<Food>((data) => Food.fromSnapshot(data))
            .toList()
              ..sort(),
        ref = snapshot.reference;

  @override
  String toString() => "Kitchen<${ref.documentID}:'$name':${foods.length}>";

  void addFood(Food newFood) {
    foods.add(newFood);
    foods.sort();

    Firestore.instance.runTransaction((transaction) async {
      final latest = Kitchen.fromSnapshot(await transaction.get(ref));
      latest.foods.add(newFood);
      var newFoodsList = latest.foods.map((Food f) => f.toSnapshot()).toList();
      transaction.update(ref, {'foods': newFoodsList});
    });
  }

  void editFood(Food newFood) {
    foods.sort();

    Firestore.instance.runTransaction((transaction) async {
      final latest = Kitchen.fromSnapshot(await transaction.get(ref));
      latest.foods.removeWhere((food) => food.id == newFood.id);
      latest.foods.add(newFood);
      var newFoodsList = latest.foods.map((Food f) => f.toSnapshot()).toList();
      transaction.update(ref, {'foods': newFoodsList});
    });
  }

  void deleteFood(Food foodToDelete) {
    print("Deleting ${foodToDelete.name}");
    foods.removeWhere((food) => food.id == foodToDelete.id);

    Firestore.instance.runTransaction((transaction) async {
      final latest = Kitchen.fromSnapshot(await transaction.get(ref));
      latest.foods.removeWhere((food) => food.id == foodToDelete.id);
      var newFoodsList = latest.foods.map((Food f) => f.toSnapshot()).toList();
      transaction.update(ref, {'foods': newFoodsList});
    });
  }
}

class Food implements Comparable {
  String name;
  DateTime expiry;
  final String id;

  Food() : id = UniqueKey().toString();

  Food.fromSnapshot(dynamic data)
      : assert(data['name'] != null),
        name = data['name'],
        expiry = new DateTime.fromMicrosecondsSinceEpoch(
            data['expiry'].microsecondsSinceEpoch),
        id = data['id'];

  dynamic toSnapshot() =>
      {'name': name, 'expiry': Timestamp.fromDate(expiry), 'id': id};

  @override
  String toString() => "FoodItem<$name:$expiry:$id>";

  @override
  int compareTo(other) => this.expiry.compareTo(other.expiry);
}

typedef EditFoodCallback = void Function(Food);
typedef DeleteFoodCallback = void Function(Food);
