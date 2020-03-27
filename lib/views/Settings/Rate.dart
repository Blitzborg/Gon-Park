import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatePage extends StatelessWidget{
   const RatePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate and Review"),
      ),
      body: Center(
        child: Text("To Rate and Review our app:\n\nEmail us at: abcde@e.ntu.edu.sg \n\nCall us at: +65 12345678")
      ),
    );
  }
}