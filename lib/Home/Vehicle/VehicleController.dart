import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waste/Home/Vehicle/displayVehicleModal.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/weekday/week.dart';

class VehicleInfoController extends GetxController{
var vehickeModal=displayvehicleModal();
  final box=GetStorage();
  //vehicle arrived time
  RxString _arrivalTime="00:00".obs;
  String get arrivalTime=>_arrivalTime.value;

 RxString _daysLater="0 days later".obs;
 String get daysLater=>_daysLater.value;

 RxString _dateofarrival="0 baisakh".obs;
 String get dateofarrival=>_dateofarrival.value;
 

  RxString  _arrivalvehicleNo="".obs;
 String get arrivalvehicleNo=>_arrivalvehicleNo.value;
 
 GoogleMapController myMapController;

 LatLng _currentLatLang=LatLng(28.287932,86.7687567); 
 LatLng get currentLatLang=>_currentLatLang;

  RxString _isStreaming  = "Offline".obs; 
 String get isStreaming=>_isStreaming.value;

 Marker _marker=Marker(markerId: MarkerId("100"),
  infoWindow: InfoWindow(title: "Offline", snippet: "Stream : No data available."),
  icon: BitmapDescriptor.defaultMarker, position: LatLng(28.00, 86.898));
Circle _circle=Circle(circleId: CircleId("1000"),  radius: 1000,);

Marker get marker=>_marker;
Circle get circle=>_circle;

@override
void initState() { 
 
  
}
String userFrom="";
 

void loadVehicleInfo()async{
 //
 //
 // LoadHomeUserTodayRoute(maarg:"sandes", oda: "17", truckNo: "GA-1-TA-1289" );
// loadHomeUserFromTemporary(maarg:"sandes", oda: "17", truckNo: "GA-1-TA-1289", 
// onNoSatRoute:  (){
//LoadHomeUserTodayRoute(maarg:"sandes", oda: "17", truckNo: "GA-1-TA-1289" );
/// } );


//from hospital
 LoadHospitalUserTodayRoute(HospitalName: "sandesh aurved");
 

  if(box.read(boxuserType)=="Home"){  
   bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   return ;
  }

 String maarg;
 String oda;
 String truckNo;
  
  
  }
  if(box.read(boxuserType)=="Hospital"){
    //user from hospital
  }

  if(box.read(boxuserType)=="Guest"){
 // user as Guest
  }
  if(box.read(boxuserType)=="Guest" && box.read(boxuserRole)=="admin"){
    //if admin reload the page
  }

 if(box.read(boxuserType)=="Guest" && box.read(boxuserRole)=="moderator"){
    //if admin reload the page
  }

 if(box.read(boxuserType)=="Guest" && box.read(boxuserRole)=="driver"){
    //if admin reload the page
  }

}



 // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ LOAD ALL TRUCK FROM FIRESTORE AND STORE HERE $$$$$$$$$$$$
listeningtoTruckLiveUpdate(BuildContext context, VoidCallback onChnage) async{
 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

 try{
      FirebaseFirestore.instance.collection("vehicle").doc('GA-1-TA-1289').snapshots().listen((event) async{
 
   if(event.data()==null){
     BotToast.showText(text: "Unable to load truck for you data");
      return;
   }else{
    //if stream is off offline
    var offline=event.data()[fieldTruckStreaming];
    bool isStreaming=offline as bool;
 
     if(isStreaming){
       GeoPoint gp=event.data()[fieldTruckLocation];
       _currentLatLang=LatLng(gp.latitude, gp.longitude);
   
//set pokhara location and set
// set stream is off

  //  LatLng latlng= LatLng(newLocation.latitude,newLocation.longitude);
     Uint8List imageData= await getMarker(context);// 
      _marker=Marker(
        markerId: MarkerId("home"),
        position:_currentLatLang,
         rotation: 90,
        draggable: false,
        zIndex: 2,
        flat:true,
        infoWindow: InfoWindow(title: "Current Location", snippet: "Stream : $isStreaming"),
        anchor: Offset(0.5,0.5),
        icon: BitmapDescriptor.fromBytes(imageData));


       _circle=Circle(circleId: CircleId("car"),
          radius:  createDynamicRadius(_currentLatLang),
          center: _currentLatLang,
          zIndex: 1,
          strokeColor: Colors.blue,
           fillColor: Colors.blue.withAlpha(7));
     }
  

 update();
  onChnage();
 
 }
      });
 }
     catch(err){
       BotToast.showText(text: err.toString());
     }
     finally{
        DisplayLoading.show(text: "Retrieving....", display: false);
     }
}  
//////////////////////////////////////////////////
Future<Uint8List> getMarker(BuildContext context) async {
    ByteData byteData =await DefaultAssetBundle.of(context).load('assets/car.png');
    return byteData.buffer.asUint8List();
  }

  double createDynamicRadius(LatLng latlng) {
  
  double radius=100;
   List<String>listoflatitude=latlng.latitude.toString().split('');
   List<String>listoflongitude=latlng.longitude.toString().split('');

 listoflatitude.length<=2? radius=250000:
 listoflatitude.length==3? radius=1200:
  listoflatitude.length==4? radius=5000:
   listoflatitude.length==5? radius=1650:
    listoflatitude.length==6? radius=2500:
     listoflatitude.length==7? radius=3000:
      listoflatitude.length==8? radius=2400:
       listoflatitude.length==9? radius=1100:
        listoflatitude.length==10? radius=2000:
         listoflatitude.length==11? radius=1200:
          listoflatitude.length==12? radius=1000:
           listoflatitude.length==13? radius=900:
            listoflatitude.length==14? radius=700:
             listoflatitude.length==15? radius=500:
              listoflatitude.length==16? radius=200:radius=1000;
 
  return radius;
  }


//load the homeuser routes  &&&&&&&&&&&&&&&&&&& LOAD FROM ROUTES #######################

  void LoadHomeUserTodayRoute({String maarg, String oda, String truckNo}) async {
      List<QueryDocumentSnapshot> queryDocs;
   try{
  DisplayLoading.show(text: "Loading....", display: true);
   var snapshot=     FirebaseFirestore.instance.collection("routes") ;
     final allList = await snapshot.get();
   if(maarg!="" &&  truckNo!="" ) {
    final x= allList.docs.where((doc) => 
    doc[fieldvehicleId] ==truckNo
    &&  doc[fieldmarg] == maarg && doc[fieldoda]==oda);
    queryDocs= x.toList();
 print(queryDocs.length);
 if(queryDocs.length<1){
   BotToast.showText(text: "Routes are unavailable.");
 }
 else{
   queryDocs.forEach((element) {
     // vehickeModal.vehicleId=element[fieldvehicleId];
     _arrivalvehicleNo.value=element[fieldvehicleId];
     // if the baar already gone
     vehickeModal.timeInterval=element[fieldtimeInterval];
     _arrivalTime.value= vehickeModal.timeInterval;

    vehickeModal.baar= Week().getWeekName(element[fieldbaar]);
    _dateofarrival.value=vehickeModal.baar;
   ///////////////////////////
   vehickeModal.daysLater=Week().getDaysLater(element[fieldbaar]);
  _daysLater.value=vehickeModal.daysLater;
     
   });

 }

    }else{
      BotToast.showText(text: "text");
    }
  }catch(er){
    BotToast.showText(text: er.toString());
  }
  finally{
      DisplayLoading.show(text: "Retrieving....", display: false);
  }
 
}

//load the data from temporary routes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loadHomeUserFromTemporary({String maarg, String oda, String truckNo, VoidCallback onNoSatRoute}) async {
  String saturdayRouteId;
  
 saturdayRouteId=Week().nextSaturday()+"-"+truckNo+'-'+maarg;
 print(saturdayRouteId);
//saturdayRouteId='02-08-2021-GA-1-TA-1289-kalimatiy';
   try{
  DisplayLoading.show(text: "Loading....", display: true);
   var snapshot=    await FirebaseFirestore.instance.collection("dayroute").where(
     fieldtodayrouteId, isEqualTo: saturdayRouteId
   ).get()
   .catchError((e){
  BotToast.showText(text: e);
   });
 
 
 if(snapshot.docs.length<1){
  BotToast.showText(text: "No Sat Route");
  onNoSatRoute();
 }
 else{
 var element=snapshot.docs[0].data();
    // vehickeModal.vehicleId=element[fieldvehicleId];
     _arrivalvehicleNo.value=element[fieldvehicleId];
     // if the baar already gone
     vehickeModal.timeInterval=element[fielddestinedtime];
     _arrivalTime.value= vehickeModal.timeInterval;

    vehickeModal.baar= Week().getWeekName(element[fieldbaar]);
    _dateofarrival.value=vehickeModal.baar;
   ///////////////////////////
   vehickeModal.daysLater=Week().getDaysLater(element[fieldbaar]);
  _daysLater.value=vehickeModal.daysLater;
     
   

 }

   
  }catch(er){
    BotToast.showText(text: er.toString());
  }
  finally{
      DisplayLoading.show(text: "Retrieving....", display: false);
  }
 
}

//load the homeuser routes  &&&&&&&&&&&&&&&&&&& LOAD FROM ROUTES #######################

  void LoadHospitalUserTodayRoute({String HospitalName}) async {
    try{
  DisplayLoading.show(text: "Loading....", display: true);
   var snapshot=    await FirebaseFirestore.instance.collection("hospitalroutes").where(fieldhospitalName, isEqualTo:HospitalName ).get();

 if(snapshot.docs.length<1){
   BotToast.showText(text: "Routes are unavailable for hospital.");
 }
 else{
   var element=snapshot.docs[0].data();
     // vehickeModal.vehicleId=element[fieldvehicleId];
     _arrivalvehicleNo.value=element[fieldvehicleId];
     // if the baar already gone
     vehickeModal.timeInterval=element[fieldtimeInterval];
     _arrivalTime.value= vehickeModal.timeInterval;
         List abc              =       element[fieldbaar];
         List<String> abcd=abc.map((e) =>  e as String).toList();
     
    _dateofarrival.value=abcd.toString();
    //
   ///////////////////////////
   //vehickeModal.daysLater=Week().getDaysLater(element[fieldbaar]);
  _daysLater.value="";
 }
  }catch(er){
    BotToast.showText(text: er.toString());
  }
  finally{
      DisplayLoading.show(text: "Retrieving....", display: false);
  }
 
}

//load the data from temporary routes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loadHospitalUserFromTemporary({String maarg, String oda, String truckNo, VoidCallback onNoSatRoute}) async {
  String saturdayRouteId;
 saturdayRouteId=Week().nextSaturday()+"-"+truckNo+'-'+maarg;
 print(saturdayRouteId);
   try{
  DisplayLoading.show(text: "Loading....", display: true);
   var snapshot=    await FirebaseFirestore.instance.collection("dayroute").doc(saturdayRouteId).get() ;
 
 if(snapshot.data()==null){
  BotToast.showText(text: "No Sat Route");
 onNoSatRoute();
 }
 else{
 var element=snapshot.data();
    // vehickeModal.vehicleId=element[fieldvehicleId];
     _arrivalvehicleNo.value=element[fieldvehicleId];
     // if the baar already gone
     vehickeModal.timeInterval=element[fieldtimeInterval];
     _arrivalTime.value= vehickeModal.timeInterval;

    vehickeModal.baar= Week().getWeekName(element[fieldbaar]);
    _dateofarrival.value=vehickeModal.baar;
   ///////////////////////////
   vehickeModal.daysLater=Week().getDaysLater(element[fieldbaar]);
  _daysLater.value=vehickeModal.daysLater;
     
   

 }

   
  }catch(er){
    BotToast.showText(text: er.toString());
  }
  finally{
      DisplayLoading.show(text: "Retrieving....", display: false);
  }
 
}


}


