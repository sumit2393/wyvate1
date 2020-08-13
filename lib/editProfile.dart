
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main.dart';
class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
   final businessName = TextEditingController();
   final businessEmail = TextEditingController();
    final businessAddress = TextEditingController();
     final businessContact = TextEditingController();
     final businessDescription = TextEditingController();
     final businessWebsite = TextEditingController();
      final city = TextEditingController();
  final state = TextEditingController();
  final pincode = TextEditingController();
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
   final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  var Latitude;
  var Longitude;
     @override
  void initState() {
    // TODO: implement initState
    super.initState();
  
    getprofileData();
     requestLocationPermission();
   _getCurrentLocation();
  }


Future<bool> _requestPermission(PermissionGroup permission) async {
final PermissionHandler _permissionHandler = PermissionHandler();
var result = await _permissionHandler.requestPermissions([permission]);
if (result[permission] == PermissionStatus.granted) {
  return true;
}
return false;
}
Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
var granted = await _requestPermission(PermissionGroup.location);
if (granted!=true) {
  requestLocationPermission();
}
debugPrint('requestContactsPermission $granted');
return granted;
}
 void _getCurrentLocation() async {
   
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
   setState((){
   Latitude = position.latitude;
   Longitude = position.longitude;

   });
   _getAddressFromLatLng();
  }

    _getAddressFromLatLng() async {
    try {
      

     
    final coordinates = new Coordinates(Latitude, Longitude);
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        setState((){
          businessAddress.text = first.addressLine;
          city.text = first.locality;
          state.text = first.adminArea;
          pincode.text = first.postalCode;
        });
       
     
    } catch (e) {
      print(e);
    }
  }
   getprofileData(){
    final dbRef = FirebaseDatabase.instance.reference().child("BasicDetails");
    return dbRef.child(uid).once().then((DataSnapshot snapshot){
     Map<dynamic , dynamic> values = snapshot.value;
    values.forEach((key, value) {
      setState((){
        
        businessContact.text = values["Merchant_Contact"].toString();
        businessName.text = values["Business_Name"];
      
      businessAddress.text = values["Merchant_Address"]; 
      businessEmail.text = values["Merchant_Email"];
       businessDescription.text = values["Business_Description"];
      businessWebsite.text = values["Business_Website"];

      });
      print('business contact is $businessContact');
      
    });
    });
  }

  updateProfile(){
    
   final DatabaseReference database = FirebaseDatabase.instance.reference().child('BasicDetails').child(uid);
  database.update({
   "Business_Name": businessName.text,
   "Merchant_Email": businessEmail.text,
   "Merchant_Address" : businessAddress.text,
   "Business_Description": businessDescription.text,
   "Business_Website": businessWebsite.text,
   "City":city.text,
   "State": state.text,
   "Pincode": pincode.text,

  }).then((value){
   print('updated Sucessfully');
    ShowSuccessAlert();
  });
  }
   Future<bool> _onBackPressed(){
    Navigator.pushReplacementNamed(context, '/Dashboard');
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
                 
                  
               Text("Profile Updated Successfully"),

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
  @override
  Widget build(BuildContext context) {
    return 
    WillPopScope(
      onWillPop: _onBackPressed,
    child:Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',style:TextStyle(fontFamily: "Righteous",color:Colors.white)),
        backgroundColor: Color.fromRGBO(88, 187, 71, 1),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height/1.2,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
               Center(
                 child: Container(
                   margin: EdgeInsets.only(top:10),
                   width: 180,
                   height:180,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     
                     image: DecorationImage(
                       image: AssetImage('assets/profile.png'),
                       fit: BoxFit.cover,
                     ),
                   ),
                 ),
               ),
                 Container(
                   margin: EdgeInsets.all(15),
                   child: TextFormField(
                                  style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),
                                  decoration: InputDecoration(
                                    hintText: "Business Name",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                     enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                controller: businessName, 
                                  
                                     
                                      
                                ),
                 ),
                 Container(
                   margin: EdgeInsets.all(15),
                   child: TextFormField(
                                  style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),
                                  decoration: InputDecoration(
                                    hintText: "Description",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                 
                                  controller:businessDescription,
                                     
                                      
                                ),
                 ),
                 Container(
                   margin: EdgeInsets.all(15),
                   child: TextFormField(
                             style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),     
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                 
                                  controller: businessEmail,
                                     
                                      
                                ),
                 ),
                 Container(
                  margin: EdgeInsets.all(15),
                   child: TextFormField(
                               style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),   
                                  decoration: InputDecoration(
                                    hintText: "Website",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                 
                                  controller: businessWebsite,
                                     
                                      
                                ),
                 ),
                 Container(
                   margin: EdgeInsets.all(15),
                   child: TextFormField(
                        style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),
                                  
                                  decoration: InputDecoration(
                                    hintText: "Contact",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                 
                               controller: businessContact,
                                     
                                      
                                ),
                 ),
                 Container(
                  margin: EdgeInsets.all(15),
                   child: TextFormField(
                                style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),  
                                  decoration: InputDecoration(
                                    hintText: "Address",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                 
                                  controller: businessAddress,
                                     
                                      
                                ),
                 ),
                  Container(
                  margin: EdgeInsets.all(15),
                   child: TextFormField(
                                style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),  
                                  decoration: InputDecoration(
                                    hintText: "City",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                 
                                  controller: city,
                                     
                                      
                                ),
                 ),
                  Container(
                  margin: EdgeInsets.all(15),
                   child: TextFormField(
                                style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),  
                                  decoration: InputDecoration(
                                    hintText: "State",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                 
                                  controller: state,
                                     
                                      
                                ),
                 ),
                  Container(
                  margin: EdgeInsets.all(15),
                   child: TextFormField(
                                style: TextStyle(color: Colors.black,fontFamily: "Righteous", fontSize: 18, fontWeight: FontWeight.w100),  
                                  decoration: InputDecoration(
                                    hintText: "Pin",
                                    
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(      
	                                  borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),   
	                                ),  
                                       focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(88, 187, 71, 1)),
                      ),  
                                   
                                  ),
                                 
                                  controller: pincode,
                                     
                                      
                                ),
                 ),
                
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        
        width: MediaQuery.of(context).size.width,
        child:FloatingActionButton.extended(
          backgroundColor: Color.fromRGBO(88, 187, 71, 1),
          onPressed: (){
            updateProfile();
            },
          label: Text('Update Profile',style:TextStyle(fontWeight: FontWeight.bold,fontFamily: "OpenSans")),
         shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(0),

),
          ),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ),
    );
  }
}