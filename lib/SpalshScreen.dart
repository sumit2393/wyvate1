import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RegistrationDetails.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    inputData();

    Timer(Duration(seconds: 3), () async {});
  }

  void inputData() async {
    await _auth.currentUser().then((FirebaseUser user) {
      if (user != null) {
        setState(() {
          uid = user.uid;
        });

        checkActiveState(user.uid);

      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    // here you write the codes to input the data into firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image(
                          image: AssetImage('assets/logo.png'),
                          width: 300.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  checkActiveState(uid) {
    final dbRef = FirebaseDatabase.instance.reference().child("BasicDetails");
    dbRef.child(uid).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if(values!=null){
        values.forEach((key, value) async {
          if (values["Status"] == "Inactive") {
            print('Inactive Account');
            InactiveAlert();
          } else {
            print('Activated Account');

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('Business_Name', values['Business_Name']);
            prefs.setString('Merchant_Email', values['Merchant_Email']);
            prefs.setString('Merchant_Address', values['Merchant_Address']);
            prefs.setString('Merchant_Contact', values['Merchant_Contact']);
            prefs.setString('City', values['City']);
            prefs.setString('State', values['State']);
            prefs.setString('Pincode', values['Pincode']);
            prefs.setString('userId', uid );

            Navigator.pushReplacementNamed(context, '/Dashboard');

          }
        });
      }else{
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> RegistrationDetails(UID: uid,)));
      }
    });
  }

  InactiveAlert() {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return new AlertDialog(
            content: new SingleChildScrollView(
              child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                          "Oops ! Your account is not approved for login. Please Try Again Later"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: RaisedButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          );
        });
  }

}
