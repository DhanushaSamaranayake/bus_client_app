import 'dart:async';
import 'package:bus_client_app/assistants/assistents_methods.dart';
import 'package:bus_client_app/auth/login.dart';
import 'package:bus_client_app/global/global.dart';
import 'package:bus_client_app/minScreens/mainScreen.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    fAuth.currentUser != null
        ? AssistantMethods.readCurrentOnlineUserInfo()
        : null;
    Timer(const Duration(seconds: 3), () async {
      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/loogo.png',
            ),
            const SizedBox(height: 20),
            const Text(
              'Bus booking and Tracking',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'inClient App',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
