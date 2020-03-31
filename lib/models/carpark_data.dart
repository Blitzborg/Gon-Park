import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../interface/government_api_interface.dart';
import 'dart:convert';
import 'package:parkapp/models/car_park.dart';

class CarparkData {
  static List<CarPark> allCarParkList = [];

  static List<CarPark> loadcarparks() {
    getfullcarparks();
    return allCarParkList;
  }

  static void getfullcarparks() async {
    List<List<dynamic>> CSVdata = [];

    var a = await GovtDataAPI().getData();
    var govtData = json.decode(a);

    final String myData =
        await rootBundle.loadString("assets/hdb-carpark-information.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);

    int i = 1;
    while (i <
        2121) //note that i starts from 1 since data[0][0] is list of attributes, 2122 is the total number of car parks in database
    {
      try {
        CarPark x = new CarPark(
            csvTable[i][0], csvTable[i][1], csvTable[i][2], csvTable[i][3]);
        allCarParkList.add(x);
      } catch (e) {
        print(e);
      }
      i++;
    }
    var pos;
    for (pos = 1; pos < govtData["items"][0]['carpark_data'].length; pos++) {
      String number =
          govtData["items"][0]['carpark_data'][pos]['carpark_number'];
      int lotsAvailable = int.parse(govtData["items"][0]['carpark_data'][pos]
          ['carpark_info'][0]['lots_available']);
      int totalLots = int.parse(govtData["items"][0]['carpark_data'][pos]
          ['carpark_info'][0]['total_lots']);
      int index =
          allCarParkList.indexWhere((carPark) => carPark.number == number);
      if (index != -1) {
        allCarParkList[index].number = number;
        allCarParkList[index].lotsAvailable = lotsAvailable;
        allCarParkList[index].totalLots = totalLots;
        allCarParkList[index].fraction_taken =
            (totalLots - lotsAvailable) / totalLots;
      }
    }
  }
}
