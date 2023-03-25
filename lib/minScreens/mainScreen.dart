import 'dart:async';

import 'package:bus_client_app/assistants/assistents_methods.dart';
import 'package:bus_client_app/auth/login.dart';
import 'package:bus_client_app/global/global.dart';
import 'package:bus_client_app/infoHandler/appInfo.dart';
import 'package:bus_client_app/minScreens/search_places_screen.dart';
import 'package:bus_client_app/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.927079, 79.861244),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double bottomPaddingOfMap = 0;

  Position? userCurrentPosition;
  var geolocator = Geolocator();

  //LocationPermission? _locationPermission;

  /*checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      // Permissions are denied forever, handle appropriately.
      _locationPermission = await Geolocator.requestPermission();
    }
  }*/

  locateUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographCordinates(
            userCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);
  }

  busThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                   [
    {
        "featureType": "administrative",
        "elementType": "all",
        "stylers": [
            {
                "saturation": "-100"
            }
        ]
    },
    {
        "featureType": "administrative.province",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "lightness": 65
            },
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "lightness": "50"
            },
            {
                "visibility": "simplified"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
            {
                "saturation": "-100"
            },
            {
                "color": "#0e34b0"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#0e34b0"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#0e34b0"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#0e34b0"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "all",
        "stylers": [
            {
                "lightness": "30"
            },
            {
                "visibility": "on"
            },
            {
                "color": "#612121"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#0e34b0"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "all",
        "stylers": [
            {
                "lightness": "40"
            },
            {
                "visibility": "on"
            },
            {
                "color": "#71906d"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "visibility": "simplified"
            }
        ]
    },
    {
        "featureType": "transit.line",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            },
            {
                "color": "#dd0c0c"
            }
        ]
    },
    {
        "featureType": "transit.line",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#4eb0e4"
            }
        ]
    },
    {
        "featureType": "transit.station.airport",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit.station.rail",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "hue": "#ffff00"
            },
            {
                "lightness": -25
            },
            {
                "saturation": -97
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels",
        "stylers": [
            {
                "lightness": -25
            },
            {
                "saturation": -100
            }
        ]
    }
]
                ''');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 270,
        child: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Colors.black.withOpacity(0.8)),
          child: MyDrawer(
            email: userModelCurrentInfo?.email,
            name: userModelCurrentInfo?.name,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              //bus theme google map
              busThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 240;
              });

              locateUserPosition();
            },
          ),
          // custom hamgurger

          Positioned(
            top: 36,
            left: 22,
            child: GestureDetector(
              onTap: () {
                sKey.currentState!.openDrawer();
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10, color: Colors.black54, spreadRadius: 8)
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),

          //ui for search location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              duration: const Duration(microseconds: 120),
              curve: Curves.easeIn,
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 16,
                          spreadRadius: 0.8,
                          offset: Offset(0.8, 0.8))
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      //from location
                      Row(children: [
                        const Icon(
                          Icons.add_location_alt_outlined,
                          color: Colors.black38,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'From',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            Text(
                              Provider.of<AppInfo>(context)
                                          .userPickUpLocation !=
                                      null
                                  ? (Provider.of<AppInfo>(context)
                                              .userPickUpLocation!
                                              .locationName!)
                                          .substring(0, 24) +
                                      "..."
                                  : "Not getting address",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ],
                        )
                      ]),

                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.black,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // To location
                      GestureDetector(
                        onTap: () {
                          //go to search place screen
                          var responseFromSearchScreen = Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SearchPlacesScreen()));

                          if (responseFromSearchScreen == "obtainedDropoff") {
                            //draw routes / draw polyline
                          }
                        },
                        child: Row(children: [
                          const Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.black38,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'To',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userDropOfLocation !=
                                        null
                                    ? Provider.of<AppInfo>(context)
                                        .userDropOfLocation!
                                        .locationName!
                                    : 'Where to go?',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ],
                          )
                        ]),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.black,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Request a Ride'),
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Brand-Bold'),
                            primary: Colors.black,
                            shadowColor: Colors.black54,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
