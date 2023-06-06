import 'dart:math';

import 'package:bus_client_app/assistants/assistents_methods.dart';
import 'package:bus_client_app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  _SelectNearestActiveDriversScreen createState() =>
      _SelectNearestActiveDriversScreen();
}

class _SelectNearestActiveDriversScreen
    extends State<SelectNearestActiveDriversScreen> {
  String fareAmount = "";
  getFareAmountAccordingToVehicalType(int index) {
    if (tripDirectionDetailsInfo != null) {
      if (dList[index]["bus_details"]["bus_type"].toString() == "Normal") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                        tripDirectionDetailsInfo!) /
                    2)
                .toStringAsFixed(2);
      }
      if (dList[index]["bus_details"]["bus_type"].toString() == "Luxury") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                        tripDirectionDetailsInfo!) *
                    2)
                .toStringAsFixed(2);
      }
      if (dList[index]["bus_details"]["bus_type"].toString() == "Semi") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                    tripDirectionDetailsInfo!))
                .toString();
      }
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Nearest Online Bus Drivers",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              )),
          leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                //delete ride request from database
                widget.referenceRideRequest!.remove();
                Fluttertoast.showToast(
                    msg: "You have cancelled the ride request..");

                SystemNavigator.pop();
              }),
        ),
        body: ListView.builder(
            itemCount: dList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    driverChoosenId = dList[index]["id"].toString();
                  });
                  Navigator.pop(context, "driverChoosed");
                },
                child: SizedBox(
                  height: 100,
                  child: Card(
                    color: Colors.grey[200],
                    elevation: 5,
                    shadowColor: Colors.green,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Image.asset(
                          "assets/images/" +
                              dList[index]["bus_details"]["bus_type"]
                                  .toString() +
                              ".png",
                          width: 120,
                          height: 150,
                        ),
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            dList[index]["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            dList[index]["bus_details"]["bus_model"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                          SmoothStarRating(
                            rating: dList[index]["ratings"] == null
                                ? 0.0
                                : double.parse(dList[index]["ratings"]),
                            color: Colors.black,
                            borderColor: Colors.black,
                            allowHalfRating: true,
                            starCount: 5,
                            size: 15,
                          )
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rs " + getFareAmountAccordingToVehicalType(index),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            tripDirectionDetailsInfo != null
                                ? tripDirectionDetailsInfo!.distance_text!
                                : "0",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 12),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            tripDirectionDetailsInfo != null
                                ? tripDirectionDetailsInfo!.duration_text!
                                : "0",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
