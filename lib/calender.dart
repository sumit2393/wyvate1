import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';
import 'package:wyvate1/NewAppointment.dart';

class Calender extends StatefulWidget {
  Calender({this.worker_name, this.worker_id});
  String worker_name, worker_id;

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  FirebaseUser user;
  TimetableController<BasicEvent> _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  DateTime _dateTime;

  List<BasicEvent> eventsList;
  EventProvider<BasicEvent> myEventProvider;

  String userId="";
  Future<bool> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("userId");
    setState(() {
      userId = user_id;
    });

    return true;
  }


  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();

    getSharedPrefs().then((value) async {
      await FirebaseDatabase.instance.reference().child("Appointments").child(userId).once().then((dataSnapshot){

        print("dataSnapshot: "+dataSnapshot.value.toString());



      });
    });

    eventsList = new List();
    eventsList.add(new BasicEvent(
      id: 0,
      title: 'Some Event',
      color: Colors.blue,
      start: LocalDate.today().at(LocalTime(18, 0, 0)),
      end: LocalDate.today().at(LocalTime(23, 10, 0)),
    ),);
    myEventProvider = EventProvider.list(eventsList);

    _controller = TimetableController(
      eventProvider: myEventProvider,
      initialDate: LocalDate.dateTime(_dateTime),
      visibleRange: VisibleRange.days(1),
      firstDayOfWeek: DayOfWeek.monday,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: Container(
          color: Color.fromRGBO(88, 187, 71, 1),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              AppBar(
                elevation: 0,
                title: Text(widget.worker_name??"", style: TextStyle(fontSize: 20, fontFamily: "OpenSans Bold", color: Colors.white),),
                backgroundColor: Color.fromRGBO(88, 187, 71, 1),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.today,
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2001),
                        lastDate: DateTime(3001),
                      ).then((date) {
                        setState(() {
                          _dateTime = date;
                        });
                        _controller.animateTo(LocalDate.dateTime(_dateTime));
                      });
                    },
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0, right: 7.0),
                child: Text(
                  '${_dateTime.toString().substring(0, 11)}',
                  style: TextStyle(fontSize: 20, fontFamily: "OpenSans Bold", color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Timetable<BasicEvent>(
        controller: _controller,
        theme: TimetableThemeData(
          partDayEventMinimumDuration: Period(minutes: 60),
        ),
        eventBuilder: (event) {
          return BasicEventWidget(
            event,
            onTap: () => _showSnackBar('Part-day event $event tapped'),
          );
        },
        allDayEventBuilder: (context, event, info) => BasicAllDayEventWidget(
          event,
          info: info,
          onTap: () => _showSnackBar('All-day event $event tapped'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){

          Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (context)=> NewAppointment(
                      worker_name: widget.worker_name,
                      worker_id: widget.worker_id
                  )
              )
          );

        },
      ),
    );
  }

  void _showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }

  Future<FirebaseUser> getCurrentUser() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }

}
