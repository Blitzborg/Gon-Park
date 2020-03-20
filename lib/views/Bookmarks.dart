
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BodyLayout extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return _myListView(context);
      }
    }
    Widget _myListView(BuildContext context) {

      final titles = ['Place 1', 'Place 2','Place 3', 'Place 4','Place 5'];

      final icons = [Icons.location_on,Icons.location_on,Icons.location_on,Icons.location_on,Icons.location_on];

      return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card( //                           <-- Card widget
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

