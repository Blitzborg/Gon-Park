import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Nearby extends StatefulWidget {
  const Nearby({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

final Map<String, Marker> _markers = {};

class _MyAppState extends State<Nearby> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapcontroller;
  static const LatLng _center = const LatLng(1.290270, 103.851959);

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
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getLocation();
        },
        tooltip: 'Get Location',
        child: Icon(Icons.location_searching),
      ),
    );
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(currentLocation.toString());

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
    });
  }
}
