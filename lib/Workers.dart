import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Workers extends StatefulWidget {
  Workers({this.UID});
  String UID;
  @override
  _WorkersState createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  final dbRef =
      FirebaseDatabase.instance.reference().child("Workers").child(uid);

  List<dynamic> lists = [];
  List<dynamic> workerID = [];
  Future<bool> _onBackPressed() {
    Navigator.pushReplacementNamed(context, '/Dashboard');
  }

  fetchAllWorkers() {
    return FutureBuilder(
      future: dbRef.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          if (snapshot.data.value != null) {
            lists.clear();
            workerID.clear();

            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              lists.add(values);
              workerID.add(key);
            });
            print('list of length is ${lists.length}');
            print('key value is ${workerID[0]}');
            return DisplayWorkerList();
          } else {
            print('no data found');
            return Container();
          }
        }
      },
    );
  }

  deleteWorker(workerId) {
    final DatabaseReference database = FirebaseDatabase.instance
        .reference()
        .child('Workers')
        .child(uid)
        .child(workerId);
    database.remove();
  }

  DisplayWorkerList() {
    return new ListView.builder(
        shrinkWrap: true,
        itemCount: lists.length,
        itemBuilder: (BuildContext context, int index) {
          String name = lists[index]["Worker_Name"];
          String contact = lists[index]["Worker_Contact"];

          return Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width / 4.1,
                            child: Text(
                              '$name',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Righteous",
                                  fontWeight: FontWeight.w100),
                            )),
                        Container(
                            margin: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Text(
                              '${contact}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Righteous",
                                  fontWeight: FontWeight.w100),
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 15,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                workerId = workerID[index];
                              });
                              Navigator.pushReplacementNamed(
                                  context, '/EditWorker');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                workerId = workerID[index];
                              });

                              deleteWorker(workerId);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Staff Members',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Righteous",
                  fontWeight: FontWeight.bold)),
          backgroundColor: Color.fromRGBO(88, 187, 71, 1),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  fetchAllWorkers(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(88, 187, 71, 1),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/AddWorker');
          },
        ),
      ),
    );
  }
}
