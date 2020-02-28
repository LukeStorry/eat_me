import 'package:flutter/material.dart';

import 'food_list_screen.dart';
import 'user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
          body: Stack(
            children: <Widget>[FoodListScreen()],
          )),
    );
  }
}
