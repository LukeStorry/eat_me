import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'food_list_screen.dart';
import 'user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Widget splash = Column(
    children: [
      Container(
          constraints: BoxConstraints.expand(height: 200.0),
          padding: const EdgeInsets.all(50.0),
          child: Image.asset(
            'assets/icon_big.png',
            fit: BoxFit.scaleDown,
            width: 30,
          )),
      Center(child: Text("Please sign in! :)"))
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat Me',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Eat Me'),
            actions: <Widget>[UserIcon()],
          ),
          body: StreamBuilder<FirebaseUser>(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (context, snapshot) {
                return (snapshot.connectionState != ConnectionState.active)
                    ? LinearProgressIndicator()
                    : (snapshot.data == null) ? splash : FoodListScreen();
              })),
    );
  }
}
