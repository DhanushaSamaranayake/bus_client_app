import 'package:bus_client_app/assistants/req_assistens.dart';
import 'package:bus_client_app/global/map_key.dart';
import 'package:bus_client_app/infoHandler/appInfo.dart';
import 'package:bus_client_app/models/directions.dart';
import 'package:bus_client_app/models/predicted_places.dart';
import 'package:bus_client_app/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacePredictionTileDesign extends StatelessWidget {
  final PredictedPlaces? predictedPlaces;

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait...",
            ));

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);
    Navigator.pop(context);
    if (responseApi == "Error Occurred, Failed. No Response..") {
      return;
    }

    if (responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOfLocationAddress(directions);

      Navigator.pop(context, "obtainedDropoff");
    }
  }

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(children: [
          const Icon(Icons.location_on),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                predictedPlaces!.main_text!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                predictedPlaces!.secondary_text!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ))
        ]),
      ),
    );
  }
}
