 import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/TrackRoutes/trackTodayRouteModel.dart';
import 'package:waste/Settings/UserSetting/trackHospitalRoutes/trackHospitalModal.dart';

class displayHospitalHistoryController extends  GetxController{
RxList<String>_listofVehicleId = RxList<String>();
List<String> get listofVehicleId =>_listofVehicleId.toList();

List<String>listofHospital;

  RxList<TrackHospitalRouteModal> agentList = RxList<TrackHospitalRouteModal>();
List<TrackHospitalRouteModal> get listofsearchModalItemp=>agentList.toList();

RxString _selectedVehicleId="None".obs;
RxString _selectedHospital="".obs;
String get selectedVehicleId=>_selectedVehicleId.value;
String get selectedMarga=>_selectedHospital.value;

 
RxString _dt1= DateFormat("yyyy-MM-dd").format(DateTime.now()).toString().obs;
RxString _dt2= DateFormat("yyyy-MM-dd").format(DateTime.now()).toString().obs;
 var  _datedt1= DateTime.parse( DateFormat("yyyy-MM-dd").format(DateTime.now()));
 
  
 String get dt1=>_dt1.value;
 String get dt2=>_dt2.value;



int _startDate=0;
 
int _dt1Epoch = DateTime.now().millisecondsSinceEpoch;
int _dt2Epoch = DateTime.now().millisecondsSinceEpoch;

gettodayEpoch(){
String abc=DateFormat('yyyy-MM-dd').format(DateTime.now());
var morningDate=abc+ ' 01:00:00';
  var x = DateTime.parse(morningDate);
  var morningTimeepoch = x.millisecondsSinceEpoch;
  _dt1Epoch=morningTimeepoch;
 

  var m=abc+ ' 23:40:00';
  var y = DateTime.parse(m);
  var eveningTimeepoch = y.millisecondsSinceEpoch;
   _dt2Epoch=eveningTimeepoch;

}

 changeDt1(String dt1){
print(_dt1.toString());
  _dt1.value=dt1;
  dt1=dt1+ ' 01:07:00';
  print(dt1.toString()+"<><><>");
 var inputedEndtTime = DateTime.parse(dt1);
  var mili2 = inputedEndtTime.millisecondsSinceEpoch;
  _dt1Epoch = mili2;
   print(_dt1Epoch.toString()+">>>>>><<<<<");
retrieveHistoryFromFirestoreRoute();
 }
 changeDt2(String dt2){
   _dt2.value=dt2;
    dt2=dt2+ ' 23:59:00';
  var inputedEndtTime = DateTime.parse(dt2);
  var mili2 = inputedEndtTime.millisecondsSinceEpoch;
  _dt2Epoch = mili2;
 }


  changeVehicleId(String x){
    _selectedVehicleId.value=x; 
    retrieveHistoryFromFirestoreRoute();
  }

  changeHospital(String x){

   _selectedHospital.value=x;
  
    retrieveHistoryFromFirestoreRoute();
  }
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Vehicle Id FROM SERVER 88888888888888888888
retrieveVehicleIDFromServer() async{
_listofVehicleId.value=[];
_listofVehicleId.add("None");
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
       _listofVehicleId.add(vehicleId); 
       update();
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

//**************************************** retrieve marga from server */
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Vehicle Id FROM SERVER 88888888888888888888
retrieveHospitalFromServer() async{
   
listofHospital=[];

  bool hasInterent= await hasInsternet();
  if(!hasInterent){
  BotToast.showText(text: "Try after Internet Connection");
   return;
}

DisplayLoading.show(text: "loading all chowk....", display: true);
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("hospitalroutes").get().catchError((e){
     BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  });

  if(dataSnapshot.docs.length<1){
      BotToast.showText(text: "No marg on server", duration:Duration(seconds: 4));
      return;
   }else{
   Map<String, dynamic> d;
    dataSnapshot.docs.forEach((element) { 
      var mappedData= element.data();
      var hospialName=mappedData[fieldhospitalName];
       listofHospital.add(hospialName); 
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

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& RETRIEVE FROM SERVER ############
retrieveHistoryFromFirestoreRoute()async{
 bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   return ;
 }

agentList.value=[];
 var listofQuerySnapshot;
  try{
  DisplayLoading.show(text: "Retrieving....", display: true);
  var snapshot=     FirebaseFirestore.instance.collection("hospdayroute") ;
  final allList = await snapshot.get();
//id all the condtion is null 
   if(_selectedVehicleId.value!="None" && _selectedHospital.value=="") {
          print("Control is"+ _selectedVehicleId.value.toString()+_selectedHospital.value.toString());

    final x= allList.docs.where((doc) => 
    doc[fieldvehicleId] ==_selectedVehicleId.value
    &&  doc[fieldtodayDate] >=  _dt1Epoch && doc[fieldtodayDate] <=  _dt2Epoch );
    listofQuerySnapshot= x.toList();
    }
//now its hospital selected
   if(_selectedVehicleId.value=="None" && _selectedHospital.value!="") {
     print("Control is"+ _selectedVehicleId.value.toString()+_selectedHospital.value.toString());
      final x= allList.docs.where((doc) =>
      doc[fieldhospitalName] ==_selectedHospital.value
       &&  doc[fieldtodayDate] >=  _dt1Epoch && doc[fieldtodayDate] <=  _dt2Epoch );
      listofQuerySnapshot= x.toList();
    }
//now its selected hospital is null
   if(_selectedVehicleId.value=="None" && _selectedHospital.value=="") {
      final x= allList.docs.where((doc) =>
      doc[fieldtodayDate] >=  _dt1Epoch && doc[fieldtodayDate] <=  _dt2Epoch );
      listofQuerySnapshot= x.toList();
    }
//not null of all condition
     print("Control is"+ _selectedVehicleId.value.toString()+_selectedHospital.value.toString());

     if(_selectedVehicleId.value!="None" && _selectedHospital.value!="") {
     print("Control is"+ _selectedVehicleId.value.toString()+_selectedHospital.value.toString());

      final x= allList.docs.where((doc) =>
        doc[fieldvehicleId]==_selectedVehicleId.value && doc[fieldhospitalName] ==_selectedHospital.value && 
      doc[fieldtodayDate] >=  _dt1Epoch && doc[fieldtodayDate] <=  _dt2Epoch );
      listofQuerySnapshot= x.toList();
    }

   if(listofQuerySnapshot.length<1){
   BotToast.showText(text: "No Data found");
  }else{
    //   print(snapshot.docs[0].data().toString());
   listofQuerySnapshot.forEach((element) {
  var MappedData=element.data();
     agentList.add(TrackHospitalRouteModal.fromMap(MappedData));
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

 
 }