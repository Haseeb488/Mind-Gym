import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindgym/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
String cloudMessagingServerToken = "key=AAAAi72U8Tc:APA91bGhOxDwHlWfh8JDlYDcI0fVLD-UtfynKL5rcw8MH9UdiVzlUlyJRDj9l1gDNPYY1eQBC6Z9JSMYkKNi-EEQHTqwK9wmpc_dVn3sG5xaFg3cvyOZKnZOsewN7qY4Td-rmQsjy43E";
