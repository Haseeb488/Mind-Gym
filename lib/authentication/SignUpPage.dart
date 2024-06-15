import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mindgym/golobal.dart';
import 'package:mindgym/progress_dialog.dart';
import 'package:mindgym/splash_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController areaTextEditingController = TextEditingController();
  TextEditingController zipCodeTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isPasswordVisible = false;

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
                  height: 100,
                  child: Image.asset("assets/logo_transparent.png"),
                ),
                SizedBox(height: 20),
                buildTextField(
                    nameTextEditingController, 'Name*', Icons.person),
                SizedBox(height: 20),
                buildTextField(
                    emailTextEditingController, 'Email*', Icons.email),
                SizedBox(height: 20),
                buildTextField(
                    passwordTextEditingController, 'Password*', Icons.lock),
                SizedBox(height: 20,),
                buildTextField(
                    phoneTextEditingController, 'Phone Number*', Icons.phone),
                SizedBox(height: 20),
                buildTextField(
                    countryTextEditingController, 'Country*', Icons.flag),
                SizedBox(height: 20),
                buildTextField(
                    areaTextEditingController, 'Area*', Icons.area_chart),
                SizedBox(height: 20),
                buildTextField(
                    zipCodeTextEditingController, 'Zip Code*', Icons.numbers),
                SizedBox(height: 20),
                buildTextField(addressTextEditingController, 'Address*',
                    Icons.location_city),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    validateForm();
                  },
                  child: Container(
                    height: 53,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black12.withOpacity(.2),
                          offset: const Offset(2, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(0, 255, 0, 0.7),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint,
      IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 14.5),
        obscureText: hint == 'Password' || hint == 'Confirm Password'
            ? !isPasswordVisible
            : false,
        textInputAction: hint == 'Confirm Password'
            ? TextInputAction.done
            : TextInputAction.next,
        // Set here
        decoration: InputDecoration(
          prefixIconConstraints: const BoxConstraints(minWidth: 45),
          prefixIcon: Icon(
            icon,
            color: Colors.white70,
            size: 22,
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white60, fontSize: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100).copyWith(
                bottomRight: Radius.circular(0)),
            borderSide: BorderSide(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  void showCircularProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
      },
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "Name must be atleast 3 Characters");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid");
    } else if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number is Required");
    } else if (phoneTextEditingController.text.length < 11) {
      Fluttertoast.showToast(msg: "Invalid Phone Number");
    }

    else if (countryTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter country name");
    }

    else if (zipCodeTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Zip code is required");
    }

    else if (addressTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Address is required");
    }
    else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 characters long");
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please Wait...",
          );
        });

    final User? firebaseUser = (await fAuth
        .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
        .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error:" + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map userMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "country": countryTextEditingController.text.trim(),
        "area": areaTextEditingController.text.trim(),
        "zipcode": zipCodeTextEditingController.text.trim(),
        "address": addressTextEditingController.text.trim(),
        "password": passwordTextEditingController.text.trim(),
      };

      DatabaseReference reference =
      FirebaseDatabase.instance.ref().child("users");

      reference.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been created.");

      Navigator.push(
          context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been created.");
    }
  }

}