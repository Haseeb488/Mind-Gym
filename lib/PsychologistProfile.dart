import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mindgym/AppointementBooking.dart';
import 'package:mindgym/Global.dart';

class PsychologistProfile extends StatefulWidget {
  @override
  _PsychologistProfileState createState() => _PsychologistProfileState();
}

class _PsychologistProfileState extends State<PsychologistProfile> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Center(
          child: Text(
            "Psychologist Profile",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70,),
            CircleAvatar(
              backgroundImage: AssetImage('assets/'+doctorImage), // Replace with your image asset
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text(
              doctorName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Gestalt-therapist',
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            RatingBarIndicator(
              itemSize: 22.0,
              rating: double.parse(doctorRatings),
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              doctorRatings+' out of 5.0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Poppins"
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'According to patient\'s reviews',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontFamily: "Poppins"
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconCard(icon: Icons.accessible, text: '100+\nPatients'),
                IconCard(icon: Icons.school, text: doctorExperience+'\n Experience'),
                IconCard(icon: Icons.card_membership, text: '6+\nCertificates'),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => AppointmentBookingForm()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF042630),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Book Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconCard extends StatelessWidget {
  final IconData icon;
  final String text;

  IconCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blueGrey[400],
          child: Icon(icon, color: Colors.white, size: 30),
          radius: 30,
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
