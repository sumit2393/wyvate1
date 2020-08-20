import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:wyvate1/Dashboard.dart';
import 'package:wyvate1/OtpScreen.dart';
import 'package:wyvate1/ProfileScreen.dart';
import 'package:wyvate1/verifyOtp.dart';

import 'constants/constants.dart';

const kGoogleApiKey = "AIzaSyAaFQMkUP9m_gO-w8qNtFGJ5V0JJKpMVZ8";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class RegistrationDetails extends StatefulWidget {
  String UID;

  RegistrationDetails({this.UID});

  @override
  _RegistrationDetailsState createState() => _RegistrationDetailsState();
}

class _RegistrationDetailsState extends State<RegistrationDetails> {
  ProgressDialog pr;
  GlobalKey<ScaffoldState> _scaffoldKey;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _keyform1 = GlobalKey<FormState>();
  final businessName = TextEditingController();
  final merchantEmail = TextEditingController();
  final merchantAddress = TextEditingController();
  final businessNature = TextEditingController();
  final password = TextEditingController();
  final confirm_password = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final pincode = TextEditingController();
  final _phoneNumberController = TextEditingController();
  int _currentStep = 0;
  String contact;
  int userid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  String dropdownValue;
  String _locationMessage = "";
  var Latitude;
  var Longitude;
  bool isValid = false;
  GoogleMapController mapController;
  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    dropdownValue = 'Select Nature of Business';
    Latitude = 28.5079552;
    Longitude = 77.3197863;
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
    if (granted != true) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  }

  void _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      Latitude = position.latitude;
      Longitude = position.longitude;
    });
    _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    try {
      final coordinates = new Coordinates(Latitude, Longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      setState(() {
        merchantAddress.text = first.addressLine;
        city.text = first.locality;
        state.text = first.adminArea;
        pincode.text = first.postalCode;
      });
    } catch (e) {
      print(e);
    }
  }

  AddBasicDetails() async {
    pr.show();
    final DatabaseReference database =  await FirebaseDatabase.instance.reference().child('BasicDetails');
    database.child(widget.UID).set({
      "Business_Name": businessName.text,
      "Merchant_Email": merchantEmail.text,
      "Merchant_Address": merchantAddress.text,
      "Business_Nature": businessNature.text,
      "Merchant_Contact": contact,
      "City": city.text,
      "State": state.text,
      "Pincode": pincode.text,
      "Status": "Inactive",
    }).then((value) {
      pr.hide();
      ShowSuccessAlert();
      print('inserted');
    }).catchError((error) {
      print(error);
    });
  }

  ShowSuccessAlert() {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            content: new SingleChildScrollView(
              child: Container(
                  child: Column(
                children: <Widget>[
                  Text(
                      "Thanks For the Registration, you'll be inform once your account is approved"),
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
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                      ),
                    ],
                  ),
                ],
              )),
            ),
          );
        });
  }

  // enter business details into database
  Future<Null> validate() async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 10) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
      print('isvalis value is $isValid');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  Future<bool> _onBackPressed() {
    Navigator.pushReplacementNamed(context, '/login');
  }
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
      message: 'Please wait...',
    );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(Latitude, Longitude),
                      zoom: 5,
                    ),
                    markers: Set<Marker>.of(
                      <Marker>[
                        Marker(
                          draggable: true,
                          markerId: MarkerId("1"),
                          position: LatLng(Latitude, Longitude),
                          icon: BitmapDescriptor.defaultMarker,
                          infoWindow: const InfoWindow(
                            title: 'Usted está aquí',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.grey[300],
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Business Name",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                            controller: businessName,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Business Name";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Nature of Business",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                            controller: businessNature,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Nature of Business";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Phone number",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                            keyboardType: TextInputType.number,
                            controller: _phoneNumberController,
                            onChanged: (text) {
                              validate();
                            },
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Contact Number";
                              } else {
                                return !isValid
                                    ? 'Please provide a valid 10 digit phone number'
                                    : null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Email Address",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                            controller: merchantEmail,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Email Address";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Address",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                            controller: merchantAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Your Address";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "City",
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                            controller: city,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter City ";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "State",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                            controller: state,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter State ";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Pin Code",
                              hintStyle: TextStyle(),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                            controller: pincode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Pin Code ";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.green,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            onPressed: () async {
              if (_currentStep == 0) {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    contactNumber = _phoneNumberController.text;
                    BusinessNature = businessNature.text;
                    BusinessName = businessName.text;
                    MerchantEmail = merchantEmail.text;
                    MerchantAddress = merchantAddress.text;
                    City = city.text;
                    States = state.text;
                    Pin = pincode.text;
                  });

                  pr.show();
                  await FirebaseDatabase.instance.reference().child('BasicDetails').child(widget.UID).update({
                    "Business_Name": BusinessName,
                    "Merchant_Email": MerchantEmail,
                    "Merchant_Address":MerchantAddress,
                    "Business_Nature": BusinessNature,
                    "Merchant_Contact": contactNumber,
                    "City": City,
                    "State": States,
                    "Pincode": Pin,
                    "Status": "Inactive",
                  }).then((value) async {
                    pr.hide();
                    ShowSuccessAlert();
                    print('inserted');
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('Business_Name', BusinessName);
                    prefs.setString('Merchant_Email', MerchantEmail);
                    prefs.setString('Merchant_Address', MerchantAddress);
                    prefs.setString('Merchant_Contact', contactNumber);
                    prefs.setString('City', City);
                    prefs.setString('State', States);
                    prefs.setString('Pincode', Pin);
                //  prefs.setString('Status', Inactive);
                    prefs.setString('userId', widget.UID );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            UID: widget.UID,
                          ),
                        ));
                  }).catchError((error) {
                    print("Error: "+error);
                  });
                }
              }
            },
            label: Text('Submit'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(color: Colors.green)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
