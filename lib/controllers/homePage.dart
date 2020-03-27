import 'package:flutter/material.dart';
import 'package:parkapp/views/Nearby.dart';
import 'package:parkapp/views/Bookmarks.dart';
import 'package:parkapp/views/SettingsPage.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  final List<Widget> pages = [
    Nearby(
      key: PageStorageKey('Home'),
    ),
    Bookmarks(
      key: PageStorageKey('Bookmarks'),
    ),
    SettingsPage(
      key: PageStorageKey('Settings'),
    ),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.home),
              title: Text('Home')),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.star_border),
              title: Text('Bookmarks')),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.settings),
              title: Text('Settings'))
        ],
      ),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}