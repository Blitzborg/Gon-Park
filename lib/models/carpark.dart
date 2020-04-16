class Carpark {
  String number, address;
  int lotsAvailable, totalLots;
  double fraction_taken, distance, latitude, longitude;

  Carpark(String number, String address, double lat, double long) {
    this.number = number;
    this.address = address;
    this.lotsAvailable = 0; //api
    this.totalLots = 1; //api
    this.fraction_taken = (totalLots - lotsAvailable) / totalLots; //calc
    this.distance = 0.0; //calc
    this.latitude = lat;
    this.longitude = long;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['address'] = address;
    map['ID'] = number;
    map['lat'] = latitude;
    map['lng'] = longitude;

    return map;
  }

  Carpark.fromMapObject(Map<String, dynamic> map) {
    this.number = map['ID'];
    this.address = map['address'];
    this.lotsAvailable = 0; //api
    this.totalLots = 1; //api
    this.fraction_taken = (totalLots - lotsAvailable) / totalLots; //calc
    this.distance = 0.0; //calc
    this.latitude = map['lat'];
    this.longitude = map['lng'];
  }
}
