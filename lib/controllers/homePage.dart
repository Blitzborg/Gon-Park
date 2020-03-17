import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          })
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have clicked the button this many times:',
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.display1,
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
       currentIndex: 0, // this will be set when a new tab is tapped
       
       items: [
         BottomNavigationBarItem(
           backgroundColor: Colors.black54,
           icon: new Icon(Icons.location_searching),
           title: new Text('Nearby')
         ),
         BottomNavigationBarItem(
           backgroundColor: Colors.black54,
           icon: new Icon(Icons.search),
           title: new Text('Search')
         ),
         
         BottomNavigationBarItem(
           backgroundColor: Colors.black54,
           icon: Icon(Icons.star_border),
           title: Text('Bookmarks')
         ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black54,
           icon: Icon(Icons.settings),
           title: Text('Settings')
           
         )
       ],
     ),
    );
  }
}


class DataSearch extends SearchDelegate<String>{

  final  places = ['jurong east',
  'buano vista',
  'boon lay'];
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed:(){
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