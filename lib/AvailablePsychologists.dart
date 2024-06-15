import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mindgym/PsychologistProfile.dart';
import 'package:mindgym/golobal.dart';
import 'package:mindgym/progress_dialog.dart';
import 'package:mindgym/Global.dart';
import 'package:mindgym/MyAppointments.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rating_dialog/rating_dialog.dart';


class AvailablePsychologists extends StatefulWidget {
  const AvailablePsychologists({Key? key}) : super(key: key);

  @override
  State<AvailablePsychologists> createState() => _AvailablePsychologistsState();
}

class _AvailablePsychologistsState extends State<AvailablePsychologists> {
  Query dbRef = FirebaseDatabase.instance.ref().child('psychiatrists');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('psychiatrists');

  Query dbAppointments = FirebaseDatabase.instance.ref().child('appointments');
  DatabaseReference appointmentsRef = FirebaseDatabase.instance.ref().child('appointments');

  Widget listItem({required Map user}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade800],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 5.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/' + user['image']),
                  radius: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  user['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(height: 10),
          buildInfoText("Qualification:", user['qualification']),
          buildInfoText("Experience:", user['experience']),
          buildInfoText("Consultation Fee:", "${user['fee']}"),
          buildDescriptionText(user['description']),
          buildInfoText("Reviews:", user['reviews']),

          const SizedBox(height: 5),
          Center(
            child: RatingBarIndicator(
              itemSize: 23.0,
              rating: double.parse(user['ratings'] != null ? user['ratings'] : '3.0'),
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  doctorName = user['name'];
                  doctorImage = user['image'];
                  doctorRatings = user['ratings'];
                  doctorExperience = user['experience'];
                  doctorNumber = user['whatsapp'];
                });
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => PsychologistProfile()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF042630),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'View Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoText(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
        child: Text(
          "$title $content",
          style: const TextStyle(
            fontSize: 17,
            fontWeight:FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.white70,
          ),
        ),
    );
  }

  Widget buildDescriptionText(String content) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        "$content",
        style: const TextStyle(
          fontSize: 17,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    checkNotificationPermission();
    getRatingStatus();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        showLogoutAlertDialog(
          context,
          "Exit App",
          "Are you sure to exit the app?",
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          title: const Center(
            child: Text(
              'Psychiatrist & Psychologist',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.blueGrey.shade800,
        ),
        drawer: Drawer(
          backgroundColor: Colors.blueGrey.shade400,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentFirebaseUser!.email.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('My Appointments',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 18
                ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAppointments(),
                    ),
                  );
                },
              ),

              ListTile(
                title: const Text('SignOut',
                style: TextStyle(
                  fontSize: 18,
                fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                ),
                onTap: () {
                  fAuth.signOut();
                  SystemNavigator.pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const ExitAppScreen(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),

        body: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            Map student = snapshot.value as Map;
            student['key'] = snapshot.key;
            return listItem(user: student);
          },
        ),
      ),
    );
  }

  Future<void> _selectDateAndTime(String doctorName) async {
    DateTime? selectedDate = DateTime.now();
    TimeOfDay? selectedTime = TimeOfDay.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.grey[800],
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime!,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Colors.grey[800],
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && pickedTime != selectedTime) {
        setState(() {
          selectedTime = pickedTime;
        });

        DateTime selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );

        DateTime selectedTimes = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDate = DateFormat('dd-MM-yy').format(selectedDate);
        String formattedTime =
            "${selectedTimes.hour.toString().padLeft(2, '0')}:${selectedTimes.minute.toString().padLeft(2, '0')}";

        showAppointmentConfirmationDialog(
          context,
          "Appointment Confirmation",
          "Are you sure to book appointment for \n"
              "$doctorName\n"
              "Date: $formattedDate\n"
              "Time: $formattedTime",
          formattedDate,
          formattedTime,
          doctorName,
        );
      }
    }
  }

  showAppointmentConfirmationDialog(BuildContext context, String title,
      String message, String date, String time, String name) {
    Widget okbtn = TextButton(
      onPressed: () {
        Fluttertoast.showToast(msg: "clicked");
        saveAppointmentInfoNow(name, date, time);
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text("Confirm Booking", style: TextStyle(color: Colors.white)),
    );

    Widget cancelbtn = TextButton(
      child: const Text("Cancel", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black,
      title: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 15, color: Colors.white),
      ),
      actions: [
        cancelbtn,
        okbtn,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  saveAppointmentInfoNow(String name, String date, String time) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please Wait...",
          );
        });

    String userId = DateTime.now().millisecondsSinceEpoch.toString();

    Map userMap = {
      "id": userId,
      "name": name,
      "date": date,
      "time": time,
    };

    DatabaseReference reference = FirebaseDatabase.instance.ref().child("appointments");

    reference.child(userId).set(userMap).then((_) {
      Fluttertoast.showToast(msg: "appointment has been booked.");
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + error.toString());
    });
  }

  showLogoutAlertDialog(BuildContext context, String title, String message) {
    Widget okbtn = TextButton(
      onPressed: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      child: const Text("Yes", style: TextStyle(color: Colors.white)),
    );

    Widget cancelbtn = TextButton(
      child: Text("No", style: TextStyle(color: Colors.white)),
      onPressed: () {
       Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrange,
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      actions: [
        cancelbtn,
        okbtn,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  checkNotificationPermission() async {

    late final Map<Permission, PermissionStatus> permissionStatus;
    permissionStatus = await [Permission.notification].request();

  }

  Future<void> getRatingStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userEmail = currentUser.email!;
      Query dbAppointments = FirebaseDatabase.instance
          .ref()
          .child('appointments')
          .orderByChild('email')
          .equalTo(userEmail);

      DataSnapshot snapshot = await dbAppointments.get();
      if (!snapshot.exists) {
        // Fluttertoast.showToast(msg: "No record found");
      } else {
        Map<dynamic, dynamic> appointmentsData = snapshot.value as Map<dynamic, dynamic>;
        String? ratingStatus;
        String? appointmentId;
        String? dateOfAppointment;
        String? timeOfAppointment;

        // Assuming that appointmentsData is a map with appointment IDs as keys
        for (var entry in appointmentsData.entries) {
          var appointment = entry.value;
          if (appointment is Map && appointment['ratingStatus'] != null) {

            appointmentId = entry.key;
            ratingStatus = appointment['ratingStatus'];
            dateOfAppointment = appointment["date"];
            timeOfAppointment = convert12HourTo24Hour(appointment["time"]);

            if (ratingStatus == "notDone") {
              showRatingsDialog(context,appointmentId.toString(),dateOfAppointment.toString(), timeOfAppointment);

            }
            break; // Assuming you want the ratingStatus of the first matching appointment
          }
        }

        if (ratingStatus == null) {
          Fluttertoast.showToast(msg: "No rating status found");
        }
      }
    }
  }

  String convert12HourTo24Hour(String time12Hour) {
    List<String> parts = time12Hour.split(" ");
    String time = parts[0];
    String meridiem = parts[1];

    List<String> timeParts = time.split(":");
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    if (meridiem == "PM" && hours < 12) {
      hours += 12;
    } else if (meridiem == "AM" && hours == 12) {
      hours = 0;
    }

    String time24Hour = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    return time24Hour;
  }


  Future<void> updateRatingStatus(String appointmentId, String rating, String comments) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DatabaseReference appointmentRef = FirebaseDatabase.instance
          .ref()
          .child('appointments')
          .child(appointmentId);

      try {
        await appointmentRef.update({'ratingStatus': "Done"});
        await appointmentRef.update({'ratings': rating});
        await appointmentRef.update({'comments': comments});
        Fluttertoast.showToast(msg: "Thanks for Feedback");
      } catch (e) {
        Fluttertoast.showToast(msg: "Failed to update rating status: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "User not logged in");
    }
  }


  String addMinutesToTime(String time, int additionalMinutes) {
    List<String> parts = time.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Add the additional minutes
    minutes += additionalMinutes;

    // Adjust hours and minutes if necessary
    if (minutes >= 60) {
      hours += minutes ~/ 60;
      minutes %= 60;
    }
    hours %= 24; // Ensure hours are within 0-23 range

    // Format the adjusted time back into the string format
    String adjustedTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    return adjustedTime;
  }


  void showRatingsDialog(BuildContext context, String appointmentID, String appointmentDate, appointmentTime) {
    WidgetsBinding.instance.addPostFrameCallback((_) {

      String newTime = addMinutesToTime(appointmentTime, 2);

      // Parsing the date string to a DateTime object
      DateTime dateTime = DateTime.parse(appointmentDate);

      // Extracting the year, month, and day
      int year = dateTime.year;
      int month = dateTime.month;
      int day = dateTime.day;

      print("Year: $year");
      print("Month: $month");
      print("Day: $day");


      List<String> timeParts = newTime.split(":");
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      DateTime otherDateTime = DateTime(year, month, day, hour, minute, 0);

       bool isAfter = isCurrentTimeAfter(otherDateTime);

       if(isAfter) {
         RatingDialog _dialog = RatingDialog(
           initialRating: 1.0,
           starSize: 25.0,
           title: const Text(
             'Rate Your Experience',
             textAlign: TextAlign.center,
             style: TextStyle(
               fontSize: 25,
               fontWeight: FontWeight.bold,
             ),
           ),
           message: const Text(
             'We value your feedback. Please rate the quality of service provided by our Psychologist.',
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 15),
           ),
           image: Image.asset(
               'assets/rating-star.png', width: 100, height: 100),
           submitButtonText: 'Submit',
           submitButtonTextStyle: const TextStyle(
             fontSize: 17,
             color: Colors.black87,
             fontWeight: FontWeight.bold,
           ),
           commentHint: 'Add any additional comments (optional)',
           onCancelled: () => print('cancelled'),
           onSubmitted: (response) {
             updateRatingStatus(
                 appointmentID, response.rating.toString(), response.comment);
             print('rating: ${response.rating}, comment: ${response.comment}');
           },
         );
         showDialog(
           context: context,
           barrierDismissible: false,
           builder: (context) => _dialog,
         );
       }
    });
  }
  bool isCurrentTimeAfter(DateTime otherDateTime) {
    DateTime currentDateTime = DateTime.now();
    return currentDateTime.isAfter(otherDateTime);
  }
}

