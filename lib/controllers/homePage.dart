import 'package:flutter/material.dart';
import 'package:parkapp/views/Nearby.dart';
import 'package:parkapp/views/Bookmarks.dart';
import 'package:parkapp/views/SearchPage.dart';
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
      key: PageStorageKey('Nearby'),
    ),
    SearchPage(
      key: PageStorageKey('Search'),
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

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Colors.black54,
              icon: Icon(Icons.location_searching),
              title: Text('Nearby')),
          BottomNavigationBarItem(
              backgroundColor: Colors.black54,
              icon: Icon(Icons.search),
              title: Text('Search')),
          BottomNavigationBarItem(
              backgroundColor: Colors.black54,
              icon: Icon(Icons.star_border),
              title: Text('Bookmarks')),
          BottomNavigationBarItem(
              backgroundColor: Colors.black54,
              icon: Icon(Icons.settings),
              title: Text('Settings'))
        ],
      );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}

class Search {}

class DataSearch extends SearchDelegate<String> {
  final places = ['jurong east', 'buano vista', 'boon lay'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    final suggestionsList = query.isEmpty?places:places.where((p)=> p.startsWith(query)).toList();

    return ListView.builder(itemBuilder: (context, index) =>
        ListTile(
          leading: Icon(Icons.location_city),
          title: Text(suggestionsList[index]),
        ),
      itemCount: suggestionsList.length,
    );
  }

}