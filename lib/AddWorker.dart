import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wyvate1/main.dart';

class AddWorker extends StatefulWidget {
  AddWorker({this.UID});
  String UID;
  @override
  _AddWorkerState createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  List<String> services = [];
  List<bool> serviceCheck = [];
  List<String> selectedServices = [];
  List<String> serviceKey = [];
  List<String> selectedServiceKey = [];
  String newkey;
  final sundayIn = TextEditingController();
  final sundayOut = TextEditingController();
  final mondayIn = TextEditingController();
  final mondayOut = TextEditingController();
  final tuesdayIn = TextEditingController();
  final tuesdayOut = TextEditingController();
  final wedIn = TextEditingController();
  final wedOut = TextEditingController();
  final thursIn = TextEditingController();
  final thursOut = TextEditingController();
  final fridayIn = TextEditingController();
  final fridayOut = TextEditingController();
  final satIn = TextEditingController();
  final satOut = TextEditingController();
  final workerName = TextEditingController();
  final workerContact = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> _onBackPressed() {
    Navigator.pushReplacementNamed(context, '/Dashboard');
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    getServices();
  }

  getServices() {
    final dbref = FirebaseDatabase.instance
        .reference()
        .child("BasicDetails")
        .child(uid)
        .child('Services');
    return dbref.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      services.clear();
      if (snapshot.value != null) {
        values.forEach((key, values) {
          var service = values['Service_Name'];
          services.add(service);
          serviceCheck.add(false);
          serviceKey.add(key);
        });
        setState(() {
          print('my service is $services');
          print('my service length is ${services.length}');
        });
      } else {
        return Container();
      }
      return Container();
    });
  }

  getTimeSchedule(uid) {
    final dbRef = FirebaseDatabase.instance.reference().child("TimeSchedule");
    dbRef.child(uid).child('Sunday').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        setState(() {
          sundayIn.text = values["InTime"];
          sundayOut.text = values["OutTime"];
        });
      });
    });
    dbRef.child(uid).child('Monday').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        setState(() {
          mondayIn.text = values["InTime"];
          mondayOut.text = values["OutTime"];
        });
      });
    });
    dbRef.child(uid).child('Tuesday').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        setState(() {
          tuesdayIn.text = values["InTime"];
          tuesdayIn.text = values["OutTime"];
        });
      });
    });
    dbRef.child(uid).child('Wednesday').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        setState(() {
          wedIn.text = values["InTime"];
          wedIn.text = values["OutTime"];
        });
      });
    });
    dbRef.child(uid).child('Thursday').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        setState(() {
          thursIn.text = values["InTime"];
          thursOut.text = values["OutTime"];
        });
      });
    });
    dbRef.child(uid).child('Friday').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        setState(() {
          fridayIn.text = values["InTime"];
          fridayOut.text = values["OutTime"];
        });
      });
    });
    dbRef.child(uid).child('Saturday').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        setState(() {
          satIn.text = values["InTime"];
          satOut.text = values["OutTime"];
        });
      });
    });
  }

  WorkingHours() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: sunday,
                onChanged: (bool newValue) {
                  setState(() {
                    sunday = newValue;
                  });
                },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
              ),
              Text('Sunday',
                  style: TextStyle(fontFamily: "Righteous", fontSize: 15)),
            ],
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('In Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          enabled: sunday,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: sundayIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      alignment: Alignment.bottomLeft,
                      child: Text('Out Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: sunday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: sundayOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: monday,
                onChanged: (bool newValue) {
                  setState(() {
                    monday = newValue;
                  });
                },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
              ),
              Text('Monday',
                  style: TextStyle(fontFamily: "Righteous", fontSize: 15)),
            ],
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('In Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: monday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: mondayIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      alignment: Alignment.bottomLeft,
                      child: Text('Out Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: monday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: mondayOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: tuesday,
                onChanged: (bool newValue) {
                  setState(() {
                    tuesday = newValue;
                  });
                },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
              ),
              Text('Tuesday',
                  style: TextStyle(fontFamily: "Righteous", fontSize: 15)),
            ],
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('In Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: tuesday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: tuesdayIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      alignment: Alignment.bottomLeft,
                      child: Text('Out Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: tuesday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: tuesdayOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: wednesday,
                onChanged: (bool newValue) {
                  setState(() {
                    wednesday = newValue;
                  });
                },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
              ),
              Text('Wednesday',
                  style: TextStyle(fontFamily: "Righteous", fontSize: 15)),
            ],
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('In Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: wednesday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: wedIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      alignment: Alignment.bottomLeft,
                      child: Text('Out Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: wednesday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: wedOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: thursday,
                onChanged: (bool newValue) {
                  setState(() {
                    thursday = newValue;
                  });
                },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
              ),
              Text('Thursday',
                  style: TextStyle(fontFamily: "Righteous", fontSize: 15)),
            ],
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('In Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: thursday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: thursIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      alignment: Alignment.bottomLeft,
                      child: Text('Out Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: thursday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: thursOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: friday,
                onChanged: (bool newValue) {
                  setState(() {
                    friday = newValue;
                  });
                },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
              ),
              Text('Friday',
                  style: TextStyle(fontFamily: "Righteous", fontSize: 15)),
            ],
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('In Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: friday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: fridayIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      alignment: Alignment.bottomLeft,
                      child: Text('Out Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: friday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: fridayOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: saturday,
                onChanged: (bool newValue) {
                  setState(() {
                    saturday = newValue;
                  });
                },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
              ),
              Text('Saturday',
                  style: TextStyle(fontFamily: "Righteous", fontSize: 15)),
            ],
          ),
        ),
        Container(
          height: 60,
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 8),
                      child: Text('In Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: saturday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: satIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      alignment: Alignment.bottomLeft,
                      child: Text('Out Time'),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey[300],
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          enabled: saturday,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  0:00',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          controller: satOut,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  createWorker() {
    final DatabaseReference database = FirebaseDatabase.instance.reference().child('Workers');
    setState(() {
      newkey = database.child(uid).push().key;
    });
    print('new key is $newkey');
    database.child(uid).child(newkey).set({
      "Worker_Name": workerName.text,
      "Worker_Contact": workerContact.text,

    }).then((value) {
      final DatabaseReference dataBase = FirebaseDatabase.instance.reference().child('Workers').child(uid);
      for (var i = 0; i <= selectedServices.length - 1; i++) {
        dataBase.child(newkey).child('Services').child(i.toString()).set({
          "service_id": selectedServiceKey[i],
          "Service_Name": selectedServices[i],
        });
      }
      createSchedule(newkey);
      ShowSuccessAlert();
    });
  }

  createSchedule(String newkey){
    final DatabaseReference database = FirebaseDatabase.instance.reference().child('Workers').child(uid)
        .child(newkey).child("WorkingHours");
    if(sunday == true){
      database.child('Sunday').set({
        "InTime" : sundayIn.text,
        "OutTime" : sundayOut.text,
      });
    }
    if(monday == true){
      database.child('Monday').set({
        "InTime" : mondayIn.text,
        "OutTime" : mondayOut.text,
      });
    }
    if(tuesday == true){
      database.child('Tuesday').set({
        "InTime" : tuesdayIn.text,
        "OutTime" : tuesdayOut.text,
      });
    }
    if(wednesday == true){
      database.child('Wednesday').set({
        "InTime" : wedIn.text,
        "OutTime" : wedOut.text,

      });
    }
    if(thursday == true){
      database.child('Thursday').set({
        "InTime" : thursIn.text,
        "OutTime" : thursOut.text,

      });
    }
    if(friday == true){
      database.child('Friday').set({
        "InTime" : fridayIn.text,
        "OutTime" : fridayOut.text,

      });
    }

    if(saturday == true){
      database.child('Saturday').set({
        "InTime" : satIn.text,
        "OutTime" : satOut.text,
      });
    }

    print('Added Schedule');
    ShowSuccessAlert();
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
                  Text("Worker Added Successfully"),
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
                            Navigator.pushReplacementNamed(context, '/Workers');
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

  DisplayServices() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: services.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 10, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: serviceCheck[index],
                onChanged: (bool newValue) {
                  setState(() {
                    serviceCheck[index] = newValue;

                    if (serviceCheck[index] == true) {
                      selectedServices.add(services[index]);
                      selectedServiceKey.add(serviceKey[index]);
                      print('selected services is $selectedServices');
                    } else {
                      selectedServices.remove(services[index]);
                      selectedServiceKey.remove(serviceKey[index]);
                      print('selected services is $selectedServices');
                    }
                  });
                },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
              ),
              Text('${services[index]}',
                  style: TextStyle(fontFamily: "Righteous", fontSize: 15)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Workers',
              style: TextStyle(
                fontFamily: "Righteous",
                fontSize: 20,
                fontWeight: FontWeight.w100,
                color: Colors.white,
              )),
          backgroundColor: Color.fromRGBO(88, 187, 71, 1),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15),
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  createWorker();
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/profile.png'),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    color: Colors.grey[300],
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Staff Name",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      controller: workerName,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 13),
                    color: Colors.grey[300],
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Contact No.",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      controller: workerContact,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35),
                    height: 40,
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: DisplayServices(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35),
                    height: 40,
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        'Working Hours',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  WorkingHours(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
