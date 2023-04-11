import 'package:bus_client_app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;
  RateDriverScreen({this.assignedDriverId});
  @override
  State<RateDriverScreen> createState() => _RateDriverScreen();
}

class _RateDriverScreen extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Rate Trip Experience",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: false,
                color: Colors.green,
                borderColor: Colors.green,
                starCount: 5,
                size: 45,
                onRatingChanged: (valueOfStarsChoosed) {
                  countRatingStars = valueOfStarsChoosed;
                  if (countRatingStars == 1) {
                    setState(() {
                      titleRating = "Very Bad";
                    });
                  }
                  if (countRatingStars == 2) {
                    setState(() {
                      titleRating = " Bad";
                    });
                  }
                  if (countRatingStars == 3) {
                    setState(() {
                      titleRating = "Good";
                    });
                  }
                  if (countRatingStars == 4) {
                    setState(() {
                      titleRating = "Very Good";
                    });
                  }
                  if (countRatingStars == 5) {
                    setState(() {
                      titleRating = "Excellent";
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                titleRating,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseReference rateDriverRef = FirebaseDatabase.instance
                        .ref()
                        .child("drivers")
                        .child(widget.assignedDriverId!)
                        .child("ratings");
                    rateDriverRef.once().then((snap) {
                      if (snap.snapshot.value == null) {
                        rateDriverRef.set(countRatingStars.toString());

                        SystemNavigator.pop();
                      } else {
                        double oldRating =
                            double.parse(snap.snapshot.value.toString());
                        double newRating = (oldRating + countRatingStars) / 2;
                        rateDriverRef.set(newRating.toString());

                        SystemNavigator.pop();
                      }
                      Fluttertoast.showToast(msg: "Please Restart App Now..");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
