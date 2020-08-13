import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class ProfileApp extends StatefulWidget {
  ProfileApp({this.UID});
  String UID;
  @override
  _ProfileAppState createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String StoreName = "";
  String Address = "";
  String StoreType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofileData();
  }

  getprofileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String store_name = prefs.getString("Business_Name")??"";
    String address = prefs.getString("Merchant_Address")??"";

    setState(() {
      StoreName = store_name;
      Address = address;
    });
  }

  _logOut() async {
    await _auth.signOut().then((_) {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'More Options',
            style: TextStyle(
                fontSize: 20, fontFamily: "OpenSans Bold", color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(88, 187, 71, 1),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: () {
                _logOut();
              },
            ),
          ]),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10),
                    color: Color.fromRGBO(248, 248, 255, 1),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/profile.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 120,
                          height: 120,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2.2,
                                child: Text(
                                  '$StoreName',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: "Righteous",
                                    color: Color.fromRGBO(88, 187, 71, 1),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.2,
                                child: Text(
                                  '$StoreType',
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: "OpenSans"),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.2,
                                alignment: Alignment.bottomLeft,
                                child: RaisedButton(
                                  child: Text('Edit Profile',
                                      style: TextStyle(color: Colors.white)),
                                  color: Color.fromRGBO(88, 187, 71, 1),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/editProfile');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.alarm_on,
                          color: Color.fromRGBO(88, 187, 71, 1),
                        ),
                        title: Text('Operation Hour',
                            style: TextStyle(
                                fontFamily: "Righteous", fontSize: 15)),
                        trailing: Icon(Icons.arrow_right),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/timeschedule');
                  },
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.settings,
                            color: Color.fromRGBO(88, 187, 71, 1)),
                        title: Text('Services',
                            style: TextStyle(
                                fontFamily: "Righteous", fontSize: 15)),
                        trailing: Icon(Icons.arrow_right),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/Services');
                  },
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.group,
                            color: Color.fromRGBO(88, 187, 71, 1)),
                        title: Text('Staff',
                            style: TextStyle(
                                fontFamily: "Righteous", fontSize: 15)),
                        trailing: Icon(Icons.arrow_right),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/Workers');
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.grade,
                          color: Color.fromRGBO(88, 187, 71, 1)),
                      title: Text('Review & Rating',
                          style:
                              TextStyle(fontFamily: "Righteous", fontSize: 15)),
                      trailing: Icon(Icons.arrow_right),
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
}
