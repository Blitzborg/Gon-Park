import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkapp/models/car_park.dart';
import 'package:sqflite/sqflite.dart';
import 'package:parkapp/utils/database_helper.dart';

import 'package:parkapp/controllers/homePage.dart';

class Bookmarks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BookmarkListState();
  }
}

class BookmarkListState extends State<Bookmarks> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<CarPark> carparkList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (carparkList == null) {
      carparkList = List<CarPark>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: getNoteListView(),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          //print(this.carparkList.length);
          insertInit();
          updateListView();
        },
      ),*/
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text(
                this.carparkList[position].address,
                style: titleStyle,
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  _delete(context, carparkList[position]);
                },
              ),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              }),
        );
      },
    );
  }

  void _delete(BuildContext context, CarPark carpark) async {
    int result = await databaseHelper.deleteCarpark(carpark.number);
    if (result != 0) {
      _showSnackBar(context, 'Bookmark Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<CarPark>> noteListFuture = databaseHelper.getCarparkList();
      noteListFuture.then((carparkList) {
        setState(() {
          this.carparkList = carparkList;
          this.count = carparkList.length;
        });
      });
    });
  }

  void insertInit() async {
    CarPark initCarpark = CarPark("BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK",
        "ACB", 1.301063272, 103.854118);
    this.databaseHelper.insertCarpark(initCarpark);
  }
}
