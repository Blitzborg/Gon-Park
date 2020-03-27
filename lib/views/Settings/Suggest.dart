import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestPage extends StatelessWidget{
   const SuggestPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Page"),
      ),
      body: Center(
        child: Text("This app ")
      ),
    );
  }
}