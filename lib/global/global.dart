import 'package:bus_client_app/models/direction_detailsinfo.dart';
import 'package:bus_client_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //driversKey info list
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? driverChoosenId = "";
String cloudMessagingServerToken =
    "key=AAAACik0J_g:APA91bG5qqY-BJqXqmp-E6tCpGU0HAHW1wehmJGtOITgdcNwdHH8pR_8FRQ2uXU15goo-wP7AfwM6D8iVcKF_pNcyAMi5YOpW-XS6LunpBuYOLKeoQGw5O-u0wfjWFfzsWOnkaZRS8PN";
String userDropOffAdress = "";
