import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Settings/About.dart';
import './Settings/Contact.dart';
import './Settings/Rate.dart';
import './Settings/FeedBack.dart';
import './Settings/Suggest.dart';

class SettingsPage extends StatelessWidget{
   const SettingsPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext cntxt){
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
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

      final titles = ['FeedBack', 'Suggest a Feature','Contact Us', 'Rate Us','About this App'];
      final pagenames = ['AboutPage()'];
      final icons = [Icons.insert_comment,Icons.supervisor_account,Icons.local_phone, Icons.rate_review,Icons.info ];

      return ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card( //                           <-- Card widget
            child: ListTile(
              onTap: () {Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new AboutPage()));} ,
              leading: Icon(icons[index]),
              title: Text(titles[index]),
              trailing: Icon(Icons.keyboard_arrow_right),

            ),
          );
        },
      );
    }