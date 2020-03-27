import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SearchPage extends StatelessWidget{
  const SearchPage({Key key}) : super(key: key);

  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  @override
  Widget build(BuildContext cntxt) {
    return Scaffold(
      body: Center(
        child: Text('Search Page'),
      ),
    );
  }
}
