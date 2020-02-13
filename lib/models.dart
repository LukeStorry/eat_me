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
  Food(this.name, this.expiry);

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
