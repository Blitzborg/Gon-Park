import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:parkapp/models/car_park.dart';
import 'package:parkapp/models/carpark_data.dart';
import 'package:parkapp/main.dart';
import 'package:parkapp/utils/database_helper.dart';

const APIKey = "AIzaSyDpNphqq_FzaHNKvm6u3Z2B_QIgUQG0oZQ";

class Nearby extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<Nearby> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: APIKey);
  Completer<GoogleMapController> _controllermap = Completer();
  GoogleMapController mapController;
  static List<CarPark> allCarParkList = [];
  static List<Marker> allMarkers = [];
  List<CarPark> bookmarkedCarparks;
  Position userLocation;
  Widget _body;
  String searchAddr;
  final double _zoom = 16;

  @override
  void initState() {
    if (bookmarkedCarparks == null) {
      bookmarkedCarparks = new List<CarPark>();
      //updateCarparkList();
    }
    _body = Center(child: CircularProgressIndicator());
    allCarParkList = CarparkData.loadcarparks();
    getCurrentLocation();
    super.initState();
  }

  /*void _onMapCreated(GoogleMapController controller) {
    _controllermap.complete(controller);
  }*/

  void getCurrentLocation() async {
    Position currentLocation = await Geolocator().getCurrentPosition();
    double colour;
    setState(() {
      allMarkers.clear();
      final currMarker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
        onTap: () {
          zoomIn(currentLocation.latitude, currentLocation.longitude);
        },
      );
      int i = 0;
      for (CarPark carPark in allCarParkList) {
        print(carPark.number);
        if (carPark.fraction_taken < 0.6) {
          colour = BitmapDescriptor.hueGreen;
        } else if (carPark.fraction_taken >= 0.6 &&
            carPark.fraction_taken <= 0.9) {
          colour = BitmapDescriptor.hueOrange;
        } else {
          colour = BitmapDescriptor.hueRed;
        }
        if (carPark.totalLots != 0) {
          //print(carPark.lotsAvailable);
          allMarkers.add(Marker(
              markerId: MarkerId(carPark.number),
              draggable: false,
              infoWindow: InfoWindow(
                  title: carPark.number,
                  snippet:
                      'Available Slots: ${carPark.lotsAvailable} Total Lots: ${carPark.totalLots}',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text("Add to bookmark?"),
                            children: <Widget>[
                              SimpleDialogOption(
                                child: Text("OK"),
                                onPressed: () {
                                  bookmarkedCarparks.add(carPark);
                                  databaseHelper.insertCarpark(carPark);
                                  Navigator.of(context).pop();
                                },
                              ),
                              SimpleDialogOption(
                                child: Text("CANCEL"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }),
              icon: BitmapDescriptor.defaultMarkerWithHue(colour),
              onTap: () {
                print(carPark.number);
                zoomIn(carPark.latitude, carPark.longitude);
              },
              position: LatLng(
                  carPark.latitude,
                  carPark
                      .longitude) //LatLng(carParkList[i].latitude, carParkList[i].longitude)
              ));
        }
      }
      // print(i);
      allMarkers.add(currMarker);
      userLocation = currentLocation;
      _body = bodyWidget();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  Prediction p = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: APIKey,
                      mode: Mode.overlay,
                      // Mode.fullscreen
                      language: "en",
                      components: [new Component(Component.country, "sg")]);
                  PlacesDetailsResponse place = await _places
                      .getDetailsByPlaceId(p.placeId);
                  zoomIn(place.result.geometry.location.lat,
                      place.result.geometry.location.lng);
                  // mapController.moveCamera(
                  //     CameraUpdate.newCameraPosition(CameraPosition(
                  //         target: LatLng(place.result.geometry.location.lat,
                  //             place.result.geometry.location.lng),
                  //         zoom: 15)));
                },
              )
            ]),
        body: Stack(
          children: <Widget>[
            _body,
            /*Card(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (text) async {
                    searchAddr = text;
                    //searchAndNavigate();
                    Geolocator().placemarkFromAddress(searchAddr).then((result) {
                      for(Placemark place in result){
                        print(place.name.toString());
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => DetailScreen(result: result))).then((returnValue){
                            mapController.moveCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(returnValue.position.latitude,returnValue.position.longitude),
                                  zoom: 17
                                )));
                            print(returnValue.position.toString());
                      });
                    });
                   // Geolocator().placemarkFromAddress(searchAddr).then((result) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(result: result),
                        ),
                      ).then((newLocation) {
                        userLocation = newLocation.position;
                      });
                      mapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(userLocation.latitude,
                                  userLocation.longitude),
                              zoom: 15)));
                    });//
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
                ))*/
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
      markers: Set.from(allMarkers),
    );
  }


  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((newLocation) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(newLocation[0].position.latitude,
              newLocation[0].position.longitude),
          zoom: 15)));
    });
  }


  Future<void> zoomIn(double lat, double long) async {
    GoogleMapController controller = await _controllermap.future;
    controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));
  }
}

class DetailScreen extends StatelessWidget {
  final List<Placemark> result;

  DetailScreen({Key key, @required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      .title,
                ),
                subtitle: Text(
                  this.result[position].thoroughfare,
                  style: Theme
                      .of(context)
                      .textTheme
                      .body2,
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