import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Nearby extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

final Map<String, Marker> _markers = {};

class MyAppState extends State<Nearby> {
  GoogleMapController mapController;
  Position userLocation;
  Geolocator geolocator = Geolocator();

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              print("Search");
            },
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(1.3521, 103.8198),
          zoom: 11.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userLocation == null
              ? CircularProgressIndicator()
              : mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target:
                          LatLng(userLocation.latitude, userLocation.longitude),
                      zoom: 15.0),
                ));
        },
        tooltip: 'Get Location',
        child: Icon(Icons.location_searching),
      ),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
