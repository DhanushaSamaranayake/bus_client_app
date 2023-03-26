import 'package:bus_client_app/assistants/req_assistens.dart';
import 'package:bus_client_app/global/map_key.dart';
import 'package:bus_client_app/models/predicted_places.dart';
import 'package:bus_client_app/widgets/placeprediction_tile.dart';
import 'package:flutter/material.dart';

class SearchPlacesScreen extends StatefulWidget {
  @override
  _SearchPlacesScreenState createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placePredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:LK";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch ==
          "Error Occurred, Failed. No Response..") {
        return;
      }
      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          placePredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //search place UI
          Container(
            height: 160,
            decoration: const BoxDecoration(
                color: Color(0xFF0076CB),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    spreadRadius: 0.5,
                    offset: Offset(0, 10),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Search Places & Dropoff Location',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped) {
                              findPlaceAutoCompleteSearch(valueTyped);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search Places',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              contentPadding: const EdgeInsets.only(
                                left: 11,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          //display prediction design
          (placePredictedList.length > 0)
              ? Expanded(
                  child: ListView.separated(
                      itemCount: placePredictedList.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PlacePredictionTileDesign(
                          predictedPlaces: placePredictedList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 1,
                          color: Colors.grey,
                          thickness: 1,
                        );
                      }),
                  /*child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return PlacePredictionTileDesign(
                  predictedPlaces: placePredictedList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(
                height: 1,
                thickness: 1,
              ),
              itemCount: placePredictedList.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            )*/
                )
              : Container(),
        ],
      ),
    );
  }
}
