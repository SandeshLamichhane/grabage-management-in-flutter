import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/waterdrop_header.dart';
import 'package:horizontal_data_table/scroll/scroll_bar_style.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
 import 'package:waste/Root/constant.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/addHospital/addHospitalController.dart';
import 'package:waste/Settings/UserSetting/addHospitalRoute/EditRouteOfHospital.dart';
import 'package:waste/Settings/UserSetting/addHospitalRoute/addHospitalRouteController.dart';
  import 'package:waste/Settings/UserSetting/addRoutes/weekDay.dart';
 
class AddHospitalRoutes extends StatefulWidget { 
  @override
  _AddHospitalRoutesState createState() => _AddHospitalRoutesState();
}

class _AddHospitalRoutesState extends State<AddHospitalRoutes> {
HDTRefreshController _hdtRefreshController = HDTRefreshController();
var _formKey= GlobalKey<FormState>();
var weekdaydifobj=WeekdayDifference();

TextEditingController confirmDeleteController= new TextEditingController();
TextEditingController newmargController= new TextEditingController();

TextEditingController  truckN= new TextEditingController();
TextEditingController description= new TextEditingController();
 
String newOdaNo="";
String bar="";
String interval="";
String truckNo="";

Marker marker;

Circle circle;  
GoogleMapController myController;
LatLng currentlatLng=
 
new LatLng(0.0, 0.0);

String hospitalNameValidator;
String districtNameValidator;
String maargValidator;
String baarValidator;
String pugneTimeValidator;
String vehicleIDValidator;
String chowkLatLongvalidator;


 String selectedHospitalName;
String selectedMarg;
String selecteddistrict;
String selectedInterval;
String selectedVehicleId;
LatLng selectedlatLongchowk;
List  _selectedWeekBaarList;

final _addhospitalroutecontroller= Get.put(AddHospitalRouteController());
  
  TabController tabcontroller;
    final List<Tab> myTabs = <Tab>[
    new Tab(text: 'LEFT'),
    new Tab(text: 'RIGHT'),
  ];
 
@override
   void initState() { 
      super.initState();
     
   _addhospitalroutecontroller.retrieveVehicleIDFromServer();
  _addhospitalroutecontroller.loadAllHospitalRoutesFromFirestore();
  
    makeEMptyselected();
       hospitalNameValidator=null;
       districtNameValidator=null;
       maargValidator=null;
        baarValidator=null;
       pugneTimeValidator=null;
        vehicleIDValidator=null;
        chowkLatLongvalidator=null;
         
   }
  int selectedRow=-1;
@override
void dispose() { 
   
  newmargController.dispose();
 confirmDeleteController.dispose();  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
       
      child: SafeArea(
      child: Scaffold(
      appBar: AppBar(
        title: Text('Add your Hospital Route'),
        bottom:TabBar(tabs: [
          Tab(icon: Icon(Icons.directions_car)),
          Tab(icon: Icon(Icons.directions_transit)),
        ]),
      ),
      body:TabBarView(
            children: [          
       
             // !
           //   _addhospitalroutecontroller.hasNumberofRoutes?
          
              //addroutecontroller.refreshTable==true|| _addroutecontroller.refreshTable==false? 
               
               GetBuilder(
                 init:_addhospitalroutecontroller ,
                 builder: (_addhospitalroutecontroller)=>
                 HorizontalDataTable(
                             leftHandSideColumnWidth: 150,
                             rightHandSideColumnWidth: 950,
                             isFixedHeader: true,
                             headerWidgets: _getTitleWidget(),
                             leftSideItemBuilder: _generateFirstColumnRow,
                             rightSideItemBuilder:_generateRightHandSideColumnRow,
                 itemCount: _addhospitalroutecontroller.listofHospitalRoute.length,
                             rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                             ),
                             leftHandSideColBackgroundColor: Color(0x02020200),
                 rightHandSideColBackgroundColor:  Color(0x00551020),
                             verticalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.yellow,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                             ),
                             horizontalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.red,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                             ),
                             enablePullToRefresh: true,
                             refreshIndicator: const WaterDropHeader(),
                             refreshIndicatorHeight: 60,
                             onRefresh: () async {
                  //Do sth
                 
                  
                 _addhospitalroutecontroller.loadAllHospitalRoutesFromFirestore();
                  _hdtRefreshController.refreshCompleted();
                  setState(() {
                                 
                               });
                             },
                             htdRefreshController: _hdtRefreshController,
                     
                     ))
               ,
            addNewRouteWidget()
           ],
           
             ))));
  }
       
      
      
 List<Widget> _getTitleWidget() {
    return [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'Hospital Name' ,
            150),
        onPressed: () {
        //  addOdaControler.loadAllOdaNo();
           
        },
      ),
      

      _getTitleItemWidget('location', 150),      
      _getTitleItemWidget('district', 100),
      _getTitleItemWidget('Truck', 150),
       _getTitleItemWidget('Interval', 150),
       
       _getTitleItemWidget('Weekbar', 150),
      _getTitleItemWidget('LatLng', 150),
         _getTitleItemWidget('Delete', 100),
      
     ];
  }
   Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold,)),
      width: width,
      height: 56,
      decoration:BoxDecoration(
        color:  Color(0xFF3333FAFF),

      ),
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return GestureDetector(
      onDoubleTap:(){


       setState(() {
                selectedRow=index;        
              });    
          Get.to(EditHospitalRoutes(
            index
          // selectedRouteId: _addroutecontroller.listofRoutes[index].routeId,
          // selectedOdaNo: _addroutecontroller.listofRoutes[index].oda,
          // selectedMarg: _addroutecontroller.listofRoutes[index].marga,
          // selectedBar:  _addroutecontroller.listofRoutes[index].baar,
          // selectedInterval: _addroutecontroller.listofRoutes[index].interval,
           //selectedVehicleId:  _addroutecontroller.listofRoutes[index].truckNo,

           //selectedlatLongchowk: 
           // LatLng(_addroutecontroller.listofRoutes[index].chowkLocation.latitude,
          //  (_addroutecontroller.listofRoutes[index].chowkLocation.longitude)

        //  )
          //)
          ));
              
      },   
      child: InkWell(
        onTap: (){
          // BotToast.showText(text: users.userdetail[index].userPhone );
              setState(() {
                selectedRow=index;        
              });
           
            
        },
        child: Tooltip(
          message: "Double tap to edit",
          child: Container(
             color:  selectedRow==index?Colors.blueGrey: Colors.transparent,
             child: Text(_addhospitalroutecontroller.listofHospitalRoute [index].hospitalName.toString()),
            width: 150,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
    );
  }


  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return GestureDetector(
      onDoubleTap: (){
            print(index.toString()+'/'+selectedRow.toString());
          setState(() {
            selectedRow=index;
            
          });
      },
      child: InkWell(
        onTap: (){
          print(index.toString()+'/'+selectedRow.toString());
          setState(() {
            selectedRow=index;
            
          });
        },
    
    
        child: Container(
          color:  selectedRow==index?Colors.blueGrey : Colors.transparent,
          child: Row(
            children: <Widget>[
              InkWell(
                onTap:(){
                },
                child: Container(
                 child: Text(_addhospitalroutecontroller.listofHospitalRoute [index].marga.toString()),
                  width: 150,
                  height: 52,
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                ),
              ),
      
            
              Container(
              child: Text(_addhospitalroutecontroller.listofHospitalRoute [index].districtName.toString()),
                width: 100,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
    
                  Container(
              child: Text(_addhospitalroutecontroller.listofHospitalRoute [index].truckNo.toString()),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
                 Container(
              child: Text( 
                  
                _addhospitalroutecontroller.listofHospitalRoute [index].interval.toString()),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
                  Container(
            child: Text(_addhospitalroutecontroller.listofHospitalRoute [index].weekbaar.toString()),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
                  Container(
               child: Text(_addhospitalroutecontroller.listofHospitalRoute [index].chowkLocation.latitude.toString()+'/'+
                             _addhospitalroutecontroller.listofHospitalRoute[index].chowkLocation.longitude.toString()),
                width: 150,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              
                Container(
                child: IconButton(onPressed: ()async{
               deleteRouteFromServer(_addhospitalroutecontroller.listofHospitalRoute[index].routeId);

                  
               
                }, icon: Icon(Icons.delete)),
                width: 100,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ADDING NEW Hospital ROUTE WIDGET %%%%%%%%%%%%%%%%%%%%
  addNewRouteWidget() {
     return Form(
                   key: _formKey,
                   child: Container(
                   child:ListView(
                   padding: EdgeInsets.symmetric(horizontal: 20.0),
                   children: <Widget>[
                     
       SizedBox(height: 10,),
       AutoSizeText("Gadi chalne route थप्नुहोस्  . ", 
                   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)),
       SizedBox(height:15),                  
//      
  // ############################ ENTER HOSPITAL #####################################################
  HospitalNameTextField(
    onValidator:(val){
     return hospitalNameValidator;
    },
    onChnageField: (val){
      hospitalNameValidator=null;
      selectedHospitalName=val;
    },
  ),
                
//  select the distric for the hospital ###############################################################
 SizedBox(height: 15,),
 Obx(()=>(
    DropdownSearch(
         selectedItem:_addhospitalroutecontroller.districtNameobs,
            onChanged:(value){
                                selecteddistrict=value;
                                _addhospitalroutecontroller.changedistrict(value);
                              } ,
                       validator: (val){
                                if(val==null){
                                  return"select district";
                                }
                                return null;
                              },
                              searchBoxDecoration: InputDecoration(
                                labelText: "Search district...",
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                filled: true,
                              ),
                             
                               
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              label:"Select district",
                              items:  allNepalDistricts,
                            )),
 ),
                            SizedBox(height:15),

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Enter vehicle Id %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        MargTextField(           
                          hintText: " मार्ग ya chowk lekhnu hos", 
                          onChnageField: (value){
                            selectedMarg=value
;                          }, 
                          onValidator:(value){
                            return maargValidator;
                          } ,    
                        ),
    //////////////////////////// ,This is FOR BAAR ###############################
      SizedBox(height:15),
            //Obx(()=>(
             MultiSelectFormField(
                    
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2,color: Colors.red),
                    ),
                     autovalidate: false,
                    chipBackGroundColor: Colors.blue,
                    chipLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    checkBoxActiveColor: Colors.blue,
                    checkBoxCheckColor: Colors.white,
                    dialogShapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    trailing:Icon(Icons.arrow_back, color:Colors.white), 
                    
                    title: Text(
                      "Select Weekday",
                      style: TextStyle(fontSize: 16, color:Colors.grey)
                    ),
                    fillColor: Colors.transparent,
                     validator: (value) {
                     return baarValidator;
                    },
                    
                    dataSource: [
                    {
                      "display": "All weekday",
                      "value": "All weekday",
                    },
                    {
                      "display": "Twice weekday",
                      "value": "Twice weekday",
                    },
                    {
                      "display": "Thrice weekday",
                      "value": "Thrice weekday",
                    },
                    {
                      "display": "Sunday",
                      "value": "Sunday",
                    },
                    {
                      "display": "Monday",
                      "value": "Monday",
                    },
                   
                       { "display": "Tuesday",    "value": "Tuesday",     },
                       { "display": "Wednesday",    "value": "Wednesday",     },
                       { "display": "Thursday",    "value": "Thursday",     },
                       { "display": "Friday",    "value": "Friday",     },
                       { "display": "Saturday",    "value": "Saturday",     },
                    ],
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    hintWidget: Text('(less than or equal 3 accepted)', style: TextStyle(color: Colors.grey),),
                    initialValue: null,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                   WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

                      _selectedWeekBaarList=value;
                      
                      });
                    },
             )
             //)
                              //)
               ,
                       
                           SizedBox(height:10),
 ////////////////////////////////////////// TIME INTERVAL //////////////////////////////////////////////////ROUTE
    TimeInterValTextField(
      
      hintText: "Pugne Time(2.10-4.10/AM)",
      onValidator: (value){
        return pugneTimeValidator;
      },
      onChnageField: (value){
         selectedInterval=value;
      },
    
    ),
    
 //   ////////////////// vehicle id validator // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
     SizedBox(height: 10,),
      Obx(()=>(
         DropdownSearch(
                       selectedItem: _addhospitalroutecontroller.vehicleIdObs,
                      onChanged:(value){ selectedVehicleId=value; 
                      _addhospitalroutecontroller.changeVehicleId(value); } ,
                     validator: (val ){
                       return  vehicleIDValidator;
                     },
                    searchBoxDecoration: InputDecoration(
                                  labelText: "Search Vehicle NO...",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                  filled: true,
                                ),
                
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                label:"Gaadi छान्नुहोस्",
                                items:    _addhospitalroutecontroller.listofVehicleId
            )),      ),
                         
////////////////////////////////// LATITUDE AND LONGITUDE  ////////////////////////////////////////////////////////////
              SizedBox(height: 15,),
              AutoSizeText("Help App to find chowk", style:TextStyle(fontSize: 14, color:Colors.grey)),
                   
              
                Container(
                       height:60,
                              decoration: BoxDecoration(
                                 shape: BoxShape.rectangle,
                                 borderRadius: BorderRadius.circular(5.0),
                                 border: Border.all(width:1.5, color:Colors.grey)),
                            child:InkWell(
                              onTap:(){
                       Get.defaultDialog(
                         title: "Find  Hospital in map",
                         content:Container(
                            height: (MediaQuery.of(context).size.height-300),
                           width:double.infinity,
                           child:googleMap()
                         )
                         ,
                         cancel: Container(
                           width: double.maxFinite,
                           child: TextButton(onPressed: (){
                             Get.back();
                             setState(() {
                               
                             });
                           }, child: Text("Ok")))
                       );
                      
                     }, child:  Align(
                       alignment:Alignment.centerLeft,
                    child:   Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: Obx(()=>(
                         AutoSizeText("Lat : " +_addhospitalroutecontroller.chwoklatlongobs.latitude.toString()+ 
                        "   Lng : "+_addhospitalroutecontroller.chwoklatlongobs.longitude. toString(), textAlign: TextAlign.left)
                      )),
                    )
                     )),
              ),
                   
                 SizedBox(height: 20,),
                    ClipRRect(
                      child:SizedBox(
                        height:50,
 child:ElevatedButton(onPressed: ()async{
    
//FIRST OF ALL LETS VALIDATE ODA #####################################################
_addhospitalroutecontroller.changeisEdit(false);
var a =  await _addhospitalroutecontroller.validateHospitalName(selectedHospitalName);
hospitalNameValidator=a;
var y =  await _addhospitalroutecontroller.validateMarg( selectedMarg);
maargValidator=y;
//FIRST OF ALL LETS VALIDATE ODA #####################################################
var z =  await _addhospitalroutecontroller.validateWeekBar( _selectedWeekBaarList);
baarValidator=z;
var as =  await _addhospitalroutecontroller.validateInterval( selectedInterval);
pugneTimeValidator=as;
//FIRST OF ALL LETS VALIDATE ODA #####################################################
var b =  await _addhospitalroutecontroller.validatevehicleId(selectedVehicleId);
vehicleIDValidator=b;
var c =  await _addhospitalroutecontroller.validateChowkLatLnf( selectedlatLongchowk);
chowkLatLongvalidator=c;
   //cov
 
if(_formKey.currentState.validate()) {
  _addhospitalroutecontroller.addNewHospitalRoutes(
    //oda: selectedOdaNo,
    districtName:selecteddistrict,
      hospitalName: selectedHospitalName,
    marg: selectedMarg,
    weekbaar: _selectedWeekBaarList ,
    timeInterval:selectedInterval ,
    gaadiNo: selectedVehicleId ,
   
    chowkLocation: selectedlatLongchowk,
    onSuceess: ()async{
     await  makeEMptyselected();               
      selectedlatLongchowk= LatLng(0.0, 0.0);
  
       _formKey.currentState.reset();   
      //  _addroutecontroller.loadAllRoutesFromFirestore();
    }
     
  ) ;
}       
//  
                       },
                        
                       child: Text("Add New CHowk"))
                      )
                    )
                    ,SizedBox(height:20),
                       ]
                     )),
                 );
    
  }


void updateMarkerAndCircle(LatLng latLng){
    //LatLng latlng= LatLng(locationData.latitude,locationData.longitude);
    print(latLng.longitude.toString()+latLng.longitude.toString()+",,,,,,,,,,,,,,,,,,,,,,,,");
    this.setState(() {
      marker=
      Marker(
         infoWindow: InfoWindow(title: "Find this chowk", snippet:"Hold and Move to set"),
         markerId: MarkerId("chowkID"),
        position:latLng,
        draggable: true,
          zIndex: 1,
        flat:true,
        anchor: Offset(0.5,0.5),
        icon:  BitmapDescriptor.defaultMarker,
        onDragEnd: ((newPosition) {
                   currentlatLng= new LatLng(newPosition.latitude, newPosition.longitude);
           print("//new"+ newPosition.longitude.toString());
           print("current"+currentlatLng.longitude.toString());

          })
      );
      
    });

}

  googleMap() {
  
   return  GoogleMap(
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: Set.of(<Marker> [Marker(
         infoWindow: InfoWindow(title: "Find chowk", snippet:"Hold and Move to set"),
         markerId: MarkerId("chowkID"),
        position: LatLng(28.1833432777335, 83.9861154408866),
        draggable: true,
          zIndex: 1,
        flat:true,
        anchor: Offset(0.5,0.5),
        icon:  BitmapDescriptor.defaultMarker,
        onDragEnd: ((newPosition) {
                   currentlatLng= new LatLng(newPosition.latitude, newPosition.longitude);
             selectedlatLongchowk =LatLng(currentlatLng.latitude, currentlatLng.longitude);
          _addhospitalroutecontroller.changechok(GeoPoint(selectedlatLongchowk.latitude, selectedlatLongchowk.longitude));

          })
      )
          ]),
         
          initialCameraPosition:  CameraPosition(target: LatLng(28.2433432777335, 83.9961154408866), zoom:14),
          onMapCreated:  (GoogleMapController controller){
           myController=controller;
          },
           
          
          //(GoogleMapController controller) {
         //   _controller.complete(controller);
        //  },
              );
              
  }
  //////////////////////////////HELP US TO FIND &&&&&&&&&&&&&&&&&&&&&
  changePosition(LatLng latLng){
      if(myController !=null){
             myController.animateCamera(CameraUpdate.newCameraPosition(           
               new CameraPosition(       
                 bearing: 192.8334901395799,
                 target:  LatLng(latLng.latitude,  latLng.longitude),
                 zoom: 18.0,
                 tilt: 0,
                 )
             ));

             updateMarkerAndCircle(latLng);
           }

}

     makeEMptyselected() async{
      _addhospitalroutecontroller.changedistrict(null);
      _addhospitalroutecontroller.changebar(null);
      _addhospitalroutecontroller.changeVehicleId(null);
       _addhospitalroutecontroller.changechok(GeoPoint(0.0,0.0));
        
    
  selectedMarg='';
  selectedInterval='';
  selectedVehicleId='';
  selectedHospitalName='';
  selecteddistrict='';
  selectedlatLongchowk= LatLng(0.0, 0.0);
   
  }

  void deleteRouteFromServer(String routeId) {
     Get.bottomSheet(
                    Container(
                         height: 200,
                         color:Colors.white,
                         padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            child: DeleteTextField(
                              iconData: Icons.games,
                              hintText: "Enter { remove } to delete.",
                              onChnageField: (value){              
                              },
                              nameController: confirmDeleteController,
                            )
                          ),
                          SizedBox(height: 20,),
                          ClipRRect(
                            child: SizedBox(
                              height:50,
                              width:double.maxFinite,
                              child: ElevatedButton(onPressed: () async {
                                
                                if(confirmDeleteController.text.trim()=='remove'){
                                  //suucess ful
                                  confirmDeleteController.clear();
                                  Get.back();
                   _addhospitalroutecontroller.deleteFromServer(
                     routeId,  () async{
                   await _addhospitalroutecontroller.loadAllHospitalRoutesFromFirestore();
                      setState(() {
                        
                      });
                   });
                                           }
                              },
                       
                              child: Text("Confirm"),
                              )
                              ,
                            )
                          )
                        ],
                      ),
                    )
                  );
  } 



  }
////////////////////////////////////////////////////////////
