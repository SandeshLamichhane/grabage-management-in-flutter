import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';

   StreamSubscription <LocationData> locationStreamer;
class StreamDeviceController extends GetxController{
  final box=GetStorage();
 //vehicle id;
 String vehicleIdx='null';
 
  @override
  void dispose() {
    print("Dispose called");
   
  if(locationStreamer!=null){
   locationStreamer.cancel();
   box.write(boxStreaming, "false");
    setVehicleStreamingOff();
   super.dispose();
 }
  }

  static RxBool _isStreaming=false.obs;
  get isStreaming=>_isStreaming.value;
 bool recevingValue=false;
  setStreaming(bool value){
  recevingValue=value;

  if(locationStreamer!=null && value==false){
     _isStreaming.value=recevingValue;
   locationStreamer.cancel();
   box.write(boxStreaming, "false");
   setVehicleStreamingOff();
   print("Streaming cancee"+locationStreamer.toString());

 }else{
   enableService();
 }
}


//update lat long
void UpdateLatLongFirebase(LatLng latLng) async{
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  if(latLng==null){
    return;
  }
  //now lets update the firestore lat koong

  //if(vehicleIdx=='null'){
 //BotToast.showText(text: "Vehicle id is null");
 // return;
 // }

  GeoPoint gp=GeoPoint(latLng.latitude, latLng.longitude);
try{
  //if it is already streaming from another prevent it get it from box value;
//vehicleIdx
   FirebaseFirestore.instance.collection("vehicle").doc('GA-1-TA-1289').update({
   fieldTruckStreaming: true,
   fieldTruckLocation: gp
   }).catchError((e){BotToast.showText(text: e.toString());});

}
catch(error){
  BotToast.showText(text: error.toString());

}
  }
  Location location = Location();
//if the streaming is already done then.....
  enableService() async{
 try{
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

_serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
   await location.enableBackgroundMode(enable: true);
  if (!_serviceEnabled) {
    return;
  }
}

_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
    return;
  }
}
  _isStreaming.value=recevingValue;
      getCurrentLocation();
  }
  catch(error){
    BotToast.showText(text: error.toString());

  }


  }
 
void getCurrentLocation() async {
  box.write(boxStreaming,  "true");
   LocationData _currentPosition;
    _currentPosition = await location.getLocation();
    print("Streaming start");
    //_initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
  locationStreamer= location.onLocationChanged.listen((LocationData currentLocation) {
      print("Stream"+" ${currentLocation.longitude} : ${currentLocation.longitude}");
    
     // setState(() {
        _currentPosition = currentLocation;
  
   _currentPosition = currentLocation;
          UpdateLatLongFirebase(LatLng(_currentPosition.latitude,_currentPosition.longitude));

      //  DateTime now = DateTime.now();
     //  dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
       // _getAddress(_currentPosition.latitude, _currentPosition.longitude)
         //   .then((value) {
      //    setState(() {
        //    _address = "${value.first.addressLine}";
       //   });
        });
    //  });
  //  });//
}
// $$$$$$$$$$$$$$$$$$$$$$$$$$$$ HAHA ///////////////////////////////////////////////////////////

  loadVehicleIdForUserId()async{
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Internet connection required.");
   return null;
  }
  try{
  var snapshot= await FirebaseFirestore.instance.collection("vehicle").where(fieldDriverid, arrayContainsAny: [ box.read(boxUserId)]).get().catchError((err){
    BotToast.showText(text: err.toString());
  });
  if(snapshot.docs.length<1){
    BotToast.showText(text: "Unable to  find vehicle id.");
  }else{
  snapshot.docs.forEach((element) { 
   var mappedData= element.data();
  var vehicleId=mappedData[fieldvehicleId];
  print(vehicleId);
  box.writeIfNull(boxVehicleId, "null");
  box.write(boxVehicleId, vehicleId );
  vehicleIdx=box.read(boxVehicleId);
  });
  }
  }
  catch(exc){
    BotToast.showText(text: exc.toString());
  }

}
//////////////////////////////////////////////////////////////////////////DISABLE STREAM
void setVehicleStreamingOff() async{
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  
  //now lets update the firestore lat koong

  //if(vehicleIdx=='null'){
 //BotToast.showText(text: "Vehicle id is null");
 // return;
 // }

 try{
  //if it is already streaming from another prevent it get it from box value;
//vehicleIdx
   FirebaseFirestore.instance.collection("vehicle").doc('GA-1-TA-1289').update({
   fieldTruckStreaming: false,
   
   }).catchError((e){BotToast.showText(text: e.toString());});

}
catch(error){
  BotToast.showText(text: error.toString());

}
  }

}