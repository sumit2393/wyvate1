import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wyvate1/calender.dart';

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

  Stream<Event> _workersFuture;
  @override
  void initState() {
    getSharedPrefs().then((value) async {
      _workersFuture = FirebaseDatabase.instance.reference().child("Workers").child(userId).onValue;
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
          style: TextStyle(fontSize: 20, fontFamily: "OpenSans Bold", color: Colors.white),
        ),
        leading: Container(),
        backgroundColor: Color.fromRGBO(88, 187, 71, 1),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _workersFuture,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            print("map: "+map.toString());
            print("map.length: "+map.length.toString());

            return ListView.builder(
              itemCount: map.length,
              padding: EdgeInsets.all(2.0),
              itemBuilder: (BuildContext context, int index) {

                return ListTile(
                  title: Text(map.values.toList()[index]["Worker_Name"]),
                  onTap: (){

                     Navigator.of(context).push(
                         new MaterialPageRoute(
                             builder: (context)=> Calender(
                               worker_name: map.values.toList()[index]["Worker_Name"],
                               worker_id: map.values.toList()[index].toString()
                             )
                         )
                     );

                  },
                );
              },
            );

          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
