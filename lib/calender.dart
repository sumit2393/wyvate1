import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';
class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  TimetableController<BasicEvent> _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  DateTime _dateTime;
  final myEventProvider = EventProvider.list([
  BasicEvent(
    id: 0,
    title: 'My Event',
    color: Colors.blue,
    start: LocalDate.today().at(LocalTime(18, 0, 0)),
    end: LocalDate.today().at(LocalTime(18, 10, 0)),
  ),
]);
void initState(){
   _dateTime = DateTime.now();
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
      appBar: AppBar(
        title: Text('${_dateTime.toString().substring(0,11)}', style: TextStyle(fontSize:20, fontFamily: "OpenSans Bold",color:Colors.white),),
         backgroundColor:Color.fromRGBO(88, 187, 71, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today, ),
            
            onPressed: (){
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2001),
                lastDate: DateTime(3001),
              ).then((date){
                setState(() {
                    _dateTime = date;
                     
                });
                  _controller.animateTo(LocalDate.dateTime(_dateTime));
              });
            },
           
          ),
        ],
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
    );
  }

  void _showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }
  }
