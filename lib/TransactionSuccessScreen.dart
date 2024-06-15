import 'package:flutter/material.dart';
import 'package:mindgym/AvailablePsychologists.dart';
import 'dart:math';

import 'package:mindgym/MyAppointments.dart';
import 'package:mindgym/splash_screen.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final String transactionId = _generateTransactionId();
  final DateTime transactionDate = DateTime.now();

  static String _generateTransactionId() {
    var rng = Random();
    return 'TXN${rng.nextInt(1000000).toString().padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.green,
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Transaction Successful',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  _buildDetailRow('Transaction ID:', transactionId),
                  SizedBox(height: 10),
                  _buildDetailRow(
                      'Date:', '${transactionDate.toLocal()}'.split(' ')[0]),
                  SizedBox(height: 10),
                  _buildDetailRow(
                      'Time:',
                      '${transactionDate.toLocal()}'
                          .split(' ')[1]
                          .split('.')[0]),
                  SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAppointments (
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.greenAccent.shade700,
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('View Appointment',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
