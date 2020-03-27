<<<<<<< Updated upstream
=======
import 'dart:async';
>>>>>>> Stashed changes
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:parkapp/models/bookmark.dart';
import 'package:parkapp/utils/database_helper.dart';

<<<<<<< Updated upstream
class Bookmarks extends StatelessWidget{
  const Bookmarks({Key key}) : super(key: key);

  @override
  Widget build(BuildContext cntxt) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarked Places')),
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  final titles = ['Place 1', 'Place 2', 'Place 3', 'Place 4', 'Place 5'];

  final icons = [
    Icons.location_on,
    Icons.location_on,
    Icons.location_on,
    Icons.location_on,
    Icons.location_on
  ];

  return ListView.builder(
    itemCount: titles.length,
    itemBuilder: (context, index) {
      return Card(
        //                           <-- Card widget
        child: ListTile(
          onTap: () {
            print('tapped');
          },
          leading: Icon(icons[index]),
          title: Text(titles[index]),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      );
    },
  );
}
=======
class Bookmarks extends StatefulWidget {
  const Bookmarks({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return BookmarkListState();
  }
}

class BookmarkListState extends State<Bookmarks> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Bookmark> bookmarkList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (bookmarkList == null) {
      bookmarkList = List<Bookmark>();
      updateListView();
    }

    return Scaffold(
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          insertInit();
          updateListView();
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
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
              this.bookmarkList[position].LocationName,
              style: titleStyle,
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, bookmarkList[position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Bookmark bookmark) async {
    int result = await databaseHelper.deleteBookmark(bookmark.LocationID);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
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
      Future<List<Bookmark>> noteListFuture = databaseHelper.getBookmarkList();
      noteListFuture.then((bookmarkList) {
        setState(() {
          this.bookmarkList = bookmarkList;
          this.count = bookmarkList.length;
        });
      });
    });
  }

  void insertInit() async {
    Bookmark initBookmark =
        new Bookmark("BLK 37 CIRCUIT ROAD", "M16	", 33937.7242, 34516.7499);
    this.databaseHelper.insertBookmark(initBookmark);
  }
}
>>>>>>> Stashed changes
