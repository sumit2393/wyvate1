import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:wyvate1/NewCustomer.dart';
class NewAppointment extends StatefulWidget {
  @override
  _NewAppointmentState createState() => _NewAppointmentState();
}
class _NewAppointmentState extends State<NewAppointment> {
    String _date = "Not set";
    String _time = "Not set";
   TextEditingController pricescontroller=new TextEditingController();
  TextEditingController durationcontroller=new TextEditingController();
  @override
  void initState() {
    super.initState();
    _date="";
  }
  final List<String> _dropdownValues = [
    "Mens HairCut",
    "Spa",
    "Three",
    "Four",
    "Five"
  ];
   final List<String > _repeat=[
          "Repeat daily"
         "Repeat weekly"
   ];
    User selectedUser;
    List<User> users = <User>[const User('Akash'), const User('Ravi')];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left:10,top:50),
              child: Text(
                "Book Appointment with Jessica Cuttler", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top:20),
              width: 250,
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      color: Colors.white, style: BorderStyle.solid, width: 1.80),
                ),
                child: DropdownButton(
                  items: _dropdownValues
                      .map((value) => DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  ))
                      .toList(),
                  onChanged: (String value) {},
                  isExpanded: false,
                  value: _dropdownValues.first,
            )
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left:20,right: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme:DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                        print('confirm $date');
                        _date = '${date.year} - ${date.month} - ${date.day}';
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.only(left:20,right: 20),
              child: RaisedButton(
                padding: EdgeInsets.only(left:20,right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                        print('confirm $time');
                        _time = '${time.hour} : ${time.minute} : ${time.second}';
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  " $_time",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
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
                        child:Text('Prices'),
                      ),
                      Expanded(
                        child:Container(
                          color: Colors.grey[300],
                          margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                         //   enabled: sunday,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Rs',
                              hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                            ),
                            controller: pricescontroller,
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
                        child:Text('Duration'),
                      ),
                      Expanded(
                        child:Container(
                          color: Colors.grey[300],
                          margin: EdgeInsets.only(top:8),
                          child: TextFormField(
                           // enabled: sunday,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '  0:00',
                              hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                            ),
                            controller: durationcontroller,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              height: 300,
              // hack textfield height
              padding: EdgeInsets.only(bottom: 40),
              child: TextField(
                maxLines: 99,
                decoration: InputDecoration(
                  hintText: "Comment!",
                  border: OutlineInputBorder(),
                ),
              ),
            ),


            Text("CUSTOMER",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
      SizedBox(
        height: 10,
      ),
      Container(
        child: new DropdownButton<User>(
          hint: new Text("Select a user"),
          value: selectedUser,
          onChanged: (User newValue) {
            setState(() {
              selectedUser = newValue;
            });
          },
          items: users.map((User user) {
            return new DropdownMenuItem<User>(
              value: user,
              child: new Text(
                user.name,
                style: new TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: new TextField(
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Customer Name",
                    fillColor: Colors.white70),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 10,right: 10),

              child: new TextField(
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Email id",
                    fillColor: Colors.white70),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 10,right: 10),

              child: new TextField(
               keyboardType: TextInputType.number,

                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "MobileNumber",
                    fillColor: Colors.white70),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(

              children: [

                Container(
                  padding: EdgeInsets.only(left:40,bottom: 20),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: RaisedButton(
                      textColor: Colors.black,
                      color: Colors.greenAccent,
                      onPressed: () {},
                      child: Text("Book"),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:40 ,bottom: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: RaisedButton(
                      textColor: Colors.black,
                      color: Colors.greenAccent,
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (BuildContext context) => NewCustomer()));
                      },
                      child: Text("New Customer"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class User {
  const User(this.name);
  final String name;
}