import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wyvate1/RegistrationDetails.dart';

import 'otpinput.dart';

class verifyOtp extends StatefulWidget {
  verifyOtp({this.otpNumber});
  String otpNumber;

  @override
  _verifyOtpState createState() => _verifyOtpState();
}

class _verifyOtpState extends State<verifyOtp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();
  String otpstatus = "";
  String uid;
  List<String> LoginStatus;
  bool otpbutton = false;
  String Status;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Decorate the outside of the Pin.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onVerifyCode();
  }

  PinDecoration _pinDecoration = UnderlineDecoration(
    enteredColor: Colors.black,
  );
  bool isCodeSent = false;
  String _verificationId;
  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) {
        if (value.user != null) {
          // Handle loogged in state
          print(value.user.phoneNumber);
          setState(() {
            uid = value.user.uid;
          });

          checkActiveState(uid);
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        print("Try again in sometime: $error");
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        otpstatus = "Waiting for OTP";

        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.otpNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  checkActiveState(uid) {
    final dbRef = FirebaseDatabase.instance.reference().child("BasicDetails");
    dbRef.child(uid).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if(values!=null){
        values.forEach((key, value) {
          if (values["Status"] == "Inactive") {
            print('Inactive Account');
            InactiveAlert();
          } else {
            print('Activated Account');

            Navigator.pushReplacementNamed(context, '/Dashboard');

          }
        });
      }else{
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> RegistrationDetails(UID: uid,)));
      }
    });
    setState(() {
      Status = LoginStatus[0];
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

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        // Handle loogged in state
        print(value.user.phoneNumber);
        setState(() {
          uid = value.user.uid;
        });

        checkActiveState(uid);
      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("isValid - $isCodeSent");
    print("mobile ${widget.otpNumber}");
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
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: PinInputTextField(
                            pinLength: 6,
                            decoration: _pinDecoration,
                            controller: _pinEditingController,
                            autoFocus: true,
                            textInputAction: TextInputAction.done,
                            onSubmit: (pin) {
                              if (pin.length == 6) {
                                _onFormSubmitted();
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: isCodeSent == true
                            ? Text('waiting for OTP')
                            : RaisedButton(
                                child: Text('Resend OTP'),
                              ),
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: isCodeSent == true
                              ? RaisedButton(
                                  child: Text('Verify OTP'),
                                  onPressed: () {
                                    if (_pinEditingController.text.length ==
                                        6) {
                                      _onFormSubmitted();
                                    } else {
                                      showToast("Invalid OTP", Colors.red);
                                    }
                                  },
                                )
                              : null),
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
}
