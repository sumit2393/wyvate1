import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isValid = false;
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 190,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
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
                      Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Text('Proceed'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  contactNumber = _phoneNumberController.text;
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/verifyOtp');
                              }
                            },
                          )
                      ),
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }
}
