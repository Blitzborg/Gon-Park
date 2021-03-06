import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:parkapp/models/carpark.dart';
import 'package:parkapp/controls/carpark_info_controller.dart';
import 'package:parkapp/controls/bookmark_controller.dart';
import 'package:parkapp/views/setting.dart';
import 'package:sqflite/sqflite.dart';

const APIKey = "AIzaSyDpNphqq_FzaHNKvm6u3Z2B_QIgUQG0oZQ";

class HomePage extends StatefulWidget {
  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<HomePage> {
  BookmarkController _databaseHelper = BookmarkController();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: APIKey);
  GoogleMapController _mapController;
  static List<Carpark> allCarParkList = [];
  static List<Marker> allMarkers = [];
  List<Carpark> bookmarkedCarparks;
  Position _userLocation;
  Widget _body;
  int count = 0;

  @override
  void initState() {
    if (bookmarkedCarparks == null) {
      bookmarkedCarparks = new List<Carpark>();
      _updateListView();
    }
    _body = Center(child: CircularProgressIndicator());
    allCarParkList = CarparkInfoController.loadcarparks();
    _showCurrentLocation();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Go & Park"), actions: <Widget>[
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
            PlacesDetailsResponse place =
                await _places.getDetailsByPlaceId(p.placeId);
            _mapController.moveCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(place.result.geometry.location.lat,
                        place.result.geometry.location.lng),
                    zoom: 15)));
          },
        ),
      ]),
      body: Stack(
        children: <Widget>[
          _body,
        ],
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        Container(
            height: 100.0,
            child: DrawerHeader(
                child: Text(
              'Settings',
              style: Theme.of(context).textTheme.title,
            ))),
        ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'View settings',
              style: Theme.of(context).textTheme.subhead,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            }),
        Container(
            height: 100.0,
            child: DrawerHeader(
                child: Text(
              'Bookmarks',
              style: Theme.of(context).textTheme.title,
            ))),
        Container(
          height: double.maxFinite,
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int position) {
              return ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(
                    this.bookmarkedCarparks[position].address,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  trailing: GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      _deleteItem(context, bookmarkedCarparks[position]);
                    },
                  ),
                  onTap: () {
                    _mapController.moveCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(
                                bookmarkedCarparks[position].latitude,
                                bookmarkedCarparks[position].longitude),
                            zoom: 18)));
                    Navigator.pop(context, bookmarkedCarparks[position]);
                  });
            },
          ),
        )
      ])),
    );
  }

  void _showCurrentLocation() async {
    Position currentLocation = await Geolocator().getCurrentPosition();
    double colour;
    setState(() {
      allMarkers.clear();
      final currMarker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
        onTap: () {
          _mapController.moveCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(
                      currentLocation.latitude, currentLocation.longitude),
                  zoom: 15)));
        },
      );
      for (Carpark carPark in allCarParkList) {
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
                                  _databaseHelper.insertCarpark(carPark);
                                  _updateListView();
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
                _mapController.moveCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(carPark.latitude,
                            carPark.longitude),
                        zoom: 15)));
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
      _userLocation = currentLocation;
      _body = GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(_userLocation.latitude, _userLocation.longitude),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: Set.from(allMarkers),
      );
    });
  }

  void _deleteItem(BuildContext context, Carpark carpark) async {
    int result = await _databaseHelper.deleteCarpark(carpark.number);
    if (result != 0) {
      _showSnackBar(context, 'Bookmark Deleted Successfully');
      _updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Carpark>> noteListFuture = _databaseHelper.getCarparkList();
      noteListFuture.then((carparkList) {
        setState(() {
          this.bookmarkedCarparks = carparkList;
          this.count = carparkList.length;
        });
      });
    });
  }
}