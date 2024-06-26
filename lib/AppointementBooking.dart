import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mindgym/CardScreen.dart';
import 'package:mindgym/Global.dart';

import 'TransactionSuccessScreen.dart';


class AppointmentBookingForm extends StatefulWidget {
  const AppointmentBookingForm({super.key});

  @override
  _AppointmentBookingFormState createState() => _AppointmentBookingFormState();
}

class _AppointmentBookingFormState extends State<AppointmentBookingForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController easyPaisaController = TextEditingController();
  String pickUpLocationText = "Pickup Address";
  String consultationTypeText = "Consultation Type";

  String selectedPickUpLocation = "";
  String selectedDropOffLocation = "";

  DateTime _pickupDate = DateTime.now();
  TimeOfDay _pickupTime = TimeOfDay.now();

  String locationSelected = "Select Current Location";

  String completeAddress = "";

  String name = "";
  String telephone = "";
  String email = "";
  String numberOfPassengers = "";

  bool consultationTypeErrorVisibility = false;
  bool jobTypeErrorVisibility = false;

  String? selectedConsultationType;

  showBookingConfirmationDialog(
      BuildContext context, String title, String message) {
    Widget okbtn = TextButton(
      onPressed: () {
        // Add your logic here for Confirm Booking

        Navigator.push(
            context, MaterialPageRoute(builder: (c) => TransactionSuccessScreen()));
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
      ),
      child:
          const Text("Confirm Booking", style: TextStyle(color: Colors.white)),
    );

    Widget cancelbtn = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
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

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Appointment Form',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: Colors.blueGrey.shade900,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade500],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    // Set the circular radius
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              border: Border.all(color: Colors.white70),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Appointment Date* \n${DateFormat('yyyy-MM-dd').format(_pickupDate)}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: _pickupDate,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 365)),
                                      );
                                      if (pickedDate != null &&
                                          pickedDate != _pickupDate) {
                                        setState(() {
                                          _pickupDate = pickedDate;
                                          appointmentDate =
                                              DateFormat('yyyy-MM-dd').format(
                                                  pickedDate); // Assign the formatted date to appointmentDate
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              border: Border.all(color: Colors.white70),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Appointment Time* \n ${_pickupTime.format(context)}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: _pickupTime,
                                      );
                                      if (pickedTime != null &&
                                          pickedTime != _pickupTime) {
                                        setState(() {
                                          _pickupTime = pickedTime;
                                          appointmentTime = _formattedTime(
                                              pickedTime); // Assigning the formatted time to a string variable
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.blueGrey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 5.0, top: 5.0, bottom: 5.0),
                              child: DropdownButton<String>(
                                value: selectedConsultationType,
                                alignment: Alignment.centerRight,
                                isExpanded: true,
                                hint: const Text(
                                  'Select Consultation Type*',
                                  style: TextStyle(
                                    backgroundColor: Colors.red,
                                    fontFamily: "Poppins"
                                  ),
                                ),
                                underline: Container(),
                                dropdownColor: Colors.black87,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text(
                                      'Consultation Type*',
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'Online',
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Online',
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'In Person',
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'In Person',
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    consultationTypeText = value.toString();
                                    selectedConsultationType = value;
                                    consultationTypeErrorVisibility = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: consultationTypeErrorVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9.0, top: 3),
                              child: Text(
                                "Please Select Consultation Type",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (consultationTypeText ==
                                        "Consultation Type" ||
                                    consultationTypeText == null) {
                                  setState(() {
                                    consultationTypeErrorVisibility = true;
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    consultationTypeErrorVisibility = false;
                                  });

                                  if (appointmentDate == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please select Appointment Date");
                                    return;
                                  }
                                  if (appointmentTime == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please select Appointment Time");
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CardScreen(),
                                    ),
                                  );
                                  /*
                                  showBookingConfirmationDialog(
                                      context,
                                      "Appointment Summary",
                                          "Psychologist: $doctorName \n"
                                          "Appointment Date: ${DateFormat('dd-MM-yyyy').format(_pickupDate)}\n"
                                          "Appointment Time: ${_pickupTime.format(context)} \n"
                                          "Consultation Type: ${consultationTypeText}");*/
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_right,
                                      color: Colors.white),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              backgroundColor: Color(0xFF042630),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formattedTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '${hour}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }
}
