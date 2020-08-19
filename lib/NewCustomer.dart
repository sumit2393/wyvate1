import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wyvate1/NewAppointment.dart';
class NewCustomer extends StatefulWidget {
  @override
  _NewCustomerState createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  ProgressDialog pr;
  final fb = FirebaseDatabase.instance;
   final customerName=TextEditingController();
  final customerEmail=TextEditingController();
  final contact=TextEditingController();
  final address=TextEditingController();


  AddCustomerDetails() async {

    final DatabaseReference database =  await FirebaseDatabase.instance.reference().child('Customers');
    database.push().set({
      "Name": customerName.text,
      "Email": customerEmail.text,
      "Contact":contact.text,
      "Address": address.text
    }).then((value) {
      ShowSuccessAlert();
      print('inserted');
    }).catchError((error) {
      print(error);
    });
  }
  ShowSuccessAlert() {
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
                          "Save successfully"),
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
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (BuildContext context) => NewAppointment()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children: [
          Container(
            padding: EdgeInsets.only(top:100,left: 10,right: 10),
            child: new TextField(
              controller: customerName,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Customer Name",
                  fillColor: Colors.white70),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(

            padding: EdgeInsets.only(left: 10,right: 10),

            child: new TextField(
              controller: customerEmail,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Email id",
                  fillColor: Colors.white70),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 10,right: 10),

            child: new TextField(
              controller: contact,
              keyboardType: TextInputType.number,

              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "MobileNumber",
                  fillColor: Colors.white70),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 10,right: 10),

            child: new TextField(
              controller: address,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Address",
                  fillColor: Colors.white70),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: RaisedButton(
                textColor: Colors.black,
                color: Colors.greenAccent,
                child: Text("Submit"),
                onPressed: () {
                  AddCustomerDetails();
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            )
          )
        ],


      ),
    );
  }
}
