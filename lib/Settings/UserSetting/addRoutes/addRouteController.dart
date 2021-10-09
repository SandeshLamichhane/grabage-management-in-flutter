import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/addRoutes/addRoutesModel.dart';
class AddRouteController extends GetxController {

   
    final box= GetStorage();
    List<RouteModel> listofRoutes;

  RxBool _hasNumberofRoutes=false.obs;
  bool get hasNumberofRoutes=>_hasNumberofRoutes.value;

RxString _odaObs="".obs;
RxString _barObs="".obs;
RxString _vehicleNoObs="".obs;
RxString _chwoklaylongObs="".obs;
var _xlatlong=GeoPoint(0.0, 0.0).obs;

RxBool _isEdit=false.obs;
bool get  isEdit=>_isEdit.value;

RxBool _refreshTable=false.obs;
bool get refreshTable=>_refreshTable.value;

changeRefreshTable(bool value){
  _refreshTable.value=value;
}


String get  odaObs=>_odaObs.value;
String get  barObs=>_barObs.value;
String get  vehicleIdObs=>_vehicleNoObs.value;
GeoPoint get  chwoklatlong=>_xlatlong.value;

changeisEdit(bool x){  _isEdit.value=x;} 
changeOda(String x){  _odaObs.value=x;} 
changebar(String x){  _barObs.value=x;} 



changeVehicleId(String x){  _vehicleNoObs.value=x;} 




changechok(GeoPoint x){   _xlatlong.value=x;} 

    List<String> listofVehicleId;
 //oda validator
 validateOda(String odaNo){
 if(odaNo==null || odaNo==''){
   return "select";
 }
 return null;
 }
//marga validator
  validateMarg(String selectedMarg) {
    print(selectedMarg);
     if(selectedMarg==null || selectedMarg==''){
   return "Is Null";
 }
 if(_isEdit.value==true){

  return null;
 }
 return doesChowkAlreadyExist(selectedMarg);
 }

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ALL DATA FROM SERVER 88888888888888888888
retrieveVehicleIDFromServer() async{
   
listofVehicleId=[];
 
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
}

DisplayLoading.show(text: "loading vehicles....", display: true);
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("vehicle").get().catchError((e){
     BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  });

  if(dataSnapshot.docs.length<1){
      BotToast.showText(text: "No vehicle found on server", duration:Duration(seconds: 4));
      return;
   }else{
   Map<String, dynamic> d;
    dataSnapshot.docs.forEach((element) { 
      var mappedData= element.data();
      var vehicleId=mappedData[fieldvehicleId];
       listofVehicleId.add(vehicleId);
     
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

  validateBar(String selectedBar) {
    if(selectedBar==''|| selectedBar==null){
      return "select";
    }
    return null;
  }

  validateInterval(String selectedInterval) {
    if(selectedInterval==''|| selectedInterval==null){
      return "time to reach chowk";
    }
  String text= selectedInterval;
 RegExp regExp = new RegExp(
  r"^[0-9]{1,2}[.][0-9]{1,2}[-][0-9]{1,2}[.][0-9]{1,2}[/][AM, PM]{2}$",
  caseSensitive: true,
  multiLine: false,
);
if(!regExp.hasMatch(text)){
    return "Invalid vehicle No Pattern";
}
    return null;
}

validatevehicleId(String selectedVehicleId) {
  if(selectedVehicleId==''|| selectedVehicleId==null){
    //return 'select';
  }
  return null;

}

validateChowkLatLnf(LatLng selectedlatLongchowk) {
  if(selectedlatLongchowk==null || selectedlatLongchowk.latitude==0.0){
    BotToast.showText(text: "We didnot receive any LATLNG For chowk.");
   return null;
  } 
}

/////////////////////////////////////////////LIST OF VEHICLE ID $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ check chowk already exists ^^^^^^^^^^^^^^^^^^

doesChowkAlreadyExist(String chowk)async{
  bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
  }  else{
  try{
   
    DisplayLoading.show(text: "validating chowk....", display: true);
    var data= await FirebaseFirestore.instance.collection('routes').where(  fieldmarg, isEqualTo: chowk).get().
    catchError((onError){BotToast.showText(text: onError.toString());});
   if(data.docs.length <1){
 
     return null;
   }else{
       return "chowk already exists";
   }

    
  }catch(err){
    BotToast.showText(text: err.toString());
    return "error";

  }
  finally{
    DisplayLoading.show(text: "Validating vehicle No....", display: false);
    
  }

  }}
//>>>>>>>>>>>>>>>>>>>>>>>>>>>....................ADD NEW ROUTES >>>>>>>>>>>>>>>>>>>>
  void addNewRoutes({
     String oda,
    String marg,
    String baar,
    String timeInterval,
    String gaadiNo,
    String chowk,
     VoidCallback onSuceess,
      LatLng  chowkLocation
}) async {

  //insert the data into the vehivle firestore table$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

   
  if(box.read(boxuserRole)=='admin' || box.read(boxuserRole)=='moderator'){
  }else{
    BotToast.showText(text: "No permission to add");
    return;
  }
 
  DisplayLoading.show(text: "Adding....", display: true);
 GeoPoint _gp=GeoPoint(chowkLocation.latitude, chowkLocation.longitude);
 //cretae list of search keyword
  var searchword=createSearchKeywordFromString(marg);
  //lets create id  
  //
  String routeId= DateTime.now().microsecondsSinceEpoch.toString();
        RouteModel routeModel;
        routeModel= new RouteModel(
          routeId: routeId,
          oda: oda,
          marga: marg,
          baar: baar,
          interval: timeInterval,
          truckNo: gaadiNo ,
          chowkLocation: _gp,
          searchKeyword: searchword,
           );

 
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("routes").doc(routeModel.routeId).
  set(
     routeModel.toMap(routeModel)
    /*{
      fieldvehicleId: vehicleId,
      fieldDriverid: driverIds,
      fieldTruckLocation:gp
       }*/
       
       ).
  catchError((e){
    BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  });   
  onSuceess();
   BotToast.showText(text: "Successfully Saved.");
   onSuceess();
 }catch(err){
       BotToast.showText(text:"Error on adding : "+ err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }

}

  List<String> createSearchKeywordFromString(String x) {
       List<String> newSearchKeyword=[]; 
   if(x!=null)  {
     String lasword='';
 
    List<String> searchKeyWord= x.split('');
    
     searchKeyWord.forEach((element) {
      lasword=lasword+element;
       newSearchKeyword.add(lasword);
       
     });
  }
  return newSearchKeyword;
  }

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<RETRIEVE ROUTES >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ LOAD ALL TRUCK FROM FIRESTORE AND STORE HERE $$$$$$$$$$$$
  loadAllRoutesFromFirestore() async{
 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

  listofRoutes=[];
  DisplayLoading.show(text: "Loading route info....", display: true);
 try{
  var dataSnapshot=await FirebaseFirestore.instance.collection("routes").get().catchError((e){
     BotToast.showText(text:"Server error " +e.toString(), duration: Duration(seconds: 4) );
  });
  
  if(dataSnapshot.docs.length<1){
      BotToast.showText(text: "No routes found on server", duration:Duration(seconds: 4));
      _hasNumberofRoutes.value=false;
      return;
   }else{
     _hasNumberofRoutes.value=true;

  Map<String, dynamic> mappedData= Map();
 
  dataSnapshot.docs.forEach((element) { 
  mappedData= element.data();
 
 
  String odaNo=mappedData[fieldoda];

  String maarg=mappedData[fieldmarg];

  String baar= mappedData[fieldbaar];

  String interval=mappedData[fieldtimeInterval];

  String vehicleId=mappedData[fieldvehicleId];

   GeoPoint chowkLatLng= mappedData[fieldchowkLatLng];

   var routeId=mappedData[fieldrouteId];

  
   
  List  searchKey =mappedData[fieldsearchKeyword];
 
 List<String> listofSearchKey;
listofSearchKey=searchKey.map((e)=> e as String).toList();
 //  print(listofSearchKey);
listofRoutes.add(
  RouteModel(
  routeId: routeId,
  oda: odaNo,
  marga: maarg,
  baar: baar,
  interval: interval,
  truckNo: vehicleId==null || vehicleId==''?'Not assigned' :vehicleId,
  chowkLocation: chowkLatLng,
  searchKeyword: listofSearchKey,
     ));
    
  });
 }
 }
  catch(err){
       BotToast.showText(text: err.toString());
     }
     finally{
       DisplayLoading.show(text: "Retrieving....", display: false);
_refreshTable.value= !_refreshTable.value;
     }

}
/////////////////////////////////////////////////////EDIT AND SAVEm %%
  void editandSaveRoutes({
    String routeId,
     String oda,
    String marg,
    String baar,
    String timeInterval,
    String gaadiNo,
    String chowk,
     VoidCallback onSuceess,
      LatLng  chowkLocation
}) async {

  //insert the data into the vehivle firestore table$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

   
  if(box.read(boxuserRole)=='admin' || box.read(boxuserRole)=='moderator'){
  }else{
    BotToast.showText(text: "No permission to add");
    return;
  }
 
  DisplayLoading.show(text: "Saving....", display: true);
 GeoPoint _gp=GeoPoint(chowkLocation.latitude, chowkLocation.longitude);
 //cretae list of search keyword
  var searchword=createSearchKeywordFromString(marg);
  //lets create id  
  //
        RouteModel routeModel;
        routeModel= new RouteModel(
          routeId: routeId,
          oda: oda,
          marga: marg,
          baar: baar,
          interval: timeInterval,
          truckNo: gaadiNo ,
          chowkLocation: _gp,
          searchKeyword: searchword,
           );

 
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("routes").doc(routeModel.routeId).
  set(
     routeModel.toMap(routeModel)
    /*{
      fieldvehicleId: vehicleId,
      fieldDriverid: driverIds,
      fieldTruckLocation:gp
       }*/
       
       ).
  catchError((e){
    BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  });   
  onSuceess();
   BotToast.showText(text: "Successfully Saved.");
   onSuceess();
 }catch(err){
       BotToast.showText(text:"Error on Saving : "+ err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }

}

  void deleteFromServer(String routeId,  VoidCallback  onSuccess) async{

   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  

  //if the route id present in other user account/ prevent from delete 
  //NOTE THIS NEED TO BE DONE LATER
          DisplayLoading.show(text: "Deleting....", display: true);

 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("routes"). doc(routeId).delete().catchError((e){
     BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  }).whenComplete(() {
    onSuccess();
   BotToast.showText(text: "Successfully deleted");
  });     
 }
     catch(err){
       BotToast.showText(text: err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }

  }

}
























 


     


