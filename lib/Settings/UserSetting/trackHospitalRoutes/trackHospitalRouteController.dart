import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/time.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/addRoutes/weekDay.dart';
import 'package:waste/Settings/UserSetting/trackHospitalRoutes/trackHospitalModal.dart';

class HospitalRouteController extends GetxController{
 
  RxList<TrackHospitalRouteModal> agentList = RxList<TrackHospitalRouteModal>();
List<TrackHospitalRouteModal> get listoftodayHospitalRoute=>agentList.toList();
  final box=GetStorage();
  String  todayBaar=DateFormat("EEEE").format(DateTime.now());

////////////////////////////////////Retrieve today vehicle id  
 
createTodayRouteForVehicleID(String VehicleId)async{
  if(VehicleId=="" || VehicleId=="null"  || VehicleId== null){
    BotToast.showText(text: "Vehicle Id Is Null");
    return "required";
  }
 bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
  } else{   
    var dataSnapshotx= await FirebaseFirestore.instance.collection('hospitalroutes').
    where(fieldvehicleId, isEqualTo: VehicleId.trim()).get().catchError((onError){
      BotToast.showText(text: onError.toString());}) ;
   if(dataSnapshotx.docs.length<1){
    BotToast.showText(text: "No hospital routes for your vehicle Id");
   }else{
  Map<String, dynamic> mappedData= Map();
  dataSnapshotx.docs.forEach((element) { 
  mappedData= element.data();
  
  List baar= mappedData[fieldbaar];
  List<String> weekbaar=baar.map((e) => e as String).toList();
  // In list of weekbar if has sunday and today is sunday create create the routes//
  // In list of weekbar if it is all weekday , then create the routes//
  //In the list of weekbar if it is twice week day cretae the route//
  //In the list of weekbar if it is thrice a weekday create route with unkwonn baar
 String HospitalName=mappedData[fieldhospitalName];
 String maarga=mappedData[fieldmarg];
 String districtName=mappedData[fielddistrictName];

 GeoPoint latLang=    mappedData[fieldchowkLatLng];

 String vehicleId=mappedData[fieldvehicleId];
 String driverName= mappedData[fieldDriverName];
 String destinedTime=mappedData[fieldtimeInterval];
//all weekday
 weekbaar.forEach((weekelement) {
 
// all weekday #####################################################
   if(weekelement=="All weekday"){
     //insert into the  database
     doesAllweekdayAlreadyExists(vehicleId,HospitalName,(){
    insertHospitalRoutes(
      covered: ['null'],coveredTime: ['null'],
      weekBaar: [weekelement], HospitalName: HospitalName,districtName: districtName,
                           LatLang: latLang,maarga: maarga,vehicleId: vehicleId, driverName: driverName,
                               destinedtime:destinedTime );
   });
   }

// twice days in the week ##################################
   if(weekelement=="Twice weekday"){
         doestwiceweekdayAlreadyExists(vehicleId,HospitalName,
         (){
           print("Insert twice in weekabar");
             insertHospitalRoutes(
        covered: ['null', 'null'],coveredTime: ['null','null'],
      weekBaar:[ weekelement], HospitalName: HospitalName,districtName: districtName,
              LatLang: latLang,maarga: maarga,vehicleId: vehicleId, driverName: driverName,
             destinedtime:destinedTime );
           }
         ); 
   }

/////////////////////////////THRICE DAYS IN A WEEK  ///////////////////////
   if(weekelement=="Thrice weekday"){
      doestwiceweekdayAlreadyExists(vehicleId,HospitalName,
      (){
      insertHospitalRoutes(
           covered: ['null','null','null'],coveredTime: ['null','null','null'],
           weekBaar: [weekelement], HospitalName: HospitalName,districtName: districtName,
                           LatLang: latLang,maarga: maarga,vehicleId: vehicleId, driverName: driverName,
                            destinedtime:destinedTime );
   });
   }

  ////////////////////////////// FOR THE CERTAIN DAYS IN WEEK #################
    if(weekelement==DateFormat('EEEE').format(DateTime.now())){
      doesAllweekdayAlreadyExists(vehicleId,HospitalName,(){
     insertHospitalRoutes(
      covered: ['null'],coveredTime: ['null'],
      weekBaar: [weekelement], HospitalName: HospitalName,districtName: districtName,
                           LatLang: latLang,maarga: maarga,vehicleId: vehicleId, driverName: driverName,
                               destinedtime:destinedTime );
   }); 
   }
 });
  }) ;  
  
    DisplayLoading.show(text: "Loading routes ....", display: false);
  }}}

  void insertHospitalRoutes( {
 //lets lets create
 String HospitalName,
 String maarga,
 String districtName,
 GeoPoint LatLang,
 String vehicleId,
 String destinedtime,

List<String>covered,
List<String> coveredTime,
  
  String driverId, 
  String driverName,
   List<String> weekBaar,
   String todayRouteId,
  Timestamp saturdayEpoch  
  }) 
 async{
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
    String y= DateFormat('yyyy-MM-dd').format(DateTime.now());
    String todayRouteId=y+'-'+vehicleId+'-'+HospitalName;

    y= y+' 08:00:00';
     DateTime lastDay = DateTime.parse(y);
        int millisecondDate = lastDay.millisecondsSinceEpoch;
   var trackTodayRoute= new TrackHospitalRouteModal(
              todayRouteId:  todayRouteId,
              todayDate:  saturdayEpoch==null? millisecondDate : saturdayEpoch,// insert time of 9
              weekBaar: weekBaar,
              maarga: maarga,
              HospitalName: HospitalName,
              vehicleId: vehicleId,
              destined: destinedtime,
              covered: covered ,
              coveredTime:  coveredTime ,
              firestoreUpdloadtime: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
              driverId:box.read(boxUserId) ,
              driverName:box.read(boxuserName) ,
              
              
               );
 await  FirebaseFirestore.instance.collection("hospdayroute").doc(todayRouteId).set(
trackTodayRoute.toMap(trackTodayRoute)) 
     .whenComplete(() {
   BotToast.showText(text: "Route Created");
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
  
 
/////////////////////////////////////RETRIEVE TODAY ROUTES FROM SERVER $$$$$$$$$$$$$$$$$$
retrieveTodayHospitalRoutesFromFirestoreRoute(String vehicleId)async{
bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   return ;
  }
 
    agentList.value=[];
 
  try{
  DisplayLoading.show(text: "Loading hospital route....", display: true);
  String abc=DateFormat('yyyy-MM-dd').format(DateTime.now());
    var morningDate=abc+ ' 01:00:00';
  var x = DateTime.parse(morningDate);
  var morningTimeepoch = x.millisecondsSinceEpoch;
print('morning epoch'+morningTimeepoch.toString());
   var m=abc+ ' 23:40:00';
  var y = DateTime.parse(m);
  var eveningTimeepoch = y.millisecondsSinceEpoch;
  print('evening epoch'+eveningTimeepoch.toString());

  int previousSundayEpoch= WeekdayDifference().previousSundaywithTime();
 int nextSaturdayEpoch= WeekdayDifference().nextSaturdaywithTime();



 List<QueryDocumentSnapshot> listofSnapshot;
   var snapshot=  await FirebaseFirestore.instance.collection("hospdayroute").
   where(fieldvehicleId, isEqualTo: vehicleId).
   //where(fieldtodayDate, isGreaterThan: morningTimeepoch).
  // where(fieldtodayDate, isLessThan: eveningTimeepoch).
   get().catchError((e){
     BotToast.showText(text: e.toString());
   });
final listofTodayRoute= snapshot.docs.where((doc) {
  List  xyz=doc[fieldbaar] as List ;
List<String> abc=xyz.map((e) => e as String).toList();
return 
doc[fieldtodayDate] >= morningTimeepoch &&  doc[fieldtodayDate] <= eveningTimeepoch ||
   abc.contains("Twice weekday") || abc.contains("Thrice weekday") &&
   doc[fieldtodayDate] >= previousSundayEpoch  &&  doc[fieldtodayDate] <= nextSaturdayEpoch;

 
 
  
});
     // doc[fieldbaar] == todayBaar || //if the baar is today
       //doc[fieldbaar]=="All weekday"// && 
   // doc[fieldtodayDate] >= morningTimeepoch &&  doc[fieldtodayDate] <= eveningTimeepoch// if its weekday
    // || doc[fieldbaar] == "Twice weekday"  ||  doc[fieldbaar] == "Thrice weekday"  &&
     //  doc[fieldtodayDate] >= previousSundayEpoch  &&  doc[fieldtodayDate] <= nextSaturdayEpoch
   //  );
  listofSnapshot=listofTodayRoute.toList();
   if(listofSnapshot.length<1){
    // BotToast.showText(text: "Create route for today.");
   }else{
       listofSnapshot.forEach((element) {
        var mappedData=element.data();
           print("<><><><><><><><>"+element.data().toString());
           agentList.add(TrackHospitalRouteModal.fromMap(mappedData));
           update();
      });
   }
  
  }
  catch(error){
    BotToast.showText(text: error.toString());

  }
  finally{
            DisplayLoading.show(text: "Retrieving....", display: false);
 
  }
}
// update covered or not in the firestore ############################@@@@@@@@@@@@@@@@@@@@

updateCoveredTimex(String todayRouteId,
 List<String> covered, 
 List<String> weekBaar, 
  
 bool val, Null Function() param4)async{
List<String>_picked=[];
String currenthourminute=DateFormat("hh:mm").format(DateTime.now());
List<String>_pickedTime=[];

//first check weekBar
 if(weekBaar.contains('All weekday')){
   //it means it has all only one cover time
   if(val==true){
    _picked=["Picked"];
    
   }else{
  _picked=["null"];
 
   }
 }
 /////////////////////////////// certain weekbat
 if(weekBaar.contains(DateFormat('EEEE').format(DateTime.now()))){
  //only one cover time
     if(val==true){
 _picked=["Picked"];
 //////////
 
   }else{
  _picked=["null"];
 

   }
}

 String todayBaar=DateFormat("EEEE").format(DateTime.now());



  if(weekBaar.contains('Twice weekday')){
    print("Twice weekbar"+ covered[0].toString() +'/'  + covered[1].toString());
    //check  the 
  print(val.toString());
   bool iserror=false;
  if(val==true &&  covered[0]=="null" && covered[1]=="null"){
    _picked=[todayBaar, "null"];
  }
  else if(   val==false &&  covered[0]==todayBaar && covered[1]=="null"){
    _picked= ["null", "null"] ;
  }
  else if( val==true &&  covered[0]!=todayBaar && covered[1]=="null"){
    _picked= [covered[0], todayBaar] ;
  }
  else if(  val==false&& covered[0]!=todayBaar && covered[1]==todayBaar){
    _picked= [ covered[0],  'null'];
  }else{
    BotToast.showText(text: "Ooops...");
    return;
  }

 if(iserror){
   print(_picked.toString());
   BotToast.showText(text: "Something went wrong");
   return;
 }
 //it means it has  two cover time
 }




  if(weekBaar.contains('Thrice weekday')){
   //it means it has  three cover time
    bool iserror=false;
    print(val);
    print(todayBaar);
     //check  the 
  val==true &&  covered[0]=="null" && covered[1]=="null" && covered[2]=="null" ?
  _picked=[todayBaar, "null","null"] :

  val==false &&  covered[0]==todayBaar && covered[1]=="null" && covered[2]=="null" ?
      _picked= ["null", "null","null"] :

   val==true &&  covered[0]!=todayBaar && covered[1]=="null" && covered[2]=="null" ?
      _picked= [ covered[0], todayBaar,"null"] :

   val==false&& covered[0]!=todayBaar && covered[1]==todayBaar && covered[2]=="null" ?
  _picked= [ covered[0],  "null","null"] :

     val==true &&  covered[0]!=todayBaar && covered[1]!=todayBaar && covered[2]=="null" ?
      _picked= [ covered[0], covered[1],todayBaar] :

       val==false &&  covered[0]!=todayBaar && covered[1]!=todayBaar && covered[2]==todayBaar ?
      _picked= [ covered[0], covered[1],"null"] :
  
  
   iserror=true;
 if(iserror){
   BotToast.showText(text: "Oops...");
   return;
 }
 }


 bool hasInterent= await hasInsternet(); 
if(!hasInterent){
 BotToast.showText(text: "Try again later");
 return ;
  }

try{     
     DisplayLoading.show(text: "updating....", display: true);
await  FirebaseFirestore.instance.collection("hospdayroute").doc(todayRouteId).update({
  fieldcovered: _picked,
   fieldfirestoreuploadtime:DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now())
}).catchError((er){
  BotToast.showText(text: er.toString());
}).whenComplete(() {
  BotToast.showText(text: "Successfully Saved");
   param4();
 });
 
 }
  catch(err){
   BotToast.showText(text: err.toString());
    }
 finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     }
  }
 
///////////////////////////////////////// does twice weekday already present:::::::::::::::::::
   Future<String> doestwiceweekdayAlreadyExists(String vehicleId, 
   String hospitalName,  VoidCallback onNew) async{

    bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   return "error";
  }
 try{
    String y= DateFormat('yyyy-MM-dd').format(DateTime.now());
    String todayRouteId=y+'-'+vehicleId+'-'+hospitalName;
//get the 7 days epoch
 int previousSundayEpoch= WeekdayDifference().previousSundaywithTime();
 int nextSaturdayEpoch= WeekdayDifference().nextSaturdaywithTime();

  var abcd;
   var snapshot=  await FirebaseFirestore.instance.collection("hospdayroute").
  
   where(fieldtodayDate, isGreaterThan: previousSundayEpoch).
   where(fieldtodayDate, isLessThan: nextSaturdayEpoch).
   get().catchError((e){
     BotToast.showText(text: e.toString());
   });

final listofTodayRoute= snapshot.docs.where((doc) =>
      doc[fieldvehicleId] == vehicleId  &&  doc[fieldhospitalName]==hospitalName);
      abcd= listofTodayRoute.toList();
   if(abcd.length>=1){
     print("Week twice or thrice routes already present");
     BotToast.showText(text: "Week routes present already.");
    return 'notadd';
   }else{
  onNew();
   }
//check hospital name and
 }catch(e){
   BotToast.showText(text: e.toString());
     return null;
 }
  }
//     $$$$$$$$$$$$$$$$$$  UPDATE TIME OF TRASHED ######################################
  void updateTimeofTrashed(
    String todayRouteId,
     List<String> covered,
     List<String> coveredTime,
      List<String> weekBaar,
       TimeOfDay selectedTime,
        Null Function() param4)async {

List<String>_picked=[];
String currenthourminute=DateFormat("hh:mm").format(DateTime.now());
List<String>_pickedTime=[];

String _newTmeofTrashed=selectedTime.hour.toString()+ " : "+selectedTime.minute.toString();

//first check weekBar ALL DAY WEEKBAR ##############################
 if(weekBaar.contains('All weekday')){
   //it means it has all only one cover time
  if(selectedTime!=null){
   _pickedTime=  [_newTmeofTrashed];
  }else{
     _pickedTime=  ["null"];
     }
   }
 
 /////////////////////////////// certain weekbat
 if(weekBaar.contains(DateFormat('EEEE').format(DateTime.now()))){
  //only one cover time
     if(selectedTime!=null){
   _pickedTime=  [_newTmeofTrashed];
  }else{
     _pickedTime=  ["null"];
     }
}

 String todayBaar=DateFormat("EEEE").format(DateTime.now());

  if(weekBaar.contains('Twice weekday')){

   bool iserror=false;

  if(selectedTime!=null &&  covered[0]=="null" && covered[1]=="null"){
    _pickedTime=[_newTmeofTrashed, "null"];
  }
  else if(selectedTime!=null &&  covered[0]==todayBaar && covered[1]=="null"){
  _pickedTime=[_newTmeofTrashed, "null"];
  }
  else if( selectedTime!=null &&  covered[0]!=todayBaar && covered[1]=="null"){
     _pickedTime=[coveredTime[0], _newTmeofTrashed];
  }
  else if(selectedTime!=null && covered[0]!=todayBaar && covered[1]==todayBaar){
       _pickedTime=[coveredTime[0], _newTmeofTrashed];

  }else{
    BotToast.showText(text: "Ooops...");
    return;
  }
 
 //it means it has  two cover time
 }




  if(weekBaar.contains('Thrice weekday')){
   //it means it has  three cover time
    bool iserror=false;
 
  selectedTime!=null &&  covered[0]=="null" && covered[1]=="null" && covered[2]=="null" ?
  _pickedTime=[_newTmeofTrashed, "null", "null"]:

 selectedTime!=null  &&  covered[0]==todayBaar && covered[1]=="null" && covered[2]=="null" ?
     _pickedTime=[_newTmeofTrashed, "null", "null"]:

 selectedTime!=null  &&  covered[0]!=todayBaar && covered[1]=="null" && covered[2]=="null" ?
      _pickedTime=[coveredTime[0], _newTmeofTrashed, "null"]: 

  selectedTime!=null && covered[0]!=todayBaar && covered[1]==todayBaar && covered[2]=="null" ?
  _pickedTime=[coveredTime[0], _newTmeofTrashed, "null"] :

  selectedTime!=null  &&  covered[0]!=todayBaar && covered[1]!=todayBaar && covered[2]=="null" ?
    _pickedTime=[coveredTime[0],coveredTime[1], _newTmeofTrashed] :

     selectedTime!=null  &&  covered[0]!=todayBaar && covered[1]!=todayBaar && covered[2]==todayBaar ?
     _pickedTime=[coveredTime[0], coveredTime[1], _newTmeofTrashed] :
     iserror=true;
 if(iserror){
   BotToast.showText(text: "Oops...");
   return;
 }
 }
   
bool hasInterent= await hasInsternet(); 
if(!hasInterent){
 BotToast.showText(text: "Try again later");
 return ;
  }

try{     
     DisplayLoading.show(text: "updating time...", display: true);
await  FirebaseFirestore.instance.collection("hospdayroute").doc(todayRouteId).update({
  fieldcoveredtime: _pickedTime,
   fieldfirestoreuploadtime:DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now())
}).catchError((er){
  BotToast.showText(text: er.toString());
}).whenComplete(() {
  BotToast.showText(text: "Successfully Saved");
   param4();
 });
 
 }
  catch(err){
   BotToast.showText(text: err.toString());
    }
 finally{
        DisplayLoading.show(text: "Retrieving....", display: false);

     } 
}


///////////////////////////////////////// does twice weekday already present:::::::::::::::::::
   Future<String> doesAllweekdayAlreadyExists(String vehicleId, 
   String hospitalName,  VoidCallback onNew) async{

  bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   return "error";
  }
 try{
    String y= DateFormat('yyyy-MM-dd').format(DateTime.now());
    String todayRouteId=y+'-'+vehicleId+'-'+hospitalName;
 
  var abcd;
   var snapshot=  await FirebaseFirestore.instance.collection("hospdayroute").
   doc(todayRouteId).get().catchError((e){
     BotToast.showText(text: e.toString());
   });
 
   if(snapshot.data()==null){
     onNew();   
   }else{
   print("Todays Routes already present");
     BotToast.showText(text: "Todays route already present.");
    return 'notadd';
   }
//check hospital name and
 }catch(e){
   BotToast.showText(text: e.toString());
     return null;
 }
  }
} 
/*
 
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
 
 

/*
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
*/
*/
  
 