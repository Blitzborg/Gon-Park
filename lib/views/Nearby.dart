import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkapp/models/car_park.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

const APIKey = "AIzaSyA4qeP69urzl8vycuDfLg2Qpo_cRbXJ6RQ";

class Nearby extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<Nearby> {
  GoogleMapController mapController;
  Position userLocation;
  Widget _body;
  String searchAddr;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    _body = Center(child: CircularProgressIndicator());
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    Position temp = await Geolocator().getCurrentPosition();
    setState(() {
      userLocation = temp;
      _body = bodyWidget();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: Stack(
          children: <Widget>[
            _body,
            Card(
                child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              controller: _controller,
              onSubmitted: (text) async {
                searchAddr = text;
                try {
                  Geolocator().placemarkFromAddress(searchAddr).then((result) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(result: result),
                      ),
                    ).then((newLocation) {
                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(newLocation.position.latitude,
                                  newLocation.position.longitude),
                              zoom: 18)));
                    });
                  });
                } catch (e) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("No matching result found")));
                }
              },
            )),
            Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  child: Icon(Icons.location_searching),
                  onPressed: () async {
                    Geolocator().getCurrentPosition().then((currentLocation) {
                      userLocation = currentLocation;
                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(currentLocation.latitude,
                                  currentLocation.longitude),
                              zoom: 15)));
                    });
                  },
                ))
          ],
        ));
  }

  Widget bodyWidget() {
    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: 15,
      ),
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
    );
  }

  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {});
  }
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final List<Placemark> result;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Result"),
        ),
        body: ListView.builder(
          itemCount: result.length,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text(
                  this.result[position].name,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead,
                ),
                subtitle: Text(
                  this.result[position].subThoroughfare,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead,
                ),
                onTap: () {
                  Navigator.pop(context, result[position]);
                },
              ),
            );
          },
        ));
  }
}
