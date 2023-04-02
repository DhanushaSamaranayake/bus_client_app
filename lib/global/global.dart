import 'package:bus_client_app/models/direction_detailsinfo.dart';
import 'package:bus_client_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //driversKey info list
DirectionDetailsInfo? tripDirectionDetailsInfo;
