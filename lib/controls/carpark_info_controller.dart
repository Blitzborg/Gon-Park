import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:parkapp/models/carpark.dart';

class CarparkInfoController {
  static List<Carpark> allCarParkList = [];

  static List<Carpark> loadcarparks() {
    getfullcarparks();
    return allCarParkList;
  }

  static void getfullcarparks() async {
    var response = await http.get(
        Uri.encodeFull(
            "https://api.data.gov.sg/v1/transport/carpark-availability"),
        headers: {"Accept": "application/json"});
    var rawData = response.body;
    var govtData = json.decode(rawData);
    final String existingData =
        await rootBundle.loadString("assets/hdb-carpark-information.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(existingData);

    int i = 1;
    while (i < 2121) {
      //note that i starts from 1 since data[0][0] is list of attributes
      //2122 is the total number of car parks in database
      try {
        Carpark x = new Carpark(
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