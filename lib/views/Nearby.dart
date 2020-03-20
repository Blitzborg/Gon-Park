
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Nearby extends StatelessWidget{
   const Nearby({Key key}) : super(key: key);
<<<<<<< HEAD
=======
   @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<Nearby> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(1.290270, 	103.851959);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

>>>>>>> parent of cd69335... with map-2
  @override
  Widget build(BuildContext cntxt){
    return Scaffold(
<<<<<<< HEAD

      body: Center(
          child: Text('Nearby Locations Page'),
        ),
    );
  }

=======
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      );
  }
>>>>>>> parent of cd69335... with map-2
}
