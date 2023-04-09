import 'dart:convert';
import 'package:bus_client_app/assistants/req_assistens.dart';
import 'package:bus_client_app/global/global.dart';
import 'package:bus_client_app/global/map_key.dart';
import 'package:bus_client_app/infoHandler/appInfo.dart';
import 'package:bus_client_app/models/direction_detailsinfo.dart';
import 'package:bus_client_app/models/directions.dart';
import 'package:bus_client_app/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AssistantMethods {
  static Future<String> searchAddressForGeographCordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response..") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapShot(snap.snapshot);
      }
    });
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlobtainOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlobtainOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response..") {
      return null;
    }

    DirectionDetailsInfo directiondetailsInfo = DirectionDetailsInfo();
    directiondetailsInfo.encoded_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    directiondetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directiondetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
    directiondetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directiondetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directiondetailsInfo;
  }

  static double calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    double timeTraveledFarePerMin =
        (directionDetailsInfo.duration_value! / 60) * 0.2;
    double distanceTraveledFarePerKM =
        (directionDetailsInfo.distance_value! / 1000) * 0.2;
    //USD type currency
    double totalFareAmount = timeTraveledFarePerMin + distanceTraveledFarePerKM;

    //convert to local currency 1 USD = 320 LKR
    double totalLocalAmount = totalFareAmount * 320;

    return double.parse(
        totalLocalAmount.toStringAsFixed(2)); //21.3333 rounded amount
  }

  static sendNotificationDriverNow(
      String deviceRegistrationToken, String userRideRequestId, context) async {
    String destinationAdrees = userDropOffAdress;
    Map<String, String> headerNotification = {
      "Authorization": cloudMessagingServerToken,
      "Content-Type": "application/json"
    };

    Map bodyNotification = {
      "title": "New Ride Request",
      "body": "Destination Address : \n$destinationAdrees."
    };

    Map datamap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officalNotificationFormat = {
      "notification": bodyNotification,
      "data": datamap,
      "priority": "high",
      "to": deviceRegistrationToken
    };

    var responsedNotification = http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officalNotificationFormat));
  }
}
