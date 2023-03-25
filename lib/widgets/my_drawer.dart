import 'package:bus_client_app/SplashScreen/splash_screen.dart';
import 'package:bus_client_app/global/global.dart';
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
              height: 165,
              color: Colors.grey,
              child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
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
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.email.toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            )
                          ])
                    ],
                  ))),

          const SizedBox(
            height: 12,
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.white54,
              ),
              title: Text(
                "History",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white54,
              ),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white54,
              ),
              title: Text(
                "About",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white54,
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
                color: Colors.white54,
              ),
              title: Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white54,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
