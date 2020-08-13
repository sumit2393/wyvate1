import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';



class Calenders extends StatefulWidget {


  @override
  _CalendersState createState() => _CalendersState();
}

class _CalendersState extends State<Calenders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Timetable View Demo'),
      ),
      body: TimetableView(
        timetableStyle: TimetableStyle(startHour: 1, endHour: 24),
        laneEventsList: _buildLaneEvents(),
        
      ),
    );
  }

  List<LaneEvents> _buildLaneEvents() {
    return [
      LaneEvents(
        lane: Lane(name: 'Track A'),
        events: [
          
        ],
      ),
      LaneEvents(
        lane: Lane(name: 'Track B'),
        events: [
          TableEvent(
            title: 'An event 3',
            start: TableEventTime(hour: 10, minute: 10),
            end: TableEventTime(hour: 11, minute: 45),
          ),
        ],
      ),
    ];
  }
}