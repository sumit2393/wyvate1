import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wyvate1/AddWorker.dart';
import 'package:wyvate1/Dashboard.dart';
import 'package:wyvate1/ProfileScreen.dart';
import 'package:wyvate1/RegistrationDetails.dart';
import 'package:wyvate1/Services.dart';
import 'package:wyvate1/TimeSchedule.dart';
import 'package:wyvate1/Workers.dart';

import 'package:wyvate1/constants/constants.dart';
import 'package:wyvate1/editProfile.dart';
import 'package:wyvate1/editWorker.dart';
import 'package:wyvate1/verifyOtp.dart';
import 'Login.dart';
import 'Registration.dart';
import 'OtpScreen.dart';
import 'SpalshScreen.dart';
import 'package:time_machine/time_machine.dart';

// ignore: non_constant_identifier_names

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  runApp(MyApp());
}

//global variables

String uid;

//workers page global variable

String workerId;

// existing order variables

// list of all category assigned to vendor
List<dynamic> categories;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WyVate',
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/registration': (context) => Registration(),
        '/OtpScreen': (context) => OtpScreen(
              otpNumber: contactNumber,
            ),
        '/RegistrationDetails': (context) => RegistrationDetails(
          UID: uid,
        ),
        '/login': (context) => Login(),
        '/verifyOtp': (context) => verifyOtp(otpNumber: contactNumber),
        '/Dashboard': (context) => Dashboard(
              UID: uid,
            ),
        '/timeschedule': (context) => TimeSchedule(
              UID: uid,
            ),
        '/editProfile': (context) => editProfile(),
        '/AddWorker': (context) => AddWorker(
              UID: uid,
            ),
        '/Workers': (context) => Workers(
              UID: uid,
            ),
        '/profile': (context) => ProfileScreen(
              UID: uid,
            ),
        '/EditWorker': (context) => EditWorker(
              workerID: workerId,
            ),
        '/Services': (context) => Services(
              UID: uid,
            ),
      },
    );
  }
}
