import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreen();
}

class _AboutScreen extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          //image
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: 250,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  'assets/images/car_logo.png',
                  fit: BoxFit.cover,
                  width: 260,
                ),
              ),
            ),
          ),
          //company name and About company
          Column(
            children: [
              const Text(
                'Bus Booking and Tracking App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'This app has developed by Dhanusha perera'
                  'for the final year project of the degree of Bsc(Hons) in Software Engineering'
                  'at the University of Plymouth',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'This app has developed by Dhanusha perera'
                'for the final year project of the degree of Bsc(Hons) in Software Engineering'
                'at the University of Plymouth',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              //button
              const SizedBox(
                height: 20,
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
          )
        ],
      ),
    );
  }
}
