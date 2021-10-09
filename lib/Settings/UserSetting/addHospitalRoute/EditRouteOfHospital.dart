import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/textfield.dart';
import 'package:waste/Settings/UserSetting/addHospitalRoute/addHospitalRouteController.dart';

class EditHospitalRoutes extends StatefulWidget {
  int index;
   EditHospitalRoutes(this.index);
  @override
  _EditHospitalRoutesState createState() => _EditHospitalRoutesState();
}

class _EditHospitalRoutesState extends State<EditHospitalRoutes> {
  final _addhospitalroutecontroller= Get.put(AddHospitalRouteController());
 
  var _formKey= GlobalKey<FormState>();
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

GoogleMapController myController;
TextEditingController _hospitaltextController;
TextEditingController _margfieldController;
TextEditingController _timeIntervalTextfield;
LatLng currentlatLng=
 
new LatLng(0.0, 0.0);
@override
  void initState() {
    // TODO: implement initState
    super.initState();
         hospitalNameValidator=null;
       districtNameValidator=null;
       maargValidator=null;
        baarValidator=null;
       pugneTimeValidator=null;
        vehicleIDValidator=null;
        chowkLatLongvalidator=null;
         
//set the value to the specific textfield
        _hospitaltextController = TextEditingController(text:  _addhospitalroutecontroller.listofHospitalRoute[widget.index].hospitalName);
       _margfieldController = TextEditingController(text:  _addhospitalroutecontroller.listofHospitalRoute[widget.index].marga);
_timeIntervalTextfield= TextEditingController(text:  _addhospitalroutecontroller.listofHospitalRoute[widget.index].interval);
        
        _addhospitalroutecontroller.changedistrict( _addhospitalroutecontroller.listofHospitalRoute[widget.index].districtName); 
  _addhospitalroutecontroller.changeVehicleId  ( _addhospitalroutecontroller.listofHospitalRoute[widget.index].truckNo); 

      //   _addhospitalroutecontroller.changebar  (widget.selectedBar); 
        _addhospitalroutecontroller.changechok(GeoPoint(_addhospitalroutecontroller.listofHospitalRoute[widget.index].chowkLocation.latitude,
  _addhospitalroutecontroller.listofHospitalRoute[widget.index].chowkLocation.longitude));
      _addhospitalroutecontroller.changeweekbar(null);
     _addhospitalroutecontroller.changeweekbar(_addhospitalroutecontroller.listofHospitalRoute[widget.index].weekbaar);


   selectedHospitalName= _addhospitalroutecontroller.listofHospitalRoute[widget.index].hospitalName;
  selectedMarg=      _addhospitalroutecontroller.listofHospitalRoute[widget.index].marga;

  selecteddistrict= _addhospitalroutecontroller.listofHospitalRoute[widget.index].districtName;

  selectedInterval= _addhospitalroutecontroller.listofHospitalRoute[widget.index].interval;

  selectedVehicleId= _addhospitalroutecontroller.listofHospitalRoute[widget.index].truckNo;

  selectedlatLongchowk= LatLng( _addhospitalroutecontroller.listofHospitalRoute[widget.index].chowkLocation.latitude,
                                 _addhospitalroutecontroller.listofHospitalRoute[widget.index].chowkLocation.longitude);
       
   _selectedWeekBaarList= _addhospitalroutecontroller.listofHospitalRoute[widget.index].weekbaar;

    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit the Routes"),
        ),
        body: Form(
                   key: _formKey,
                   child: Container(
                   child:ListView(
                   padding: EdgeInsets.symmetric(horizontal: 20.0),
                   children: <Widget>[
                     
       SizedBox(height: 10,),
       AutoSizeText("Chalne route Edit garnuhos.", 
                   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)),
       SizedBox(height:15),                  
//      
  // ############################ ENTER HOSPITAL #####################################################
  HospitalNameTextField(
    nameController: _hospitaltextController,
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
  DropdownSearch  (
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
                          nameController: _margfieldController,          
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
           // Obx(()=>(
            // GetBuilder(
              // init:_addhospitalroutecontroller ,
             //  builder: (_addhospitalroutecontroller)=>
                 GetX<AddHospitalRouteController>(
                   init:AddHospitalRouteController(),
                   builder: (controller) =>MultiSelectFormField(
                     close:(){
                       print("close");
                     } ,
                     change:(c){
                       print(c);
                     },
                                                          
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
                        initialValue: 
                        //_addhospitalroutecontroller.listofHospitalRoute[widget.index].weekbaar,
                        controller.
                        listweekbar.value.Weekbar!=null?  controller.listweekbar.value.Weekbar:null,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                       WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                       
                          _selectedWeekBaarList=value;
                          
                          });
                        },
                                ),
                 )
               //),
           //  )
             //)
                              //)
               ,
                       
                           SizedBox(height:10),
 ////////////////////////////////////////// TIME INTERVAL //////////////////////////////////////////////////ROUTE
    TimeInterValTextField(
      nameController: _timeIntervalTextfield,
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
    print(_addhospitalroutecontroller.listweekbar.value.Weekbar);

//FIRST OF ALL LETS VALIDATE ODA #####################################################
_addhospitalroutecontroller.changeisEdit(true);
var a =  await _addhospitalroutecontroller.validateHospitalName(selectedHospitalName);
hospitalNameValidator=a;
//var j=await _addhospitalroutecontroller.doesOtherAccountholdHospName(
 // selectedHospitalName,_addhospitalroutecontroller.listofHospitalRoute[widget.index].routeId);
//hospitalNameValidator=j;
print(selectedHospitalName);
var y =  await _addhospitalroutecontroller.validateMarg( selectedMarg);
maargValidator=y;
print(selectedMarg);
//FIRST OF ALL LETS VALIDATE ODA #####################################################
var z =  await _addhospitalroutecontroller.validateWeekBar( _selectedWeekBaarList);
baarValidator=z;
print(z);
print(_selectedWeekBaarList.toList().toString());
var as =  await _addhospitalroutecontroller.validateInterval( selectedInterval);
pugneTimeValidator=as;
print(selectedInterval);
//FIRST OF ALL LETS VALIDATE ODA #####################################################
var b =  await _addhospitalroutecontroller.validatevehicleId(selectedVehicleId);
vehicleIDValidator=b;
print(selectedVehicleId);
var c =  await _addhospitalroutecontroller.validateChowkLatLnf( selectedlatLongchowk);
chowkLatLongvalidator=c;
print(selectedlatLongchowk);
   //cov
  
if(_formKey.currentState.validate()) {
 
  
  _addhospitalroutecontroller.editandSaveHospitalRoutes(
   routeId:_addhospitalroutecontroller.listofHospitalRoute[widget.index].routeId,
    districtName:selecteddistrict,
      hospitalName: selectedHospitalName,
    marg: selectedMarg,
    weekbaar: _selectedWeekBaarList ,
    timeInterval:selectedInterval ,
    gaadiNo: selectedVehicleId ,
   
    chowkLocation: selectedlatLongchowk,
    onSuceess: ()async{

       print("Successfully Edited.");
        _addhospitalroutecontroller.loadAllHospitalRoutesFromFirestore();
      await  _addhospitalroutecontroller.changeVehicleId(null);
  _addhospitalroutecontroller.changedistrict(null);
      _addhospitalroutecontroller.changebar(null);
             _addhospitalroutecontroller.changeweekbar(null);
       _addhospitalroutecontroller.changechok(GeoPoint(0.0,0.0));
 
         _margfieldController.text='';
   _hospitaltextController.text='';
   _timeIntervalTextfield.text='';

   setState(() {
   });
    }
     
  ) ;
}       
//  
                       },
                        
                       child: Text("Save")),
      ),
      
    )])))));
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

  makeEMptyselected() {
    _addhospitalroutecontroller.changedistrict(null);
      _addhospitalroutecontroller.changebar(null);
      _addhospitalroutecontroller.changeVehicleId(null);
            _addhospitalroutecontroller.changeweekbar(null);
       _addhospitalroutecontroller.changechok(GeoPoint(0.0,0.0));
       _margfieldController.clear();
       _hospitaltextController.clear();
       _timeIntervalTextfield.clear();
       
     //  _margfieldController.dispose();
     //  _hospitaltextController.dispose();
     //  _timeIntervalTextfield.clear();

    
  selectedMarg='';
  selectedInterval='';
  selectedVehicleId='';
  selectedHospitalName='';
  selecteddistrict='';
  selectedlatLongchowk= LatLng(0.0, 0.0);
  }
 
}