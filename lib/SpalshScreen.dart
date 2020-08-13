import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
 
  @override
  void initState() {

    super.initState();
    inputData();
    Timer(Duration(seconds: 3), () async {
      
        
       



    }

    );

  }
void inputData() async {
    final FirebaseUser User = await _auth.currentUser().then((FirebaseUser user){
         
        if(user!=null){
          setState(() {
          uid  = user.uid;
        
          
          });
      Navigator.pushReplacementNamed(context, '/Dashboard');
      
        }else{
        Navigator.pushReplacementNamed(context, '/login');
        }
    });
    

    // here you write the codes to input the data into firestore
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color:Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image(
                          image: AssetImage('assets/logo.png'),
                          width: 300.0,
                        ),


                      ),



                    ],
                  ),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}