import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/TrackRoutes/trackTodayRouteModel.dart';
import 'package:waste/Settings/UserSetting/addRoutes/addRoutesModel.dart';
import 'package:waste/Settings/UserSetting/addRoutes/weekDay.dart';

class  trackRoutesController extends GetxController
{
trackTodayRouteModal trackTodayRoute= new trackTodayRouteModal();

  Timer _timer;
  final box=GetStorage();
String _userId;

   RxList<trackTodayRouteModal> _listoftodayroute = RxList<trackTodayRouteModal>();
List<trackTodayRouteModal> get listofTodayRoute=>_listoftodayroute.toList();

 RxString _myVehicleId="".obs;
 RxBool _myTruckisStreaming=false.obs;

  
 RxBool _updateswitch=false.obs;
 get updateswitch=>false.obs;



List<RouteModel> listofRoutes;
List<String>_listofTodayRouteId;

List<trackTodayRouteModal> tracktodayRouteModal;

String get myVehicleId=>_myVehicleId.value;
bool get myTruckStreaming=>_myTruckisStreaming.value;

RxBool  _doestodayrouteFirestoreupdate=false.obs; 

RxBool _hasNoofTodayRoutes=false.obs;
bool get hasNoofTodayRoutes=> _hasNoofTodayRoutes.value;

  static RxBool _isStreaming=false.obs;
  get isStreaming=>_isStreaming.value;

var  daydiffobj=WeekdayDifference();
RxString _currentTime=    DateFormat("EE,MM-dd hh:mm:ss").format(DateTime.now()).toString().obs;
get currentTime=>_currentTime.value;
get gadiNo => null;

var _refreshTbale=false.obs;
bool get refreshTbale=>_refreshTbale.value;  
refreshRouteTable(){
  _refreshTbale.value=!_refreshTbale.value;

}
 
@override
void initState() { 
   _userId=box.read(boxUserId);
  
}
 
 void dispose() { 
   _timer.cancel();
   super.dispose();
 }



 updateTime(){
   _timer=Timer.periodic(Duration(seconds:1), (timer) {
   _currentTime.value=DateFormat("EE, MM-dd h:mm a").format(DateTime.now());
    });
 }
//REtrieve vehicel ID From Vehicle table
getVehicleIdFromDriverId(String uid)async{
  if(uid=="" || uid=="null"  || uid== null){
    return "required";
  }
 bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
  }  else{
  try{
    DisplayLoading.show(text: "Loading ....", display: true);
    var data= await FirebaseFirestore.instance.collection('vehicle').where(fieldDriverid, arrayContainsAny:  [uid] ).get().
    catchError((onError){BotToast.showText(text: onError.toString());}).whenComplete(( ) {
    });
   if(data.docs.length <1){
    BotToast.showText(text: "App didnot receive any vehicle for you. Contact your office administrator ", duration: Duration(seconds: 4));
     return null;
   }else{
       data.docs.forEach((element) {
 print(element.data());
         var datax=element.data();
         _myVehicleId.value=  datax[fieldvehicleId].toString();
    
        _isStreaming.value =element.data()[fieldTruckStreaming] as bool ;

       });
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


////////////////////////////////////Retrieve today vehicle id  
 
retrieveTodayRouteForVehicleID(String VehicleId)async{

  if(VehicleId=="" || VehicleId=="null"  || VehicleId== null){
    BotToast.showText(text: "Vehicle Id Is Null");
    return "required";
  }

listofRoutes=[];
_listofTodayRouteId=[];
 bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
      
  } else{
    
  try{
    DisplayLoading.show(text: "Loading routes ....", display: true);
     print(DateFormat('EEEE').format(DateTime.now())+"???????????????????/");
    var dataSnapshotx= await FirebaseFirestore.instance.collection('routes').where(fieldbaar , 
    isEqualTo: DateFormat('EEEE').format(DateTime.now())).
    get().catchError((onError){

      BotToast.showText(text: onError.toString());}) ;
   if(dataSnapshotx.docs.length<1){
    BotToast.showText(text:  DateFormat('EEEE').format(DateTime.now())+" has no routes", duration: Duration(seconds: 4));
     
   }else{

   
    print(dataSnapshotx.docs.length);
  Map<String, dynamic> mappedData= Map();
  dataSnapshotx.docs.forEach((element) { 
    print(element.toString());
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
    String x= DateFormat('dd-MM-yyyy').format(DateTime.now());
   String todayRoute= box.read(boxtodayroute);
bool setRouteId=   updateBoxValueoftodayRoute();


 _listofTodayRouteId.add((x+'-'+vehicleId+'-'+maarg).toString());
 
 doesTodayRoutesAlreadyExistsonServer( (x+'-'+vehicleId+'-'+maarg).toString(),
 (){
insertTemporaryrouteIdforFirstTime(
    vehicleId: vehicleId,
    marga: maarg,
    oda: odaNo,
    destinedtime: interval,
    coveredTime:  "",
    covered: false,
    driverId: box.read(boxUserId),
    driverName: box.read(boxuserName),
    todayRouteId:  (x+'-'+vehicleId+'-'+maarg).toString()
  );
 }
 
 );
   
    
  });
retrieveTodayRoutesFromnewFirestoreRoute();

   }

  }catch(err){
    BotToast.showText(text: err.toString());
    return "error";

  }
  finally{
    DisplayLoading.show(text: "Validating vehicle No....", display: false);
    refreshRouteTable();
    
  }
 
  }
}



///field Insert today routeId for the first time in current user #########################
void  insertTemporaryrouteIdforFirstTime(
 {String vehicleId,
 String marga,
  String oda,
  String destinedtime,
  String coveredTime,
  bool covered,
  String driverId,
  String driverName,
  String todayRouteId,
  String baar,
  int saturdayEpoch,
  VoidCallback onInsertSuccess
 }
  
  )async{
 bool hasInterent= await hasInsternet(); 

  if(!hasInterent){
   BotToast.showText(text: "No internet connection");
  }
  else{
  if(vehicleId=="" || vehicleId==null || vehicleId==''){
   BotToast.showText(text: "Vehicle Id is Null");
    return ;
  }
 try{
   //doc-id=>vehicleid-date-time
   print('////////// '+todayRouteId);
     String y= DateFormat('yyyy-MM-dd').format(DateTime.now());
      y= y+' 08:00:00';
       DateTime lastDay = DateTime.parse(y);
        int millisecondDate = lastDay.millisecondsSinceEpoch;
   var trackTodayRoute= new trackTodayRouteModal(
              todayRouteId:  todayRouteId,
              todayDate:  saturdayEpoch==null? millisecondDate : saturdayEpoch,// insert time of 9
              baar:baar==null || baar==""? DateFormat('EEEE').format(DateTime.now()): "Saturday",
              marga: marga,
              oda: oda,
              vehicleId: vehicleId,
              destined: destinedtime,
              covered: covered ,
              coveredTimed: coveredTime ,
              firestoreUpdloadtime: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
              driverID:driverId ,
              driverName:driverName ,
              offline: 'online'
               );
  var dataSnapshot=await  FirebaseFirestore.instance.collection("dayroute").doc(todayRouteId).set(
trackTodayRoute.toMap(trackTodayRoute)) 
     .whenComplete(() {
   onInsertSuccess();
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


/// does today #########################/////////////////////////////////////////////////
doesTodayRoutesAlreadyExistsonServer( 
  String todayRouteId,
  VoidCallback onNew,
  )async{
 bool hasInterent= await hasInsternet(); 

  if(!hasInterent){
   BotToast.showText(text: "No internet connection");
  }
  else{
  if(todayRouteId=="" || todayRouteId==null || todayRouteId=='null'){
   BotToast.showText(text: "unable to receive today id");
    return ;
  }
 try{
var dataSnapshot=await  FirebaseFirestore.instance.collection("dayroute").doc(todayRouteId).get().catchError((er){
  BotToast.showText(text: er.toString());
}).whenComplete(() {
 
});
 var x=DateFormat('dd-MM-yyyy').format(DateTime.now());

if(dataSnapshot.data()==null){
   _doestodayrouteFirestoreupdate=false.obs; 
  String newString= x+'-'+'add';
  box.write(boxtodayroute, newString);
 onNew ();

//here he
}else{
   _doestodayrouteFirestoreupdate=true.obs; 
     String newString= x+'-'+'nottoadd';
  box.write(boxtodayroute, newString);
   print(box.read(boxtodayroute));
    
}

 }
  catch(err){
   BotToast.showText(text: err.toString());
   return true;
    }
 finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }
  } 

}

updateBoxValueoftodayRoute(){
box.writeIfNull(boxtodayroute,  '00-00-0000-0000');
var xyz=DateFormat('dd-MM-yyyy').format(DateTime.now());
 String yestardayDate=box.read(boxtodayroute).toString().substring(0,10);
  int length=box.read(boxtodayroute).toString().length;
  String laswWord=box.read(boxtodayroute).toString().substring(10, length);

 if(xyz==yestardayDate){

    if(laswWord=='add'){
      return true;
    }

  String newString= xyz+'-'+'nottoadd';
    return false;
 }else{
 String newString= xyz+'-'+'add';
  box.write(boxtodayroute, newString);
  return true;
 }
}
/////////////////////////////////////RETRIEVE TODAY ROUTES FROM SERVER $$$$$$$$$$$$$$$$$$
retrieveTodayRoutesFromnewFirestoreRoute()async{
bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   return ;
  }

  try{
  
  DisplayLoading.show(text: "Retrieving....", display: true);
 tracktodayRouteModal=[];
 _listoftodayroute.value=[];
if(_listofTodayRouteId.length>=1){
       
    _listofTodayRouteId.forEach((element) async {
   var snapshot=  await FirebaseFirestore.instance.collection("dayroute").where(fieldtodayrouteId, 
   isEqualTo: element).get().catchError((e){
     BotToast.showText(text: e.toString());
   });
   if(snapshot.docs.length<1){
     BotToast.showText(text: "Creating routes...");
   }else{
      snapshot.docs.forEach((element) {
        var MappedData=element.data();
           tracktodayRouteModal.add(trackTodayRouteModal.fromMap(MappedData));
           _listoftodayroute.add(trackTodayRouteModal.fromMap(MappedData));
      });
         _hasNoofTodayRoutes.value=true;   
      print(hasNoofTodayRoutes);
   }
  });
  }
  else{
    _hasNoofTodayRoutes.value=true;
  }
  }
  catch(error){
    BotToast.showText(text: error.toString());

  }
  finally{
            DisplayLoading.show(text: "Retrieving....", display: false);

  }
}
////////////////// LETS UPDATE THE DAY ROUTES #######################
  void changeCoveredAndTime(String todayRouteId, bool val, String selectedTime, VoidCallback onSuccess) async{
 bool hasInterent= await hasInsternet(); 
if(!hasInterent){
  BotToast.showText(text: "Try again later");
   return ;
  }

try{     
     DisplayLoading.show(text: "updating....", display: true);
await  FirebaseFirestore.instance.collection("dayroute").doc(todayRouteId).update({
  fieldcovered:val,
  fieldcoveredtime:selectedTime,
   fieldfirestoreuploadtime:DateTime.now()
}).catchError((er){
  BotToast.showText(text: er.toString());
}).whenComplete(() {
  BotToast.showText(text: "Successfully Saved");
  _updateswitch.value=!_updateswitch.value;
   onSuccess();
 });
 
 }
  catch(err){
   BotToast.showText(text: err.toString());
    }
 finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }
  } 

  // if it is sataurday check the uncomplete route and  create the root
  void createRouteForSaturday(String vehicleId) async{
      //dt1=dt1+ ' 11:27:00';

    var x=  DateTime.now();
      String y= DateFormat('yyyy-MM-dd').format(DateTime.now());
      y= y+' 08:00:00';
       DateTime lastDay = DateTime.parse(y).subtract(Duration(days: 7));
        int millisecondDate = lastDay.millisecondsSinceEpoch;

//lets qeuery database
 bool hasInterent= await hasInsternet(); 
 List<QueryDocumentSnapshot<Map<String, dynamic>>> listofQuerySnapshot;
  if(!hasInterent){ 
   BotToast.showText(text: "No internet connection");
  }
  else{

 try{
var snapshot=     FirebaseFirestore.instance.collection("dayroute") ;
final allList = await snapshot.get();
final x= allList.docs.where((doc) => 
    doc[fieldvehicleId] == vehicleId
    &&  doc[fieldtodayDate] >=  millisecondDate && doc[fieldcovered] ==  false );
    listofQuerySnapshot= x.toList();
    

 
 if(listofQuerySnapshot.length<1){
   BotToast.showText(text: "No Routes for Satudarday");
 }else{
//insert into dayroute
listofQuerySnapshot.forEach((element) {
  var mappedData= element.data();
  print(mappedData.toString()+'{}{}{}{}{}{}{}');
});
/*
insertTemporaryrouteIdforFirstTime(
    vehicleId: vehicleId,
    marga: maarg,
    oda: odaNo,
    destinedtime: interval,
    coveredTime:  "",
    covered: false,
    driverId: box.read(boxUserId),
    driverName: box.read(boxuserName),
    todayRouteId:  (x+'-'+vehicleId+'-'+maarg).toString()
  );
*/
 }


 }
  catch(err){
   BotToast.showText(text: err.toString());
 
    }
 finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }
    
   }
  }
// UPGRADE To SATURDAY ###############################################
  void upgradeToSaturday(
    {String todayRouteId,
   String vehicleId, String maarg, String odaNo, String interval,
  
   Null Function() param1 }) async{
 bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   BotToast.showText(text: "No Internet");
   return ;
  }

  if(todayRouteId==null || todayRouteId==""){
    return;
  }
  //determine next saturday 
  var x=WeekdayDifference().nextSaturday();
String idformat=x[0];
String saturdayRouteId=idformat+todayRouteId.substring(10);
 

  
       DateTime nextSaturaday = DateTime.parse(x[1]);
        int nextSaturdayepoch = nextSaturaday.millisecondsSinceEpoch;
insertTemporaryrouteIdforFirstTime(
     baar:'Saturday',
     saturdayEpoch:nextSaturdayepoch,
    vehicleId:  vehicleId,
    marga: maarg,
    oda: odaNo,
    destinedtime: interval,
    coveredTime:  "",
    covered: false,
    driverId: box.read(boxUserId),
    driverName: box.read(boxuserName),
    todayRouteId:  saturdayRouteId.toString(),

    onInsertSuccess: (){
      print('Saturday Insert Successfull');
     //make online to nextline
    updateonlinetoNextLine(todayRouteId, (){
      print("Update to offline to online success.");
      param1();
    });
     // 
    }
    
  );
 }
  

updateonlinetoNextLine(String todayrouteId, VoidCallback onlineSuccess ) async{
   bool hasInterent= await hasInsternet(); 
  if(!hasInterent){
  BotToast.showText(text: "Try again later");
   return ;
  }
  try{
         DisplayLoading.show(text: "updating....", display: true);
   var snapshot= FirebaseFirestore.instance.collection('dayroute').doc(todayrouteId).update({
     fieldoffline:'offline'
   }).whenComplete(() {
     onlineSuccess();
   }).catchError((e){
     BotToast.showText(text: e.toString());
     
   });

  }catch(ex){
    BotToast.showText(text: ex.toString());
  }finally{
         DisplayLoading.show(text: "updating....", display: false);

  }

}
// Update the time of the $$$$$$$$$$$$$$$ trashed $$$$$$$$$$$$$$$$$$$$$$$$$$

  void updateTimeofTrashed(String todayRouteId, TimeOfDay time1, Null Function() param1) async {

 bool hasInterent= await hasInsternet(); 
  if(!hasInterent){
  BotToast.showText(text: "Try again later");
   return ;
  }
  try{
         DisplayLoading.show(text: "updating....", display: true);
   var snapshot= FirebaseFirestore.instance.collection('dayroute').doc(todayRouteId).update({
     fieldcoveredtime: time1.hour.toString()+" : "+time1.minute.toString()
   }).whenComplete(() {
     param1();
   }).catchError((e){
     BotToast.showText(text: e.toString());
     
   });

  }catch(ex){
    BotToast.showText(text: ex.toString());
  }finally{
         DisplayLoading.show(text: "updating....", display: false);
  }

  }

////// GET THE REMAINING ROUTE FOR SATURDAY #############################################
retrieveSaturdayRoutesFromnewFirestoreRoute(String vehicleId, )async{
bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   return ;
  }

var xyz=WeekdayDifference().nextSaturday();
String abcd=xyz[2];
//next saturday route id///////////////////////////////////
 //now lets have the millisecond epoch for it
//lets have saturday morning and evening time
try{
print(DateTime.now());
var saturdayMorning  =abcd+ ' 01:10:00';
 var inputedEndtTime = DateTime.parse(saturdayMorning);
 var saturdayMorningEpoch = inputedEndtTime.millisecondsSinceEpoch;
  
var saturdaynight  =abcd+ ' 23:50:00';
 var inputedEndtTime1 = DateTime.parse(saturdaynight);
 var saturdayNightEpoch = inputedEndtTime1.millisecondsSinceEpoch;
 
print("M:"+saturdayMorningEpoch.toString()+"N :"+saturdayNightEpoch.toString());

if(vehicleId==null || vehicleId==""){
  BotToast.showText(text: "Vehicle Id is Null");
  return;
}
 


   //if(_selectedVehicleId.value=="None" && _selectedMarga.value=="") {
     
   // }
 
    List< QueryDocumentSnapshot<Map<String, dynamic>>> listofQuerySnapshot;
  DisplayLoading.show(text: "Retrieving....", display: true);
  var snapshot=     FirebaseFirestore.instance.collection("dayroute") ;
  final allList = await snapshot.get();
   final x= allList.docs.where((doc) => doc[fieldvehicleId]==vehicleId &&
     doc[fieldtodayDate] >=  saturdayMorningEpoch && doc[fieldtodayDate] <=  saturdayNightEpoch);
      listofQuerySnapshot= x.toList();
 tracktodayRouteModal=[];
 _listoftodayroute.value=[];
 
 
   if(listofQuerySnapshot.length<1){
     BotToast.showText(text: "No remainging routes for saturday.");
   }else{
      listofQuerySnapshot.forEach((element) {
        var MappedData=element.data();
           _listoftodayroute.add(trackTodayRouteModal.fromMap(MappedData));
      });
         _hasNoofTodayRoutes.value=true;   
      print(hasNoofTodayRoutes);
   }
 
  }
  catch(error){
    BotToast.showText(text: error.toString());

  }
  finally{
            DisplayLoading.show(text: "Retrieving....", display: false);
  }
}
 
}
 