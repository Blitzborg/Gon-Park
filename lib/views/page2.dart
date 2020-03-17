import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget{
   const SecondPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext cntxt){
    return Scaffold(
      body: Center(
          child: Text('Hello World'),
        ),
    );
  }

}