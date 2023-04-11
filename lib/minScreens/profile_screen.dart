import 'package:bus_client_app/global/global.dart';
import 'package:bus_client_app/widgets/info_design_ui.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Text(
            userModelCurrentInfo!.name!,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          InfoDesignUIWidget(
            textInfo: userModelCurrentInfo!.email,
            iconData: Icons.email,
          ),
          const SizedBox(
            height: 10,
          ),
          InfoDesignUIWidget(
            textInfo: userModelCurrentInfo!.phone,
            iconData: Icons.phone_iphone,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  shadowColor: Colors.black,
                  elevation: 5),
              child: const Text("Go Back"))
        ],
      )),
    );
  }
}
