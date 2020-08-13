

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wyvate1/main.dart';

class addService extends StatefulWidget {
  addService({this.UID,this.categoryData});
  String UID;
  List<dynamic> categoryData;
  @override
  _addServiceState createState() => _addServiceState();
}

class _addServiceState extends State<addService> with TickerProviderStateMixin {

  

 
   String myCategory;
   String mySubCategory;
   List<String> Category =[];
    List<String> SubCategory =[];
    List<String> ServicesList =[];
    List<bool> ServiceCheck =[];
    List<DynamicWidget> listDynamic = [];
    String myService;
  List<String> priceList = [];
  List<String> durationList = [];
  List<String> serviceName =[];
 final dbRef = FirebaseDatabase.instance.reference().child("BasicDetails").child(uid).child("Services");
 
  void initState(){
    super.initState();
    listDynamic.clear();
    getcategory();

     
  }
   Future<bool> _onBackPressed(){
    Navigator.pushReplacementNamed(context, '/Dashboard');
  }
  AddService(){
   var i=0;
   print('list dynamic length is ${listDynamic.length}');
  for(i=0;i<=ServicesList.length-1;i++){

    print('index value is $i');
     if(ServiceCheck[i] == true){
var price = listDynamic[i].price.text;
    var duration = listDynamic[i].duration.text;
      var _serviceName = ServicesList[i];

      if(price.isEmpty){
        price = '0';
      }
      if(duration.isEmpty){
        duration = '0';
      }
    priceList.add(price);
   
    durationList.add(duration);
    serviceName.add(_serviceName);
    


     
    }

  }

  print('price list length is $priceList');
   print('price list length is $durationList');
    print('Service Name list length is $serviceName');
 
  for(var j=0;j<=priceList.length-1;j++){
    print('price value is ${priceList[j]}');
     print('Duration value is ${durationList[j]}');
    dbRef.push().set({
     "Service_Name": serviceName[j],
     "Price": priceList[j],
     "Duration": durationList[j],
     "sub_category": mySubCategory,
     "category": myCategory,
    });
  }


 ShowSuccessAlert();
     
 
     setState(() {
        priceList.clear();
      durationList.clear();
      serviceName.clear();
      listDynamic.clear();
     });
     
     
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
                 
                  
               Text("Service Added Successfully"),

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
getcategory(){
  final dbref = FirebaseDatabase.instance.reference().child("BasicDetails").child(uid).child('category');
  return dbref.once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> values = snapshot.value;
            
      values.forEach((key, values) {
        var category = values['category_name'];
         Category.add(category);
       
       });
       setState(() {
         myCategory = Category[0];
       });
        print('my category is $myCategory');
       return getSubCategory(myCategory);
  });
      
    
  }
  getSubCategory(myCategory){
  final dbref = FirebaseDatabase.instance.reference().child("subcategory").orderByChild('category_name').equalTo(myCategory);
  return dbref.once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> values = snapshot.value;
       SubCategory.clear();
      values.forEach((key, values) {
        var subcategory = values['sub_category'];
         SubCategory.add(subcategory);
        
       });
       setState(() {
       mySubCategory = SubCategory[0];
       });
       print('my sub category is $mySubCategory');
       
         return getServices(mySubCategory);
       
  });
      
    
  }

  getServices(mySubCategory){
    final dbref = FirebaseDatabase.instance.reference().child("service").orderByChild('sub_category').equalTo(mySubCategory);
  return dbref.once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> values = snapshot.value;
       ServicesList.clear();
       ServiceCheck.clear();
       if(snapshot.value !=null){
      values.forEach((key, values) {
        var service= values['service_name'];
         ServicesList.add(service);
         
       
         ServiceCheck.add(false);
        print('my service is $service');
        print('my service length is ${ServicesList.length}');
       });
       setState(() {
         myService= ServicesList[0];
       });
       }else{
         
          setState((){
 ServicesList.clear();
          });
       }
       return Container();
  });
  }
    DisplayServices(){
      return ListView.builder(
        shrinkWrap: true,
        itemCount: ServicesList.length,
        itemBuilder: (context, index){
             TextEditingController Price = new TextEditingController();
          TextEditingController Duration = new TextEditingController();
           listDynamic.add(new DynamicWidget(price: Price,duration: Duration,));
        
          return Container(
            margin: EdgeInsets.only(left:15),
            child:Column(
              children:<Widget>[
              Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                 value: ServiceCheck[index],
      onChanged: (bool newValue) {
        setState(() {
          ServiceCheck[index] = newValue;
          if(newValue== true){
          
          
          }
        });
      },
                activeColor: Color.fromRGBO(88, 187, 71, 1),
            ),
                Text('${ServicesList[index]}',style:TextStyle(fontFamily: "Righteous",fontSize: 15)),
         
          ],
            ),
            ServiceCheck[index] == false ? Container() : listDynamic[index],
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
          title: Text('Add Service', style:TextStyle(fontFamily: "Righteous")),
          backgroundColor: Color.fromRGBO(88, 187, 71, 1),
          actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
             onPressed: (){
               AddService();
             },
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top:20),
            
            child: SingleChildScrollView(
              child: Column(
       mainAxisAlignment: MainAxisAlignment.end,
       crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  
                  DropdownButtonHideUnderline(
                    
                    child: ButtonTheme(
                      
                      alignedDropdown: true,
                      
                      child:Container(
                         decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
                       width:MediaQuery.of(context).size.width,
                       margin:EdgeInsets.all(15),
                      child:DropdownButton<String>(
                      
                      
                        value: myCategory,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontFamily: "Righteous"
                        ),
                        hint: Text('Select Category'),
                        onChanged: (String newValue) {
                         setState(() {
                         myCategory = newValue;
                          getSubCategory(myCategory);
           
          
                          });
                        },
                        items: Category?.map((item) {
                              return new DropdownMenuItem(
                                
                                child: new Text(item),
                                value: item
                              );
                            })?.toList() ??
                            [],
                      ),
                      
                    ),
                  ),
                  ),
                  
                  
                  DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      
                      child: Container(
                         decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
                        width:MediaQuery.of(context).size.width,
                        margin:EdgeInsets.all(15),
                        child:DropdownButton<String>(
                        value: mySubCategory,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontFamily: "Righteous"
                        ),
                        hint: Text('Select Sub Category'),
                        onChanged: (String newValue) {
                         setState(() {
                         mySubCategory = newValue;
                         getServices(mySubCategory);
           
          
                          });
                        },
                        items: SubCategory?.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item),
                                value: item
                              );
                            })?.toList() ??
                            [],
                      ),
                     
                    ),
                  ),
                  ),

               ServicesList.isEmpty ? Container():DisplayServices(),
                  
               
                
                ],
              ), 
            )
          ) ,
          ),
        ),
      );
    }
}

class DynamicWidget extends StatefulWidget {
  DynamicWidget({this.price,this.duration});
  TextEditingController price = new TextEditingController();
  TextEditingController duration = new TextEditingController();
  @override
  _DynamicWidgetState createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  
  @override
  Widget build(BuildContext context) {

  void initState(){
     super.initState();
        widget.price.text = '10';
    
     
  }
     
   
    return Container(
             
             margin: EdgeInsets.only(left:0,right:15),
             
              child: Row(
                children:<Widget>[
                Expanded(
                  
                 
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Container(
                          margin: EdgeInsets.only(left:6),
                       child: Text('Service Price',style: TextStyle(fontFamily: "OpenSans",fontSize: 12,),),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                    color:Colors.grey[300],
                    
                       child: SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                         style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                         
                        
                     
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: 'Price',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                 
                  
                   controller: widget.price,
                    
                   
                  
                 
                 
                          ),
                        ),
                      ],
                    ),
                
                ),
                
                Expanded(
                 
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[

                      Container(
                          margin: EdgeInsets.only(left:6),
                       child: Text('Duration',style: TextStyle(fontFamily: "OpenSans",fontSize: 12,),),
                        ),
                        Container(
                    color:Colors.grey[300],
                    margin: EdgeInsets.all(5),
                   
                        child:SimpleAutoCompleteTextField(
                            keyboardType: TextInputType.number,
                         style: TextStyle(fontSize:15,color: Colors.black , fontFamily:"Righteous"),
                           
                         
                          
                   
                           
                  decoration: InputDecoration(
                     border: InputBorder.none,
                    hintText: 'Duration',
                     
                     hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.bold,color: Colors.black ),
                      contentPadding: EdgeInsets.only(left:15,bottom: 10),
                    
                  ),
                 
                  
                   
                    
                   controller: widget.duration,
                  
                 
                 
                          ),
                        ),
                      ],
                    ),
                
                ),
                ],
              ),
            );
  }
}