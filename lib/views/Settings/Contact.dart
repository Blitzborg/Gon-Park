import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: Center(
        child: Text("To contact us:\n\nEmail us at: abcde@e.ntu.edu.sg \n\nCall us at: +65 12345678"),   
      ),
    );
  }
}