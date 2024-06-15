import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mindgym/Global.dart';
import 'package:mindgym/authentication/SignUpPage.dart';
import 'package:mindgym/golobal.dart';
import 'package:mindgym/progress_dialog.dart';
import 'package:mindgym/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isPasswordVisible = false;

  void showCircularProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // Prevent the user from dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(0, 255, 0, 0.7),
          ),
        );
      },
    );
  }

// Function to validate email address using regex
  bool isValidEmail(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  //   padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Image.asset("assets/logo_transparent.png"),
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30)
                      .copyWith(bottom: 10),
                  child: TextField(
                    controller: emailTextEditingController,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.white, fontSize: 14.5),
                    decoration: InputDecoration(
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 45),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.white70,
                          size: 22,
                        ),
                        //  border: InputBorder.none,
                        hintText: 'Enter Email',
                        hintStyle: const TextStyle(
                            color: Colors.white60, fontSize: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.white38)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.white70))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30)
                      .copyWith(bottom: 10),
                  child: TextField(
                    controller: passwordTextEditingController,
                    style: const TextStyle(color: Colors.white, fontSize: 14.5),
                    obscureText: isPasswordVisible ? false : true,
                    decoration: InputDecoration(
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 45),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white70,
                          size: 22,
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minWidth: 45, maxWidth: 46),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                            size: 22,
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        hintStyle: const TextStyle(
                            color: Colors.white60, fontSize: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.white38)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100).copyWith(
                                bottomRight: const Radius.circular(0)),
                            borderSide:
                                const BorderSide(color: Colors.white70))),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: () {
                    loginUserNow();
                  },
                  child: Container(
                    height: 53,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.black12.withOpacity(.2),
                            offset: const Offset(2, 2))
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.amber.shade500,
                    ),
                    child: Text('Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  },
                  child: const Text('Create new account',
                      style: TextStyle(color: Colors.white70, fontSize: 15)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please Wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error:" + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;

        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          setState(() {
            userEmail = emailTextEditingController.text.toString();
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        } else {
          Fluttertoast.showToast(msg: "No Record Exits with this Email");
          fAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
  }
}
