import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mindgym/AvailablePsychologists.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({Key? key}) : super(key: key);

  @override
  State<MyAppointments> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  late Query dbRef;
  late DatabaseReference reference;
  bool hasAppointments = true;

  @override
  void initState() {
    super.initState();
    _setupAppointmentsQuery();
  }

  Future<void> _setupAppointmentsQuery() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userEmail = currentUser.email!;
      dbRef = FirebaseDatabase.instance
          .ref()
          .child('appointments')
          .orderByChild('email')
          .equalTo(userEmail);
      reference = FirebaseDatabase.instance.ref().child('appointments');

      DataSnapshot snapshot = await dbRef.get();
      if (!snapshot.exists) {
        setState(() {
          hasAppointments = false;
        });
        } else {
        setState(() {
          hasAppointments = true;
        });
      }
    }
  }

  Widget listItem({required Map user}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white12, Colors.blueGrey.shade800],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
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
                  user['doctorName'],
                  style: const TextStyle(
                    fontSize: 21,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: RatingBarIndicator(
                    itemSize: 20.0,
                    rating: double.parse(
                        user['ratings'] != null ? user['ratings'] : '3.0'),
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Center(
              child: buildInfoText(
                  "Appointment Date:", user['date'], Icons.calendar_today)),
          Center(
              child: buildInfoText("Time:", user['time'], Icons.access_time)),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                String phoneNumber =
                user['whatsapp'].toString().replaceAll(RegExp(r'\D'), '');
                if (phoneNumber.startsWith('0')) {
                  phoneNumber = phoneNumber.substring(1);
                }
                String whatsappUrl = "https://wa.me/$phoneNumber";

                try {
                  bool launched = await launch(whatsappUrl);
                  if (!launched) {
                    throw 'Could not launch WhatsApp';
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Could not open WhatsApp. Make sure the number is registered on WhatsApp."),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/whatsapp.png', // Replace with the path to your icon
                    height: 24.0, // Adjust the height as needed
                    width: 24.0, // Adjust the width as needed
                  ),
                  const SizedBox(width: 8.0),
                  // Add some space between the icon and text
                  const Text(
                    'Whatsapp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  Widget buildInfoText(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white70,
          ),
          const SizedBox(width: 8.0),
          Text(
            "$title $content",
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => AvailablePsychologists()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Center(
            child: Text(
              'My Appointment',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.blueGrey.shade900,
        ),
        body: hasAppointments
            ? FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map student = snapshot.value as Map;
            student['key'] = snapshot.key;
            return listItem(user: student);
          },
          defaultChild: const Center(
            child: CircularProgressIndicator(),
          ),
        )
            : const Center(
          child: Text(
            'No appointments found.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
