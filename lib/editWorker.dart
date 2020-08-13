import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';
class EditWorker extends StatefulWidget {
  EditWorker({this.workerID});
  String workerID;
  @override
  _EditWorkerState createState() => _EditWorkerState();
}

class _EditWorkerState extends State<EditWorker> {
  bool sunday = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
   
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
  final workerName= TextEditingController();
  final workerContact= TextEditingController();
  List<String> services =[];
  List<String> selectedServices =[];
  List<String> selectedKey =[];
  List<dynamic> keydata =[];
  List<bool> serviceCheck =[];
final FirebaseAuth _auth = FirebaseAuth.instance;
   Future<bool> _onBackPressed(){
    Navigator.pushReplacementNamed(context, '/Dashboard');
  }
  void initState() {
    // TODO: implement initState
    super.initState();
   getTimeSchedule(uid);
   getWorkerData();
   getServices();
  }

  

 getServices(){
   final dbref = FirebaseDatabase.instance.reference().child("BasicDetails").child(uid).child('Services');

   dbref.once().then((DataSnapshot snapshot){
    Map<dynamic,dynamic> values = snapshot.value;
    services.clear();
    keydata.clear();
    serviceCheck.clear();
    if(snapshot.value !=null){
       values.forEach((key, values) {
         var service_name = values["Service_Name"];
        
      final dbref1 = FirebaseDatabase.instance.reference().child("Workers").child(uid).child(workerId).child('Services').orderByChild('service_id').equalTo(key);
     
     dbref1.once().then((DataSnapshot snapshot1){
       Map<dynamic,dynamic> values1 = snapshot1.value;

         if(snapshot1.value !=null){

           services.add(service_name);
           serviceCheck.add(true);
           selectedServices.add(service_name);
           selectedKey.add(key);
           keydata.add(key);
           print('service included : $services');
           print('service condition : $serviceCheck');
         }else{
            services.add(service_name);
           serviceCheck.add(false);
           keydata.add(key);
           print('service not included : $services');
           print('service false condition : $serviceCheck');
         }
         setState((){

       });
     });

       });
       
    }else{
      return Container();
    }

   });
 }

  getWorkerData(){
     final dbRef = FirebaseDatabase.instance.reference().child("Workers").child(uid).child(workerId);
     dbRef.once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;

      if(snapshot.value !=null){
    values.forEach((key, value) {
      setState(() {
        workerName.text = values["Worker_Name"];
        workerContact.text = values["Worker_Contact"];
      });
    
    });
      }
  });
  }
  
  getTimeSchedule(uid){
    final dbRef = FirebaseDatabase.instance.reference().child("TimeSchedule");
  dbRef.child(uid).child('Sunday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
      setState(() {
        sundayIn.text = values["InTime"];
        sundayOut.text = values["OutTime"];
      });
        
    });
   });
    dbRef.child(uid).child('Monday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
      if(snapshot.value !=null){
    values.forEach((key, value) {
       setState(() {
        mondayIn.text = values["InTime"];
        mondayOut.text = values["OutTime"];
      });
    });
      }
   });
    dbRef.child(uid).child('Tuesday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
      if(snapshot.value !=null){
    values.forEach((key, value) {
     setState(() {
        tuesdayIn.text = values["InTime"];
       tuesdayIn.text = values["OutTime"];
      });
    });
      }
   });
    dbRef.child(uid).child('Wednesday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
      if(snapshot.value !=null){
    values.forEach((key, value) {
     setState(() {
        wedIn.text = values["InTime"];
        wedIn.text = values["OutTime"];
      });
    });
      }
   });
    dbRef.child(uid).child('Thursday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
      if(snapshot.value !=null){
    values.forEach((key, value) {
       setState(() {
        thursIn.text = values["InTime"];
        thursOut.text = values["OutTime"];
      });
    });
      }
   });
    dbRef.child(uid).child('Friday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
      if(snapshot.value !=null){
    values.forEach((key, value) {
       setState(() {
        fridayIn.text = values["InTime"];
        fridayOut.text = values["OutTime"];
      });
    });
      }
   });
    dbRef.child(uid).child('Saturday').once().then((DataSnapshot snapshot){
      Map<dynamic , dynamic> values = snapshot.value;
      if(snapshot.value !=null){
    values.forEach((key, value) {
           setState(() {
        satIn.text = values["InTime"];
        satOut.text = values["OutTime"];
      });
    });
      }
   });

  }
  WorkingHours(){
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
                  margin: EdgeInsets.all(10),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('In Time'),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                           enabled: sunday,
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  
                    
                  ),
                  
                  controller: sundayIn,
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
                          child:Text('Out Time'),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                     enabled: sunday,
                     textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                   border: InputBorder.none,
                  hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
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
                  margin: EdgeInsets.all(10),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('In Time'),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                   enabled: monday,
                   textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  
                    
                  ),
                  controller:mondayIn,
                  
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
                          child:Text('Out Time'),

                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                            enabled: monday,
                           textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                   border: InputBorder.none,
                 hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
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
                  margin: EdgeInsets.all(10),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('In Time'),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                 enabled: tuesday,
                 textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                     border: InputBorder.none,
                   hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  
                    
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
                          child:Text('Out Time'),

                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                   enabled: tuesday,
                   textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                   border: InputBorder.none,
                 hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
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
                  margin: EdgeInsets.all(10),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('In Time'),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                    enabled: wednesday,
                    textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  
                    
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
                          child:Text('Out Time'),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                    enabled: wednesday,
                    textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                   border: InputBorder.none,
                   hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
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
                  margin: EdgeInsets.all(10),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('In Time'),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                 enabled: thursday,
                 textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                     border: InputBorder.none,
                     hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  
                    
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
                          child:Text('Out Time'),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                 enabled: thursday,
                 textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                   border: InputBorder.none,
                  hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
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
                  margin: EdgeInsets.all(10),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('In Time'),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                 enabled: friday,
                 textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  
                    
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
                          child:Text('Out Time'),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                 enabled: friday,
                 textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                   border: InputBorder.none,
                  hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
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
                  margin: EdgeInsets.all(10),
                  width:MediaQuery.of(context).size.width,
                  
                  child: Row(children: <Widget>[
                   Expanded(
                     child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(left:8),
                          child:Text('In Time'),
                        ),
                        Expanded(
                          child:Container(
                            color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                 enabled: saturday,
                 textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  
                    
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
                          child:Text('Out Time'),
                        ),
                        Expanded(
                          child:Container(
                             color: Colors.grey[300],
                            margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                           
                         enabled: saturday,
                         textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                  decoration: InputDecoration(
                   border: InputBorder.none,
                   hintText: '  0:00',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
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
  editWorker(){
   final DatabaseReference database = FirebaseDatabase.instance.reference().child('Workers').child(uid).child(workerId);
   
   database.child('Services').remove().then((value){
        for(var i=0;i<=selectedServices.length-1;i++){
   database.child('Services').push().set({
     "Service_Name": selectedServices[i],
     "service_id" : selectedKey[i],
   });
   
    }
   });
   
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
                 
                  
               Text("Details Updated Successfully"),

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
                                 Navigator.pushReplacementNamed(context, '/Workers');
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
 DisplayServices(){
   return ListView.builder(
     shrinkWrap: true,
     itemCount: services.length,
     itemBuilder: (context,index){
       return  Container(
                margin: EdgeInsets.only(left:10,top:8),
                 child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                 value: serviceCheck[index],
      onChanged: (bool newValue) {
        setState(() {

          serviceCheck[index] = newValue;

          if(serviceCheck[index] == true){
            selectedServices.add(services[index]);
            selectedKey.add(keydata[index]);
            print('selected services is $selectedServices');

          }else{
            selectedServices.remove(services[index]);
            selectedKey.remove(keydata[index]);
            print('selected services is $selectedServices');
          }
        });
      },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
            ),
                Text('${services[index]}',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
        ),
        

                );
     },
   );
 }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Worker',style:TextStyle(fontFamily: "Righteous",fontSize: 20,fontWeight: FontWeight.w100,color:Colors.white,)),
        backgroundColor:Color.fromRGBO(88, 187, 71, 1),
         actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right:15),
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: (){
                  editWorker();
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 130,
                    height:130,
                    decoration: BoxDecoration(
                      shape : BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/profile.png'),
                      ),
                    ),
                  ),

                   Container(
                   margin: EdgeInsets.only(left:15,right:15),
                   color: Colors.grey[300],
                   child: TextFormField(
                     style: TextStyle(fontSize: 19, fontFamily: "Righteous", fontWeight: FontWeight.w100),
                                   textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "Staff Name",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    
                                   
                                  ),
                              
                                  controller: workerName,
                                     
                                      
                                ),
                 ),
                  Container(
                  margin: EdgeInsets.only(left:15,right:15,top:13),
                   color: Colors.grey[300],
                   child: TextFormField(
                      style: TextStyle(fontSize: 19, fontFamily: "Righteous", fontWeight: FontWeight.w100),
                                   textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "Contact No.",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  
                                   
                                  ),
                                  controller: workerContact,
                              keyboardType: TextInputType.number,
                                  
                                  inputFormatters: [
    new LengthLimitingTextInputFormatter(10),
  ],   
                                      
                                ),
                 ),
                 Container(
                   margin: EdgeInsets.only(top:35),
                   height:40,
                   color: Colors.grey,
                   width: MediaQuery.of(context).size.width,
                   child: Container(

                     margin: EdgeInsets.only(left:15,top:10),
                     child:Text('Services',
                     style: TextStyle(
                       fontSize: 15,
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                     ),
                     ),
                   ),
                 ),
                DisplayServices(),
                 
                  Container(
                   margin: EdgeInsets.only(top:35),
                   height:40,
                   color: Colors.grey,
                   width: MediaQuery.of(context).size.width,
                   child: Container(

                     margin: EdgeInsets.only(left:15,top:10),
                     child:Text('Working Hours',
                     style: TextStyle(
                       fontSize: 15,
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                     ),
                     ),
                   ),
                 ),

                 WorkingHours(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}