import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Nearby extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<Nearby> {
  GoogleMapController _controller;
  Position userLocation;
  Widget _body;

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
      _body = mapWidget();
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
        body: _body);
  }

  Widget mapWidget() {
    return GoogleMap(
      markers: _createMarker(),
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: 18,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("CurrentPosition"),
        position: LatLng(userLocation.latitude, userLocation.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'WTF!!!!!!'),
      )
    ].toSet();
  }
}
