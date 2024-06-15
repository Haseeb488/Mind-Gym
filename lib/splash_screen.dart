import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:mindgym/AvailablePsychologists.dart';
import 'package:mindgym/authentication/LoginScreen.dart';
import 'package:mindgym/golobal.dart';
import 'package:mindgym/user_model.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {


  startTimer() {
    final FirebaseAuth fAuth = FirebaseAuth.instance;
    fAuth.currentUser != null
        ? readCurrentOnlineUserInfo()
        : null;
    Timer(const Duration(seconds: 3), () async {
      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AvailablePsychologists()));
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
        color: Colors.black,
        child: Column
          (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo_transparent.png"),
            SizedBox(height: 30,),
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  ScaleAnimatedText(
                    'MIND GYM',
                    duration: const Duration(seconds: 8),
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(fontSize: 40.0,
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

   void readCurrentOnlineUserInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }
}
