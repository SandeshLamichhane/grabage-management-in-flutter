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
import 'package:waste/Settings/UserSetting/addHospitalRoute/addHospitalRouteModal.dart';
import 'package:waste/Settings/UserSetting/addRoutes/addRoutesModel.dart';
class ListofWeekBar {
 List< String> Weekbar;
  ListofWeekBar({this.Weekbar});
}

class AddHospitalRouteController extends GetxController {
 
final box= GetStorage();

RxList<HospitalRouteModel> _listofHospitalroute = RxList<HospitalRouteModel>();
List<HospitalRouteModel> get listofHospitalRoute=>_listofHospitalroute.toList();

//RxBool _hasNumberofRoutes=false.obs;
//bool get hasNumberofRoutes=>_hasNumberofRoutes.value;

RxString _HospitalName="".obs;
RxString _barObs="".obs;
RxString _vehicleNoObs="".obs;
RxString _districtObs="".obs;
RxString _chwoklaylongObs="".obs;
var _xlatlong=GeoPoint(0.0, 0.0).obs;

RxBool _isEdit=false.obs;
bool get  isEdit=>_isEdit.value;

RxBool _refreshTable=false.obs;
bool get refreshTable=>_refreshTable.value;

changeRefreshTable(bool value){
  _refreshTable.value=value;
}
 
List<String>  _listofSelectedWeekbar=[];

 var listweekbar=ListofWeekBar(Weekbar: []).obs;
changeweekbar(List<String> val){
  listweekbar.value.Weekbar=val;
}


List<String> get listofSelectedWeekbar=>_listofSelectedWeekbar ;


//String get  odaObs=>_odaObs.value;
String get  barObs=>_barObs.value;
String get  vehicleIdObs=>_vehicleNoObs.value;
GeoPoint get  chwoklatlongobs=>_xlatlong.value;
String get districtNameobs=>     _districtObs.value;


changeisEdit(bool x){  _isEdit.value=x;} 
// changeOda(String x){  _odaObs.value=x;} 
changebar(String x){  _barObs.value=x;} 
changeVehicleId(String x){  _vehicleNoObs.value=x;} 
changechok(GeoPoint x){  print(x.longitude); _xlatlong.value=x;} 
 changedistrict (String param0) {
_districtObs.value=param0;

    }

    List<String> listofVehicleId;
 //oda validator
 validateHospitalName(String odaNo){
 if(odaNo==null || odaNo==''){
   return "Enter Hospital Name";
 }
  if(_isEdit.value==true){
  return null;
 }
 return doesHospitalNameAlreadyExist(odaNo);
 

 }
//marga validator
  validateMarg(String selectedMarg) {
    print(selectedMarg);
     if(selectedMarg==null || selectedMarg==''){
   return "Is Null";
 }
 /////////////////////////////////// validate week baar ##############
    if(_isEdit.value==true){
  return null;
 }
 // return doesChowkAlreadyExist(selectedMarg);
 }

////////////////////////////
validateWeekBar(List selectedWeekBaarList) {
  if(selectedWeekBaarList==null){
   return "Select Weekday";
  }
  List<String> dynamicString=selectedWeekBaarList.map((e )  =>e as String).toList();
  if(dynamicString.contains('All weekday') && dynamicString.length>1){
    return "Wrong selection";
  }
    if(dynamicString.contains('Twice weekday') && dynamicString.length>1){
    return "Wrong selection";
  }
    if(dynamicString.contains('Thrice weekday') && dynamicString.length>1){
    return "Wrong selection";
  }
   if(dynamicString.length>3){
    return "More than 3 selected";
  }

return null;
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
    BotToast.showText(text: "Detect the the Hospital/labs in apps.");
   return null;
  } 
}

/////////////////////////////////////////////LIST OF VEHICLE ID $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ check chowk already exists ^^^^^^^^^^^^^^^^^^

doesHospitalNameAlreadyExist(String hospitalname)async{
  bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
  }  else{
  try{
   
    DisplayLoading.show(text: "checking hospital....", display: true);
    var data= await FirebaseFirestore.instance.collection('hospitalroutes').where( fieldhospitalName, 
    isEqualTo: hospitalname).get().
    catchError((onError){BotToast.showText(text: onError.toString());});
   if(data.docs.length <1){
 
     return null;
   }else{
       return "Hospital Name already exists";
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
//>>>>>>>>>>>>>>>>>>>>>>>>>>>....................ADD NEW ROUTES >>>>>>>>>>>>>>>>>>>>
 
  void addNewHospitalRoutes({
    String districtName,
    String hospitalName,
     String marg,
    List weekbaar,
    String timeInterval,
    String gaadiNo,
      LatLng  chowkLocation,
      VoidCallback onSuceess
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
 
  DisplayLoading.show(text: "Adding Hospital Route....", display: true);
 GeoPoint _gp=GeoPoint(chowkLocation.latitude, chowkLocation.longitude);
 //cretae list of search keyword
 List<String> listofWeekbar=weekbaar.map((e) => e as String).toList();
  var searchword=createSearchKeywordFromString(marg);
  //lets create id  
  //
  String routeId= DateTime.now().microsecondsSinceEpoch.toString();
        HospitalRouteModel routeModel;
        routeModel= new HospitalRouteModel(
          routeId: routeId,
          hospitalName: hospitalName,
          districtName: districtName,
          marga: marg,
          weekbaar: listofWeekbar,
          interval: timeInterval,
          truckNo: gaadiNo ,
          chowkLocation: _gp,
          searchKeyword: searchword,
           );

 
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("hospitalroutes").doc(routeModel.routeId).
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
  loadAllHospitalRoutesFromFirestore() async{
 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

  _listofHospitalroute.value=[];
  DisplayLoading.show(text: "Loading route info....", display: true);
 try{
  var dataSnapshot=await FirebaseFirestore.instance.collection("hospitalroutes").get().catchError((e){
     BotToast.showText(text:"Server error " +e.toString(), duration: Duration(seconds: 4) );
  });
  
  if(dataSnapshot.docs.length<1){
      BotToast.showText(text: "No hospital routes found on server", duration:Duration(seconds: 4));
  //    _hasNumberofRoutes.value=false;
      return;
   }else{
    // _hasNumberofRoutes.value=true;
 dataSnapshot.docs.forEach((element) {
   print(element.data());
 _listofHospitalroute.add(
   HospitalRouteModel.fromMap(element.data())
   ); 
    update();
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
  void editandSaveHospitalRoutes({
    String routeId,
    String districtName,
    String hospitalName,
     String marg,
    List weekbaar,
    String timeInterval,
    String gaadiNo,
      LatLng  chowkLocation,
      VoidCallback onSuceess
}) async {
  //insert the data into the vehivle firestore table$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

  if(box.read(boxuserRole)=='admin' || box.read(boxuserRole)=='moderator'){
  }else{
    BotToast.showText(text: "No permission to Edit");
    return;
  }

  DisplayLoading.show(text: "Saving. hospital route...", display: true);
 GeoPoint _gp=GeoPoint(chowkLocation.latitude, chowkLocation.longitude);
 //cretae list of search keyword
 var searchword=createSearchKeywordFromString(marg);
  //lets create id  
  List<String> listofWeekbar=weekbaar.map((e) => e as String).toList();
        var routeModel= new HospitalRouteModel(
          routeId: routeId,
          hospitalName: hospitalName,
          districtName: districtName,
          marga: marg,
          weekbaar: listofWeekbar,
          interval: timeInterval,
          truckNo: gaadiNo ,
          chowkLocation: _gp,
          searchKeyword: searchword,
           );
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("hospitalroutes").doc(routeModel.routeId).
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
  }).whenComplete(() {
  onSuceess();
   BotToast.showText(text: "Successfully Saved.");
 
  });   

 }catch(err){
       BotToast.showText(text:"Error on Saving : "+ err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }

}
/////////////////////////////////////////////////////DELETE DATA FROM SERVER #################
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
  var dataSnapshot=await  FirebaseFirestore.instance.collection("hospitalroutes"). doc(routeId).delete().catchError((e){
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

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DOES OTHER HAVE 
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ check chowk already exists ^^^^^^^^^^^^^^^^^^

doesOtherAccountholdHospName(String hospitalname, String routeId)async{
  print(hospitalname+ routeId+";;;;;;;;;;;;;;;");
  bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
  }  else{
  try{
  List<QueryDocumentSnapshot<Map<String, dynamic>>> listofQuerySnapshot;
 var snapshot=     FirebaseFirestore.instance.collection("hospitalroutes") ;
final allList = await snapshot.get();
final x= allList.docs.where((doc) => 
doc[fieldhospitalName] ==hospitalname );
listofQuerySnapshot= x.toList();
    


  
    
   if(listofQuerySnapshot.length <1){
     return null;
   }else{
       return "Hospital Name error";
   }    
  }catch(err){
    BotToast.showText(text: err.toString());
    return  err.toString();
  }
  finally{
    DisplayLoading.show(text: "Validating vehicle No....", display: false);
    
  }
  }
  }

 


}
























 


     


