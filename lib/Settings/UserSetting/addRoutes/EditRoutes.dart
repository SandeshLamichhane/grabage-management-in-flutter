import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/addRoutes/addRouteController.dart';

class EditRoutes extends StatefulWidget {
String selectedRouteId;
  String selectedOdaNo;
   String selectedMarg;
 String selectedBar;
  String selectedInterval;
  String selectedVehicleId;
  LatLng selectedlatLongchowk;
 
EditRoutes({
  this.selectedRouteId,
  this.selectedOdaNo, 
  this.selectedMarg, 
  this.selectedBar, 
this.selectedInterval, 
this.selectedVehicleId,
 this.selectedlatLongchowk});
  @override
  _EditRoutesState createState() => _EditRoutesState();
}

class _EditRoutesState extends State<EditRoutes> {


String odaValidator;
String maargValidator;
String baarValidator;
String pugneTimeValidator;
String vehicleIDValidator;
String chowkLatLongvalidator;
 
TextEditingController _maargTextfieldController;
TextEditingController _timeintervalTextfieldController;
TextEditingController _TextfieldController;

 LatLng currentlatLng;
 

GoogleMapController myController;

  @override
  void initState() { 
    super.initState();
    odaValidator=null;
       maargValidator=null;
        baarValidator=null;
       pugneTimeValidator=null;
        vehicleIDValidator=null;
        chowkLatLongvalidator=null;

 currentlatLng= LatLng(widget.selectedlatLongchowk.latitude, widget.selectedlatLongchowk.longitude);
//setting value
        _addroutecontroller.changeOda(widget.selectedOdaNo); 
         _addroutecontroller.changebar  (widget.selectedBar); 
          _addroutecontroller.changeVehicleId  (widget.selectedVehicleId); 
        _addroutecontroller.changechok(GeoPoint(widget.selectedlatLongchowk.latitude, widget.selectedlatLongchowk.longitude));

 
   _maargTextfieldController = TextEditingController(text:  widget.selectedMarg);
  _timeintervalTextfieldController= TextEditingController(text: widget.selectedInterval);

  }

 var  _formKeyx =GlobalKey<FormState>();
 final _addroutecontroller= Get.put(AddRouteController());



  @override 
Widget build(BuildContext context) {
    return WillPopScope( onWillPop: ()async{
      if(Platform.isAndroid){
        return false;
      }
      return false;
    },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton( icon: Icon(Icons.arrow_back),onPressed: (){
              makeEMptyselected();
              Navigator.pop(context);
            }, ),
            title: Text("Edit: routes"),
          ),
          body: Form(
                     key: _formKeyx,
                     child: Container(
                     child:ListView(
                     padding: EdgeInsets.symmetric(horizontal: 20.0),
                     children: <Widget>[
                        SizedBox(height: 10,),
      
                Obx(()=>(
                  DropdownSearch(
                               selectedItem:   _addroutecontroller.odaObs,
                                onChanged:(value){ 
                                  widget.selectedOdaNo=value;  
                               _addroutecontroller.changeOda(value);  
                                } ,
                                  validator: (val){
                                          return odaValidator;
                                  },
                                  searchBoxDecoration: InputDecoration(
                                    labelText: "Search oda...",
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                    filled: true,
                                  ),
                                   
                                  mode: Mode.MENU,
                                  showSearchBox: false,
                                  label:"ओडा छान्नुहोस्",
                                  items:  ['07', '17' ''],
                                )
                ),),
                        
                              SizedBox(height:15),
    // FIRST ODA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   MAARGA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                          MargTextField(           
                            hintText: " मार्ग ya chowk lekhnu hos", 
                             nameController: _maargTextfieldController,
                            onChnageField: (value){
                              widget.selectedMarg=value
    ;                          }, 
                            onValidator:(value){
                              return maargValidator;
                            } ,    
                          ),
      //////////////////////////// ,This is FOR BAAR ###############################
        SizedBox(height:15),
              Obx(()=>(
                DropdownSearch(
                  selectedItem:_addroutecontroller.barObs,
                   onChanged:(value){    widget.selectedBar=value; _addroutecontroller.changebar(value);
                                  } ,
                    validator: (val){  return baarValidator;    },
                   searchBoxDecoration: InputDecoration(
                                    labelText: "Search ...",
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                    filled: true,
                                  ),
                                  mode: Mode.DIALOG,
                                  showSearchBox: true,
                                  label:"यो मार्गमा गाडी जाने बार",
                                  items:  ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
                                )))
              ,
                         
                             SizedBox(height:10),
     ////////////////////////////////////////// TIME INTERVAL //////////////////////////////////////////////////ROUTE
      TimeInterValTextField(
        nameController: _timeintervalTextfieldController,
        hintText: "Pugne Time(2.10-4.10/AM)",
        onValidator: (value){
          return pugneTimeValidator;
        },
        onChnageField: (value){
           widget.selectedInterval=value;
        },
      
      ),
      
     //   ////////////////// vehicle id validator // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
       SizedBox(height: 10,),
        Obx(()=>(
           DropdownSearch(
                         selectedItem: _addroutecontroller.vehicleIdObs,
                        onChanged:(value){ widget.selectedVehicleId=value; _addroutecontroller.changeVehicleId(value); } ,
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
                                  items:   _addroutecontroller.listofVehicleId
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
                         title: "Find  your input chowk",
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
                         AutoSizeText("Lat : " +_addroutecontroller.chwoklatlong.latitude.toString()+ 
                        "   Lng : "+_addroutecontroller.chwoklatlong.longitude.toString(), textAlign: TextAlign.left)
                      )),
                    )
                     ))),
                     
                   SizedBox(height: 20,),
                      ClipRRect(
                        child:SizedBox(
                          height:50,
     child:ElevatedButton(onPressed: ()async{    
    
    _addroutecontroller.changeisEdit(true);
    
    //FIRST OF ALL LETS VALIDATE ODA #####################################################
    var x =  await _addroutecontroller.validateOda( widget.selectedOdaNo);
    odaValidator=x;
    var y =  await _addroutecontroller.validateMarg( widget.selectedMarg);
    maargValidator=y;
    //FIRST OF ALL LETS VALIDATE ODA #####################################################
    var z =  await _addroutecontroller.validateBar( widget.selectedBar);
    baarValidator=z;
    var a =  await _addroutecontroller.validateInterval( widget.selectedInterval);
    pugneTimeValidator=a;
    //FIRST OF ALL LETS VALIDATE ODA #####################################################
    var b =  await _addroutecontroller.validatevehicleId(widget.selectedVehicleId);
    vehicleIDValidator=b;
    var c =  await _addroutecontroller.validateChowkLatLnf( widget.selectedlatLongchowk);
    chowkLatLongvalidator=c;
     
    if(_formKeyx.currentState.validate()  ) {
      //cov
      _addroutecontroller.editandSaveRoutes(
        routeId: widget.selectedRouteId,
      oda: widget.selectedOdaNo,
      marg: widget.selectedMarg,
      baar: widget.selectedBar ,
      timeInterval:widget.selectedInterval ,
      gaadiNo: widget.selectedVehicleId ,
       
      chowkLocation: widget.selectedlatLongchowk,
      onSuceess: ()async{
        print("On Success");
       await  makeEMptyselected();               
        widget.selectedlatLongchowk= LatLng(0.0, 0.0);
         _formKeyx.currentState.reset();  
         setState(() {
        _maargTextfieldController.clear();
        _timeintervalTextfieldController. clear();   
         });
      }
       
      ) ;
    }       
    //  
                         },
                          
                         child: Text("Save"))
                        )
                      )
                      ,SizedBox(height:20),
                         ]
                       )),
          )
      
      
    ,
        ),
        
      ),
    );
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
             widget.selectedlatLongchowk =LatLng(currentlatLng.latitude, currentlatLng.longitude);
          _addroutecontroller.changechok(GeoPoint(widget.selectedlatLongchowk.latitude, widget.selectedlatLongchowk.longitude));

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
 

 
        makeEMptyselected() async{
 _addroutecontroller.changeOda(null);
 _addroutecontroller.changebar(null);
 _addroutecontroller.changeVehicleId(null);
 _addroutecontroller.changechok(GeoPoint(0.0,0.0));
      widget.selectedOdaNo="";
    widget.selectedMarg='';
  widget.selectedBar='';
  widget.selectedInterval='';
  widget.selectedVehicleId='';
  widget.selectedlatLongchowk= LatLng(0.0, 0.0);
  _maargTextfieldController.clear();
  _timeintervalTextfieldController. clear();   
 _maargTextfieldController.clear();
      _timeintervalTextfieldController. clear();   
   
  } 
  
}