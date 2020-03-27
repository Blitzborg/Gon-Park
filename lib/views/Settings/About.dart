import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget{
   const AboutPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext cntxt){
    return Scaffold(
      body: Center(
          child: Text('About the App'),
        ),
    );
  }

}
