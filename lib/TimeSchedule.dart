import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'main.dart';
class TimeSchedule extends StatefulWidget {
  TimeSchedule({this.UID});
  String UID;
  @override
  _TimeScheduleState createState() => _TimeScheduleState();
}

class _TimeScheduleState extends State<TimeSchedule> {

  bool sunday = true;
  bool monday = true;
  bool tuesday = true;
  bool wednesday = true;
  bool thursday = true;
  bool friday = true;
  bool saturday = true;
  
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
  final satOut= TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState(){

    super.initState();
  
    inputData();
    getTimeSchedule(uid);
   
  }

inputData(){
  print('uid is $uid');
}
  List<String> suggestions =[
  "12:00 AM",
  "1:00 AM",
  "2:00 AM",
  "3:00 AM",
  "4:00 AM",
  "5:00 AM",
  "6:00 AM",
  "7:00 AM",
  "8:00 AM",
  "9:00 AM",
  "10:00 AM",
  "11:00 AM",
  "12:00 PM",
  "1:00 PM",
  "2:00 PM",
  "3:00 PM",
  "4:00 PM",
  "5:00 PM",
  "6:00 PM",
  "7:00 PM",
  "8:00 PM",
  "9:00 PM",
  "10:00 PM",
  "11:00 PM",
 
  ];
  getTimeSchedule(uid){
    final dbRef = FirebaseDatabase.instance.reference().child("TimeSchedule");
  dbRef.child(uid).child('Sunday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
      if(mounted){
        setState(() {
        sundayIn.text = values["InTime"];
        sundayOut.text = values["OutTime"];
      });
      }
        
    });
   });
    dbRef.child(uid).child('Monday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
       if(mounted){
       setState(() {
        mondayIn.text = values["InTime"];
        mondayOut.text = values["OutTime"];
      });
       }
    });
   });
    dbRef.child(uid).child('Tuesday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
       if(mounted){
     setState(() {
        tuesdayIn.text = values["InTime"];
       tuesdayOut.text = values["OutTime"];
      });
       }
    });
   });
    dbRef.child(uid).child('Wednesday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
       if(mounted){
     setState(() {
        wedIn.text = values["InTime"];
        wedOut.text = values["OutTime"];
      });
       }
    });
   });
    dbRef.child(uid).child('Thursday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
       if(mounted){
       setState(() {
        thursIn.text = values["InTime"];
        thursOut.text = values["OutTime"];
      });
       }
    });
   });
    dbRef.child(uid).child('Friday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
       if(mounted){
       setState(() {
        fridayIn.text = values["InTime"];
        fridayOut.text = values["OutTime"];
      });
       }
    });
   });
    dbRef.child(uid).child('Saturday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
       if(mounted){
           setState(() {
        satIn.text = values["InTime"];
        satOut.text = values["OutTime"];
      });
       }
    });
   });
return Container();
  }
  createSchedule(){
   final DatabaseReference database = FirebaseDatabase.instance.reference().child('TimeSchedule').child(uid);
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
 ShowSuccessAlert(){
   showDialog(
      
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
       
        return new AlertDialog(
          content: new SingleChildScrollView(
           
              child: Container(

                child: Column(
                children: <Widget>[
                 
                  
               Text("Operating Hours Updated Successfully"),

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
                                 Navigator.pushReplacementNamed(context, '/Dashboard');
                               },
                              ),
                            ),
                            const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                        ),
                           
                          ],
                        ),
                ],

              )
            
          ),
         
        ),
    );
  }
    );
 }
copyData(text){
  print('sunday in time is ${sundayIn.text}');
  print('sunday out time is ${sundayOut.text}');
setState(() {
   sundayOut.text = text;
    mondayIn.text = sundayIn.text;
    mondayOut.text = sundayOut.text;
    tuesdayIn.text = sundayIn.text;
    tuesdayOut.text = sundayOut.text;
    wedIn.text = sundayIn.text;
    wedOut.text = sundayOut.text;
    thursIn.text = sundayIn.text;
    thursOut.text = sundayOut.text;
    fridayIn.text = sundayIn.text;
    fridayOut.text = sundayOut.text;
    satIn.text = sundayIn.text;
    satOut.text = sundayOut.text;
    monday = true;
    tuesday = true;
    wednesday = true;
    thursday = true;
    friday = true;
    saturday = true;

  });
  Navigator.pop(context);
  print('sunday out time is ${mondayOut.text}');
}
 CopyDataAlert(text){
   showDialog(
      
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
       
        return new AlertDialog(
          content: new SingleChildScrollView(
           
              child: Container(

                child: Column(
                children: <Widget>[
                 
                  
               Text("Copy Data to All ?"),

                const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: RaisedButton(
                               child: Text('Yes'),
                               onPressed: () {
                                copyData(text);
                               },
                              ),
                            ),
                            const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),

                        ),
                           Container(
                              child: RaisedButton(
                               child: Text('No'),
                               onPressed: () {
                                 Navigator.pop(context);
                               },
                              ),
                            ),
                          ],
                        ),
                ],

              )
            
          ),
         
        ),
    );
  }
    );
 }
  Future<bool> _onBackPressed(){
    Navigator.pushReplacementNamed(context, '/Dashboard');
  }


  timeScheduleBody(){
    return Column(
              children: <Widget>[
                
                Container(
                margin: EdgeInsets.only(left:10,top:8),
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
                Text('Sunday',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
        ),
        

                ),
                
                    
                
                Container(
                  height:60,
                  margin: EdgeInsets.all(20),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('Opening Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                             keyboardType: TextInputType.number,
                            style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: sundayIn,
                  textChanged: (text)=>sundayIn.text = text,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                   SizedBox(
                     width:9,
                   ),
                    Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:8),
                          alignment: Alignment.bottomLeft,
                          
                          child:Text('Closing Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                         style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                          
                           textSubmitted: (text)=> CopyDataAlert(text),
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                   controller: sundayOut,
                  
                   
                    
                   
                  
                 
                 
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                  ],),
                ),
                
                
                 Container(
                margin: EdgeInsets.only(left:10,top:8),
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
                Text('Monday',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
        ),
        

                ),
                 Container(
                  height:60,
                  margin: EdgeInsets.all(20),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('Opening Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                          style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: mondayIn,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                   SizedBox(
                     width:9,
                   ),
                    Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:8),
                          alignment: Alignment.bottomLeft,
                          child:Text('Closing Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),

                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: mondayOut,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                  ],),
                ),
                Container(
                margin: EdgeInsets.only(left:10,top:8),
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
                Text('Tuesday',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
        ),
        

                ),
                 Container(
                  height:60,
                  margin: EdgeInsets.all(20),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                         child:Text('Opening Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: tuesdayIn,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                   SizedBox(
                     width:9,
                   ),
                    Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:8),
                          alignment: Alignment.bottomLeft,
                          child:Text('Closing Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),

                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                          style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: tuesdayOut,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                  ],),
                ),
                Container(
                margin: EdgeInsets.only(left:10,top:8),
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
                Text('Wednesday',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
        ),
        

                ),
                 Container(
                  height:60,
                  margin: EdgeInsets.all(20),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('Opening Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: wedIn,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                   SizedBox(
                     width:9,
                   ),
                    Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:8),
                          alignment: Alignment.bottomLeft,
                         child:Text('Closing Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: wedOut,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                  ],),
                ),
                 Container(
                margin: EdgeInsets.only(left:10,top:8),
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
                Text('Thursday',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
        ),
        

                ),
                 Container(
                  height:60,
                  margin: EdgeInsets.all(20),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('Closing Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: thursIn,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                   SizedBox(
                     width:9,
                   ),
                    Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:8),
                          alignment: Alignment.bottomLeft,
                          child:Text('Closing Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: thursOut,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                  ],),
                ),
                 Container(
                margin: EdgeInsets.only(left:10,top:8),
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
                Text('Friday',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
        ),
        

                ),
                 Container(
                  height:60,
                  margin: EdgeInsets.all(20),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('Opening Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child:SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: fridayIn,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                   SizedBox(
                     width:9,
                   ),
                    Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:8),
                          alignment: Alignment.bottomLeft,
                          child:Text('Closing Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child:SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: fridayOut,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                  ],),
                ),
                 Container(
                margin: EdgeInsets.only(left:10,top:8),
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
                Text('Saturday',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
        ),
        

                ),
                 Container(
                  height:60,
                  margin: EdgeInsets.all(20),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('Opening Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: satIn,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                   SizedBox(
                     width:9,
                   ),
                    Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left:8),
                          alignment: Alignment.bottomLeft,
                          child:Text('Closing Time', style: TextStyle(fontSize: 12, fontFamily: "Open Sans")),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                           style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                           suggestions: suggestions,
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                  
                  controller: satOut,
                          ),
                        ),
                        ),
                      ],
                    ),
                   ),
                  ],),
                ),
              ],
            );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
      appBar: AppBar(
        title: Text('Operational Hour'),
        backgroundColor: Color.fromRGBO(88, 187, 71, 1),
        actions: <Widget>[
    Container(
      margin: EdgeInsets.only(left:30,right: 50),
      child:IconButton(
      icon: Icon(
        Icons.check,
        color: Colors.white,
        size: 40,
      ),
      onPressed: () {
        createSchedule();
      },
    ),
    ),
  ],
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: timeScheduleBody(),
          ),
        ),
      ),
      ),
    );
  }
}