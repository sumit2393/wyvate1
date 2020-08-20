import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wyvate1/addService.dart';
import 'dart:io';

import 'main.dart';

class Services extends StatefulWidget {
  Services({this.UID});
  String UID;
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> with TickerProviderStateMixin {
  final dbRef = FirebaseDatabase.instance
      .reference()
      .child("BasicDetails")
      .child(uid)
      .child('category');
  List<dynamic> lists = [];
  List<dynamic> categories_id = [];
  List<dynamic> subcategory = [];
  List<dynamic> categoryList = [];
  String servicekey;
  TabController tabController;
  final editprice = TextEditingController();
  final editduration = TextEditingController();
  TextStyle tabStyle = TextStyle(fontSize: 16);

  @override
  void initState() {
    super.initState();

    getCategories();
  }

  deleteService(servicekey) {
    print('service key is $servicekey');
    final DatabaseReference database = FirebaseDatabase.instance
        .reference()
        .child('BasicDetails')
        .child(uid)
        .child('Services')
        .child(servicekey);
    database.remove();
    setState(() {});
  }

  updateService(servicekey) {
    final DatabaseReference database = FirebaseDatabase.instance
        .reference()
        .child('BasicDetails')
        .child(uid)
        .child('Services')
        .child(servicekey);

    return database.update({
      "Duration": editduration.text,
      "Price": editprice.text,
    }).then((value) {
      setState(() {
        Navigator.pop(context);
      });
    });
  }

  ShowEditAlert(price, duration, servicekey) {
    editprice.text = price;
    editduration.text = duration;
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return new AlertDialog(
            content: new SingleChildScrollView(
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 3),
                    child: Text('Price',
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 12,
                        )),
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: "Righteous"),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Price',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        contentPadding: EdgeInsets.only(left: 15, bottom: 10),
                      ),
                      controller: editprice,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 3),
                    child: Text('Duration',
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 12,
                        )),
                  ),
                  Container(
                    color: Colors.grey[300],
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: "Righteous"),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Duration',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        contentPadding: EdgeInsets.only(left: 15, bottom: 10),
                      ),
                      controller: editduration,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          child: Text('submit'),
                          onPressed: () {
                            updateService(servicekey);
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                      ),
                      Container(
                        child: RaisedButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ),
          );
        });
  }

  getCategories() {
    return FutureBuilder(
      future: dbRef.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          if (snapshot.data.value != null) {
            lists.clear();

            categoryList.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;

            print(values);
            values.forEach((key, values) {
              lists.add(values["category_name"]);
              categories_id.add(values["category_id"]);
              categoryList.add(values);
              print(' categories id is ${values["category_id"]}');
            });

            tabController = TabController(length: lists.length, vsync: this, initialIndex: 0);

            return tabCreate();
          } else {
            print('no data found for categories');
            return Container();
          }
        }
      },
    );
  }

  displayServices(sc) {
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child("BasicDetails")
        .child(uid)
        .child('Services')
        .orderByChild('sub_category')
        .equalTo(sc);
    return FutureBuilder(
      future: dbRef.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          if (snapshot.data.value != null) {
            List<String> services = [];
            List<String> price = [];
            List<String> duration = [];
            List<String> serviceKey = [];
            subcategory.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              services.add(values["Service_Name"]);
              price.add(values["Price"]);
              duration.add(values["Duration"]);
              serviceKey.add(key);
              print('service name is $services');
              print('service List length is ${services.length}');
              print('for sub cateogry $sc');
            });

            return ListView.builder(
              shrinkWrap: true,
              itemCount: services.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 40, top: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${services[index]}',
                          style:
                              TextStyle(fontFamily: "Righteous", fontSize: 16),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    child: Text('Price',
                                        style:
                                            TextStyle(fontFamily: "OpenSans")),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text('${price[index]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    child: Text('Duration',
                                        style:
                                            TextStyle(fontFamily: "OpenSans")),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text('${duration[index]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  ShowEditAlert(price[index], duration[index],
                                      serviceKey[index]);
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteService(serviceKey[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            print('no data found');
            return Container();
          }
        }
      },
    );
  }

  DisplaySubCategory() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: subcategory.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: ListTile(
                  title: Text(
                    '${subcategory[index]}',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Righteous",
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              displayServices(subcategory[index]),
            ],
          ),
        );
      },
    );
  }

  getSubCategories(cid) {
    print(' category id is $cid');
    final dbRef1 = FirebaseDatabase.instance
        .reference()
        .child("subcategory")
        .orderByChild('category_id')
        .equalTo(cid);
    return FutureBuilder(
      future: dbRef1.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          if (snapshot.data.value != null) {
            subcategory.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              subcategory.add(values["sub_category"]);

              print(subcategory);
            });

            return DisplaySubCategory();
          } else {
            print('no data found');
            return Container();
          }
        }
      },
    );
  }

  tabCreate() => CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Scaffold(
              backgroundColor: Colors.white70,
              appBar: TabBar(
                indicatorColor: Colors.blue,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                controller: tabController,
                isScrollable: false,
                tabs: List<Widget>.generate(lists.length, (int index) {
                  return new Tab(
                      child: Text(lists[index],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15.0)));
                }),
              ),
              body: TabBarView(
                  controller: tabController,
                  children: List<Widget>.generate(lists.length, (int index) {
                    var category_id = categories_id[index];
                    return getSubCategories(category_id);
                  })),
            ),
          ),
        ],
      );

  Future<bool> _onBackPressed() {
    Navigator.pushReplacementNamed(context, '/Dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Services'),
          backgroundColor: Color.fromRGBO(88, 187, 71, 1),
          actions: <Widget>[],
        ),
        body: getCategories(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Color.fromRGBO(88, 187, 71, 1),
            onPressed: () {
              setState(() {
                categories = lists;
              });
              print('categories are $categories');
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new addService(
                      UID: uid,
                      categoryData: categories,
                    ),
                  ));
            }),
      ),
    );
  }
}
