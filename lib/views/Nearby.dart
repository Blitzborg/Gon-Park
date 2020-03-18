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
  static double latitude = 1.290270;
  static double longitude = 103.851959;
  //static const LatLng _center = const LatLng(1.290270, 	103.851959);
  List<Marker> markers = <Marker>[];

  static final CameraPosition _myLocation = CameraPosition(
    target: LatLng(1.290270, 103.851959),
    zoom: 12,
    bearing: 15.0,
    tilt: 75.0
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _myLocation,
          markers: Set<Marker>.of(markers),
        ),
        floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          searchNearby(latitude, longitude);
        },
        label: Text('Places Nearby'),
        icon: Icon(Icons.place),
      ),
    );
  }

void searchNearby(double latittude, double longitude) async{
 setState(() {
      markers.clear();
    }); 

  String url =
        '$baseUrl?key=$_API_KEY&location=$latitude,$longitude&radius=10000&keyword=${widget.keyword}';
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _handleResponse(data, latittude, longitude);
    } else {
      throw Exception('An error occurred getting places nearby');
    }

    // make sure to hide searching
    setState(() {
      searching = false;
    });
}

void _handleResponse(data, latittude,longitude){
    // bad api key or otherwise
      if (data['status'] == "REQUEST_DENIED") {
        setState(() {
          error = Error.fromJson(data);
        });
        // success
      } else if (data['status'] == "OK") {
        setState(() {
          places = PlaceResponse.parseResults(data['results']);
          for (int i = 0; i < places.length; i++) {
            markers.add(
              Marker(
                markerId: MarkerId(places[i].placeId),
                position: LatLng(places[i].geometry.location.lat,
                    places[i].geometry.location.long),
                infoWindow: InfoWindow(
                    title: places[i].name, snippet: places[i].vicinity),
                onTap: () {},
              ),
            );
          }
        });
      } else {
        print(data);
      }
  }


}



