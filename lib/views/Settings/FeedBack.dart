import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget{
   const FeedbackPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      body: Center(
        child: Text("For Feedback:\n\nEmail us at: abcde@e.ntu.edu.sg \n\nCall us at: +65 12345678")
      ),
    );
  }
}
