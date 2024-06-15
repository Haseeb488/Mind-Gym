import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mindgym/Global.dart';
import 'package:mindgym/Services/notifi_service.dart';
import 'package:mindgym/TransactionSuccessScreen.dart';
import 'package:mindgym/golobal.dart';
import 'package:mindgym/progress_dialog.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CardScreenState();
  }
}

class CardScreenState extends State<CardScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  OutlineInputBorder? border;
  TextEditingController bankName = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    bankName = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/bg.png'),
              fit: BoxFit.fill,
            ),
            color: Colors.black,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                CreditCardWidget(
                  glassmorphismConfig: Glassmorphism.defaultConfig(),
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: bankName.text,
                  frontCardBorder: Border.all(color: Colors.grey),
                  backCardBorder: Border.all(color: Colors.grey),
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.black,
                  backgroundImage: 'assets/card_bg.png',
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 17, right: 17, top: 20),
                          child: TextFormField(
                            controller: bankName,
                            style: const TextStyle(color: Colors.white),
                            onEditingComplete: (() => setState(() {})),
                            decoration: InputDecoration(
                              labelText: 'Bank Name',
                              hintText: 'ICICI Bank',
                              hintStyle: const TextStyle(color: Colors.white),
                              labelStyle: const TextStyle(color: Colors.white),
                              focusedBorder: border,
                              enabledBorder: border,
                            ),
                          ),
                        ),
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          themeColor: Colors.blue,
                          textColor: Colors.white,
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Card Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: border,
                            enabledBorder: border,
                          ),
                          expiryDateDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        GestureDetector(
                          onTap: _onValidate,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xFF042630),
                                  Color(0xFF042630),
                                ],
                                begin: Alignment(-1, -4),
                                end: Alignment(1, 4),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Pay Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _onValidate() {
    if (formKey.currentState!.validate()) {
      saveAppointment();
    } else {
      _showValidDialog(context, "Not Valid", "Try Again !!!");
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  _showValidDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  saveAppointment() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Booking Appointment.",
          );
        });

    String userId = DateTime.now().millisecondsSinceEpoch.toString();

    Map userMap = {
      "id": userId,
      "email": currentFirebaseUser!.email.toString(),
      "doctorName": doctorName,
      "time": appointmentTime,
      "date": appointmentDate,
      "ratings": doctorRatings,
      "whatsapp": doctorNumber,
      "image": doctorImage,
      "ratingStatus": "notDone",
      "comments": "",
    };

    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("appointments");

    reference.child(userId).set(userMap).then((_) {
      Navigator.push(context,
          MaterialPageRoute(builder: (c) => TransactionSuccessScreen()));
    }).catchError((error) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + error.toString());
    });

    String time = convert12To24(appointmentTime);
    final notificationService = NotificationService();
    await notificationService.initializeNotification();
    await notificationService.showNotificationWithDateTime(
        2,
        'Appointment Reminder',
        'Your appointment is scheduled today with $doctorName on $appointmentTime.',
        appointmentDate,
        time);
  }

  String convert12To24(String time12) {
    int hour = int.parse(time12.split(':')[0]);
    int minute = int.parse(time12.split(':')[1].split(' ')[0]);
    String period = time12.split(' ')[1];

    if (period == 'PM' && hour < 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');

    return '$hourStr:$minuteStr';
  }
}
