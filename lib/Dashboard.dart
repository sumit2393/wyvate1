import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wyvate1/ProfileScreen.dart';
import 'main.dart';
import 'WorkersListScreen.dart';

class Dashboard extends StatefulWidget {
  Dashboard({this.UID});
  String UID;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    inputData();
  }

  void inputData() async {
    await _auth.currentUser().then((FirebaseUser user) {
      if (user != null) {
        setState(() {
          uid = user.uid;
        });

        print('uid is $uid');
      } else {
        print('uid not found');
      }
    });

    // here you write the codes to input the data into firestore
  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      WorkersListScreen(),
      Center(
        child: Text('screen2'),
      ),

      ProfileScreen(),
    ];

    return Scaffold(
      key: scaffoldKey,
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.green,
            ),
            title: Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              color: Colors.green,
            ),
            title: Text('Sales'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.dashboard,
                color: Colors.green
            ),
            title: Text('More'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(88, 187, 71, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
