import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                print("Search");
              },
            )
          ],
        ),
        body: ListView(children: <Widget>[
          Card(
              child: ExpansionTile(
            title: Text(
              'Contacts',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "To contact us:",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Text(
                      "Email: apple_plus@gmail.com",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Text(
                      "Mobile: +65 xxxx-xxxx",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          )),
          Card(
              child: ExpansionTile(
                  title: Text(
                    'About',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "This app was created by Computer Engineering students of Nanyang Technological University as a part of the Software Enginerering project.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ]))
        ]));
  }
}
