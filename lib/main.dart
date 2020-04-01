import 'package:flutter/material.dart';
import 'package:parkapp/controllers/homePage.dart';
import 'package:parkapp/models/car_park.dart';
import 'package:parkapp/utils/database_helper.dart';
import 'package:parkapp/views/Nearby.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Nearby(),
    );
  }
}
