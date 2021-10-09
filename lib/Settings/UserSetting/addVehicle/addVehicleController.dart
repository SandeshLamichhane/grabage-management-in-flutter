import 'dart:async';
 
 
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
 import 'package:waste/Settings/UserSetting/addVehicle/vehicleModal.dart';
 StreamSubscription<QuerySnapshot<Map<String, dynamic>>> vehicleStreamer;

 StreamController<QuerySnapshot<Map<String, dynamic>>> vehicleStreamercontroller = 
 StreamController<QuerySnapshot<Map<String, dynamic>>>();

class AddVehicleController extends GetxController{

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

 if(vehicleStreamer!=null){
    vehicleStreamer.cancel();
 }

  }
  final box=GetStorage();
  List<String> driverList;
  List<Map<String,dynamic>> driverLists;
    List<VehicleModal> listOfVehicles;

var _hasNoOfTrucks=false.obs;
bool get hasNoOfTrucks=>_hasNoOfTrucks.value;
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
var  _showvehicleInMap=false.obs;
bool get showvehicleInMap=>_showvehicleInMap.value;

var  _gettingStreamValue=false.obs;
bool get gettingStreamValue=>_gettingStreamValue.value;

changeshowvehiclesInMap(bool val){
_showvehicleInMap.value=val;
}
// ******************************************GADI NO *********************************
Future<String> doesGadiNoAlreadyExists(String gadiNo)async{
   bool exists=true;  
  if(gadiNo=="" || gadiNo==null ){
    return "required";
  }
String text= gadiNo;
 RegExp regExp = new RegExp(
  r"^[A-Z]{2}[-][0-9]{1,2}[-][A-Z]{1,2}[-][0-9]{1,4}$",
  caseSensitive: true,
  multiLine: false,
);
if(!regExp.hasMatch(text)){
    return "Invalid Gadi No Pattern";
}
 bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
  }  else{

  try{
   
    DisplayLoading.show(text: "Validating vehicle No....", display: true);
    var data= await FirebaseFirestore.instance.collection('vehicle').where(fieldvehicleId, isEqualTo:gadiNo).get().
    catchError((onError){BotToast.showText(text: onError.toString());});
   if(data.docs.length <1){
     exists=false;
     return null;
   }else{
       return "Vehicle No already exists";
   }

    
  }catch(err){
    BotToast.showText(text: err.toString());
    return "error";

  }
  finally{
    DisplayLoading.show(text: "Validating vehicle No....", display: false);
    
  }
 
  }

  
  }
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ALL DATA FROM SERVER 88888888888888888888
 retrieveDriverFromServer() async{
   driverList=[];
   driverLists=[];
 
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  DisplayLoading.show(text: "Retrieving....", display: true);
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("users").where('userRole',isEqualTo: 'driver'). where('userBlockState',isEqualTo: 'no').get().catchError((e){
     BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  });

  if(dataSnapshot.docs.length<1){
      BotToast.showText(text: "No driver found on server", duration:Duration(seconds: 4));
      return;
   }else{
   Map<String, dynamic> d;
    dataSnapshot.docs.forEach((element) { 
      var mappedData= element.data();
      var userPhone=mappedData['userPhone'].toString().substring(4);
      var userName= mappedData['userName'];
      var userId= mappedData['userId'];
      
     driverLists.add(toMap(display: userPhone+"(" +userName+')', value: userId));
     
    }) ;
    
     }
 }
     catch(err){
       BotToast.showText(text: err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }

    }


     Map<String, dynamic> toMap({ String display, String value}) {
    return {
      'display':  display,
      'value':  value,
    };
  }
//////////////////////////////////////////////////////checking for driver aaaa######################
  doesDriverAlreadyExists(List<dynamic> stringlist) async{
    print(stringlist);
   List<String>   str= stringlist.map((e) => e as String).toList();
  if(str.toList().length<1    ){
    return "select";
  }
      
  bool hasInterent= await hasInsternet();
    
  if(!hasInterent){
  }  else{
    try{
     DisplayLoading.show(text: "Validating driver....", display: true);
    var data= await FirebaseFirestore.instance.collection('vehicle').where(fieldDriverid,  arrayContainsAny: str).get().
    catchError((onError){BotToast.showText(text: onError.toString());});
   if(data.docs.length <1){
          return null;
   }else{
       return " Driver already associated with another";
   }

  
     
  }catch(err){
    BotToast.showText(text: err.toString());
    return err.toString();

  }
  finally{
    DisplayLoading.show(text: "Validating vehicle No....", display: false);
  }

  }

  }

//insert the data into the vehivle firestore table$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
void AddNewVehicle({ String vehicleId,List<String> driverIds  , VoidCallback onSuceess, List<String>listofdriversPhone, List<String> listofdriversname }) async {
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
 
  if(driverIds.length<1  || driverIds.length>2  ){
   BotToast.showText(text:  "Either 1 or only 2 drivers accepted");
   return;
    
  }

  if(vehicleId==null || vehicleId==""){
    BotToast.showText(text:  "No vehicle");
    return;
  }
  if(box.read(boxuserRole)=='admin' || box.read(boxuserRole)=='moderator'){
  }else{
    BotToast.showText(text: "No permission to add");
    return;
  }
  //Before mapping data into firestore lets store name n  streaming
 GeoPoint gp=GeoPoint(28.0,86.0);
  
  DisplayLoading.show(text: "Adding....", display: true);
 
   VehicleModal vm;
        vm= new VehicleModal(vehicleId: vehicleId, driverID:driverIds,driverSName: listofdriversname, driverSPhone: listofdriversPhone, geoPoint: gp );

 
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("vehicle").doc(vm.vehicleId).
  set(
     vm.toMap(vm)
    /*{
      fieldvehicleId: vehicleId,
      fieldDriverid: driverIds,
      fieldTruckLocation:gp
       }*/
       
       ).
  catchError((e){
    BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  });   
   BotToast.showText(text: "Successfully Saved.");
   onSuceess();
 }catch(err){
       BotToast.showText(text:"Error on adding : "+ err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }

}

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ LOAD ALL TRUCK FROM FIRESTORE AND STORE HERE $$$$$$$$$$$$
  loadAlltruckFromFirestore() async{
 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;

  }

  listOfVehicles=[];
  DisplayLoading.show(text: "Loading trucks....", display: true);
 try{
  var dataSnapshot=await FirebaseFirestore.instance.collection("vehicle").get().catchError((e){
     BotToast.showText(text:"Server error " +e.toString(), duration: Duration(seconds: 4) );
  });

  if(dataSnapshot.docs.length<1){
      BotToast.showText(text: "No Truck found on server", duration:Duration(seconds: 4));
      _hasNoOfTrucks.value=false;
      return;
   }else{
     _hasNoOfTrucks.value=true;

   Map<String, dynamic> mappedData= Map();
  dataSnapshot.docs.forEach((element) { 
  mappedData= element.data();
  var vehicleNo=mappedData[fieldvehicleId];
  GeoPoint currentLocation= mappedData[fieldTruckLocation];
  bool isStreming=mappedData[fieldTruckStreaming] as bool;
 List currentDriverId=mappedData[fieldDriverid];
 List<String>listofDrivers=currentDriverId.map((e)=> e as String).toList();

List  listofuserNamePhone =mappedData[fieldDriverName];
List<String> lisofDriversName=listofuserNamePhone.map((e)=> e as String).toList();

List  listofPhone =mappedData[fieldDriverPhone];
List<String> lisofDriversPhone=listofPhone.map((e)=> e as String).toList();
  
listOfVehicles.add(VehicleModal(
  streaming: isStreming,
  vehicleId: vehicleNo, geoPoint: currentLocation,
   driverID:listofDrivers ,driverSName:lisofDriversName, driverSPhone:lisofDriversPhone));

        
    }) ;
    
     }
 }
     catch(err){
       BotToast.showText(text: err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }

}
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PHONE NAME FROM USER ID &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  Future<Map>  loadPhoneNameFromUserId(String userId) async{
    LocationData ld;
   
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
     ld.accuracy;
   BotToast.showText(text: "Try after Internet Connection");
   return null;
  }
  try{
  var documentData= await FirebaseFirestore.instance.collection('users').doc(userId).get().
    catchError((onError){BotToast.showText(text: onError.toString());});
    if(documentData.data()!=null){
       var mapData= documentData.data();
       return mapData;
       
    }else{
      return null;
    }

  }catch(error){
    BotToast.showText(text: error.toString());
    return null;

  }
  
}

  void removeCurrentTruckFromServer(String vehicleId, VoidCallback success) async{
    print(vehicleId);
 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
   if(box.read(boxuserRole)!='admin' ){
     BotToast.showText(text: "No permission to delete.");
    return;
  }
   DisplayLoading.show(text: "Deleting....", display: true);
  
   try{
     //check if user 
    
  
 await  FirebaseFirestore.instance.collection("vehicle").doc(vehicleId).delete().catchError((err){
  BotToast.showText(text: err.toString());
 }).whenComplete(()  {
   BotToast.showText(text: "Successfully deleted");
   success();
 });
 

   }
   catch(ex)
{
  BotToast.showText(text: ex.toString());
}
finally{
    DisplayLoading.show(text: "Retrieving....", display: false);

}
  }



 // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ LOAD ALL TRUCK FROM FIRESTORE AND STORE HERE $$$$$$$$$$$$
listeningtoTruckLiveUpdate() async{


 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;

  }

 try{
  vehicleStreamer=    FirebaseFirestore.instance.collection("vehicle").snapshots().listen((event) {
     print('Streaming...');
   if(event.docs.length<1){
      return;
   }else{
     _gettingStreamValue.value=!_gettingStreamValue.value;
  _hasNoOfTrucks.value=true;
  listOfVehicles=[];
   Map<String, dynamic> mappedData= Map();
  event.docs.forEach((element) { 
  mappedData= element.data();
  var vehicleNo=mappedData[fieldvehicleId];
  GeoPoint currentLocation= mappedData[fieldTruckLocation];
  bool isStreming=mappedData[fieldTruckStreaming] as bool;
 
 List currentDriverId=mappedData[fieldDriverid];
 List<String>listofDrivers=currentDriverId.map((e)=> e as String).toList();

List  listofuserNamePhone =mappedData[fieldDriverName];
List<String> lisofDriversName=listofuserNamePhone.map((e)=> e as String).toList();

List  listofPhone =mappedData[fieldDriverPhone];
List<String> lisofDriversPhone=listofPhone.map((e)=> e as String).toList();
  
listOfVehicles.add(VehicleModal(
  streaming: isStreming,
  vehicleId: vehicleNo, geoPoint: currentLocation,
   driverID:listofDrivers ,driverSName:lisofDriversName, driverSPhone:lisofDriversPhone));
 });
   }});
 }
     catch(err){
       BotToast.showText(text: err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);
     }
}  

//LETS HAVE THE REAL TIME UPDATE ############################################ 

//insert the data into the vehivle firestore table$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
void updateLatLongOfTruck({ String vehicleId,List<String> driverIds  , VoidCallback onSuceess, List<String>listofdriversPhone, List<String> listofdriversname }) async {
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
    return;
  }
 

  if(vehicleId==null || vehicleId==""){
      return;
  }
  if(box.read(boxuserRole)!='driver' ){
    return;
  }
 
  //Before mapping data into firestore lets store name n
 GeoPoint gp=GeoPoint(28.0,86.0);
  
  DisplayLoading.show(text: "Adding....", display: true);
 
   VehicleModal vm;
        vm= new VehicleModal(vehicleId: vehicleId, driverID:driverIds,driverSName: listofdriversname, driverSPhone: listofdriversPhone, geoPoint: gp );

 
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("vehicle").doc(vm.vehicleId).
  set(
     vm.toMap(vm)
    /*{
      fieldvehicleId: vehicleId,
      fieldDriverid: driverIds,
      fieldTruckLocation:gp
       }*/
       
       ).
  catchError((e){
    BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  });   
   BotToast.showText(text: "Successfully Saved.");
   onSuceess();
 }catch(err){
       BotToast.showText(text:"Error on adding : "+ err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }

}





 

  //Future<List<Address>> _getAddress(double lat, double lang) async {
   // final coordinates = new Coordinates(lat, lang);
  //  List<Address> add =
  //  await Geocoder.local.findAddressesFromCoordinates(coordinates);
   // return add;
  }

 
 

