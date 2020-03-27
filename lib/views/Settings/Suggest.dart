import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestPage extends StatelessWidget{
   const SuggestPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suggestions"),
      ),
      body: Center(
        child: Text("To suggest a feature:\n\nEmail us at: abcde@e.ntu.edu.sg \n\nCall us at: +65 12345678")
      ),
    );
  }
}