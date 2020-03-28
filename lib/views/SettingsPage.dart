import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('More')),
        body: ListView(children: <Widget>[
          ExpansionTile(
            title: Text(
              'Contacts',
              style: TextStyle(fontSize: 18),
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
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Email: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Mobile:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
              title: Text(
                'About',
                style: TextStyle(fontSize: 18),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "This app was created by Computer Engineering students of Nanyang Technological University as a part of the Software Enginerering project.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ])
        ]));
  }
}
