import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkersListScreen extends StatefulWidget {
  @override
  _WorkersListScreenState createState() => _WorkersListScreenState();
}

class _WorkersListScreenState extends State<WorkersListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String userId="";
  Future<bool> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("userId");
    setState(() {
      userId = user_id;
    });

    return true;
  }

  Stream<dynamic> _workersFuture;
  @override
  void initState() {
    getSharedPrefs().then((value) async {
      _workersFuture = await FirebaseDatabase.instance.reference().child("Workers").child(userId).onValue;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Select Worker',
          style: TextStyle(
              fontSize: 20, fontFamily: "OpenSans Bold", color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(88, 187, 71, 1),
      ),
      body: StreamBuilder(
        stream: _workersFuture,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

            return ListView.builder(
              itemCount: map.values.toList().length,
              padding: EdgeInsets.all(2.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Image.network(
                    map.values.toList()[index]["Worker_Name"],
                    fit: BoxFit.cover,
                  ),
                  padding: EdgeInsets.all(2.0),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
