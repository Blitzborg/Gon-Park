import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Nearby extends StatefulWidget{
   const Nearby({Key key}) : super(key: key);
   @override
  _MyAppState createState() => _MyAppState();

}


class _MyAppState extends State<Nearby> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(1.290270, 	103.851959);


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,),
        ),
    );
  }
}
