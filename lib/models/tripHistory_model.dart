import 'package:firebase_database/firebase_database.dart';

class TripHistoryModel {
  String? time;
  String? destinationAddress;
  String? originAddress;
  String? fareAmount;
  String? status;
  String? bus_details;
  String? driverName;

  TripHistoryModel(
      {this.time,
      this.destinationAddress,
      this.originAddress,
      this.fareAmount,
      this.status,
      this.bus_details,
      this.driverName});

  TripHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    time = (dataSnapshot.value as Map)["time"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    status = (dataSnapshot.value as Map)["status"];
    bus_details = (dataSnapshot.value as Map)["bus_details"];
    driverName = (dataSnapshot.value as Map)["driverName"];
  }
}
