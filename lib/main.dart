import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final dummySnapshot = [
  {"name": "Filip", "votes": 15},
  {"name": "Abraham", "votes": 14},
  {"name": "Richard", "votes": 11},
  {"name": "Ike", "votes": 10},
  {"name": "Justin", "votes": 1},
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat Me',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eat Me')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('kitchens')
          .document('kitch01') // TODO kitchen selection per-user
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        final kitchen = Kitchen.fromSnapshot(snapshot);
        // TODO use kitchen name too?
        return _buildFoodList(context, kitchen.foods);
      },
    );
  }

  Widget _buildFoodList(BuildContext context, List<Food> foods) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: foods
          .map((data) => _buildFoodListItem(context, data))
          .toList(),
    );
  }

  Widget _buildFoodListItem(BuildContext context, Food food) {
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
          onTap: () => print(food), // TODO open modal
        ),
      ),
    );
  }
}

class Kitchen {
  final String name;
  final List<Food> foods;

// final DocumentReference reference; // TODO do we need to set some reference for firebase-editablility?

  Kitchen.fromSnapshot(snapshot)
      : assert(snapshot.data['name'] != null),
        name = snapshot.data['name'],
        foods = snapshot.data['foods']
            .map<Food>((data) => Food.fromSnapshot(data))
            .toList()
              ..sort((Food a, Food b) => a.expiry.compareTo(b.expiry));

  @override
  String toString() => "Kitchen<$name>";
}

class Food {
  final String name;
  final DateTime expiry;

  Food.fromSnapshot(data)
      : assert(data['name'] != null),
        name = data['name'],
        expiry = new DateTime.fromMicrosecondsSinceEpoch(
            data['expiry'].microsecondsSinceEpoch);

  @override
  String toString() => "FoodItem<$name:$expiry>";
}
