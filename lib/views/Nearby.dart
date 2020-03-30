import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:geolocation/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import './model/car_park.dart' ;
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class Nearby extends StatefulWidget{
   const Nearby({Key key}) : super(key: key);
   @override
  _MyAppState createState() => _MyAppState();
}

//final Map<String, Marker> _markers = {};
List<Marker> allMarkers = [];
List<CarPark> allCarParkList = [];

class _MyAppState extends State<Nearby> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(1.290270, 	103.851959);
  

  
  static void getfullcarparks() async {
    List<List<dynamic>> CSVdata = [];
    
    final String myData =
        await rootBundle.loadString("assets/hdb-carpark-information.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    //print(csvTable[0][1]);
    CSVdata = csvTable;
    //print(CSVdata);
    int i = 1;
    while (i < 2121) //note that i starts from 1 since data[0][0] is list of attributes, 2122 is the total number of car parks in database
    {
      try{
      //print(csvTable[i][0]);
      CarPark x = new CarPark(CSVdata[i][0], CSVdata[i][1], CSVdata[i][2], CSVdata[i][3]);
      allCarParkList.add(x);
      //print(csvTable[i][0]);
      }
      catch(e){
        print(e);
      }
      i++;
    }
    // CarParkManager.notify();
    // getNeededCarParkList(5.0);
 
  // final File file = new File(".../assets/hdb-carpark-information.csv");
  // Stream<List> inputStream = file.openRead();
  // inputStream
  //     .transform(utf8.decoder)       // Decode bytes to UTF-8.
  //     .transform(new LineSplitter()) // Convert stream to individualr lines.
  //     .listen((String line) {        // Process results.

  //      List row = line.split(','); // split by comma

  //       String number  = row[0];
  //       String address = row[1];
  //       double lat = row[2];
  //       double long = row[3];
       

  //       print('$number, $address, $lat, $long');
           
  //    //note that i starts from 1 since data[0][0] is list of attributes, 2122 is the total number of car parks in database
  //   {
  //     CarPark x = new CarPark(
  //       number, address,  lat,  long);
  //       allCarParkList.add(x);
  //   }
  //     },
  //     onDone: () { print('File is now closed.'); },
  //     onError: (e) { print(e.toString()); });

  //  
  }

  // static List getData() {
  //   getfullcarparks();
  //   return allCarParkList;
  // }
  

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        getfullcarparks();
        double colour;

    setState(() {
      allMarkers.clear();
      final currMarker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
      );
      for (CarPark carPark in allCarParkList) {
          colour = BitmapDescriptor.hueGreen;
        allMarkers.add(Marker(
            markerId: MarkerId(carPark.number),
            draggable: false,
            icon: BitmapDescriptor.defaultMarkerWithHue(colour),
            // onTap: () {
            //   // print(carPark.number);
            //   // SelectCarParkController.handleSelectedCarPark(carPark, context);
            // },
            position: LatLng(
                carPark.latitude,
                carPark.longitude) //LatLng(carParkList[i].latitude, carParkList[i].longitude)
        ));
      }
      allMarkers.add(currMarker);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
    mapType: MapType.hybrid,
    initialCameraPosition: CameraPosition(
      target: _center,
      zoom: 12,
    ),
    markers: Set.from(allMarkers),
),
        floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),
    );
  }
}
// markers: allMarkers.values.toSet()
>>>>>>> origin/jaswanth
