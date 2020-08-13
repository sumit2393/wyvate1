import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  // function to validate contact number
  Future<Null> validate() async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 10) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
      print('isvalis value is $isValid');
    }
  }

  //end
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/logo_icon.png',
                            width: 150,
                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Sign in',
                              style: TextStyle(fontSize: 20),
                            )),
                        Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Phone number",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              controller: _phoneNumberController,
                              onChanged: (text) {
                                validate();
                              },
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Contact Number";
                                } else {
                                  return !isValid
                                      ? 'Please provide a valid 10 digit phone number'
                                      : null;
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 40,
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.blue,
                              child: Text('Send OTP'),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    contactNumber = _phoneNumberController.text;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, '/OtpScreen');
                                }
                              }),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
