import 'package:bus_client_app/SplashScreen/splash_screen.dart';
import 'package:bus_client_app/global/global.dart';
import 'package:bus_client_app/minScreens/history_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({this.name, this.email});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
              height: 170,
              color: Colors.white,
              child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0076CB),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.name.toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.email.toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            )
                          ])
                    ],
                  ))),

          const SizedBox(
            height: 20,
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => TripsHistoryScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.history,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "History",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.person,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.wallet,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Payment",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.help_center,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Help and Support",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.info,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "About",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              fAuth.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                size: 30,
                color: Color(0xFF0076CB),
              ),
              title: Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
