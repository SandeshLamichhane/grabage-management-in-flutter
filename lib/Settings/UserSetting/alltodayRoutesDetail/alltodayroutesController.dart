 import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/TrackRoutes/trackTodayRouteModel.dart';

class TodayAkkRoutesController extends  GetxController{
List<String>listofVehicleId;
List<String>listofMarg;

  RxList<trackTodayRouteModal> agentList = RxList<trackTodayRouteModal>();
List<trackTodayRouteModal> get listofsearchModalItemp=>agentList.toList();

RxString _selectedVehicleId="None".obs;
RxString _selectedMarga="".obs;
String get selectedVehicleId=>_selectedVehicleId.value;
String get selectedMarga=>_selectedMarga.value;



 
 RxString _dt1= DateFormat("yyyy-MM-dd").format(DateTime.now()).toString().obs;
 RxString _dt2= DateFormat("yyyy-MM-dd").format(DateTime.now()).toString().obs;
  var  _datedt1= DateTime.parse( DateFormat("yyyy-MM-dd").format(DateTime.now()));
  var dateDt1;
  
 String get dt1=>_dt1.value;
 String get dt2=>_dt2.value;
 
int _dt1Epoch = DateTime.now().millisecondsSinceEpoch;
int _dt2Epoch = DateTime.now().millisecondsSinceEpoch;




int _startDate=0;

 changeDt1(String dt1){

  _dt1.value=dt1;
  dt1=dt1+ ' 11:27:00';
 var inputedEndtTime = DateTime.parse(dt1);
  var mili2 = inputedEndtTime.millisecondsSinceEpoch;
  _dt1Epoch = mili2;

 
retrieveTodayRoutesFromnewFirestoreRoute();
 }
 changeDt2(String dt2){
   _dt2.value=dt2;
    dt2=dt2+ ' 11:27:00';
  var inputedEndtTime = DateTime.parse(dt2);
  var mili2 = inputedEndtTime.millisecondsSinceEpoch;
  _dt2Epoch = mili2;
 }


  changeVehicleId(String x){
    _selectedVehicleId.value=x; 
    retrieveTodayRoutesFromnewFirestoreRoute();
  }

  changeMarga(String x){
    _selectedMarga.value=x;
    retrieveTodayRoutesFromnewFirestoreRoute();
  }
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Vehicle Id FROM SERVER 88888888888888888888
retrieveVehicleIDFromServer() async{

   
listofVehicleId=[];
listofVehicleId.add("None") 
;
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

//**************************************** retrieve marga from server */
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Vehicle Id FROM SERVER 88888888888888888888
retrieveMaargaFromServer() async{
   
listofMarg=[];

  bool hasInterent= await hasInsternet();
  if(!hasInterent){
  BotToast.showText(text: "Try after Internet Connection");
   return;
}

DisplayLoading.show(text: "loading all chowk....", display: true);
 try{
  var dataSnapshot=await  FirebaseFirestore.instance.collection("routes").get().catchError((e){
     BotToast.showText(text:e.toString(), duration: Duration(seconds: 4) );
  });

  if(dataSnapshot.docs.length<1){
      BotToast.showText(text: "No marg on server", duration:Duration(seconds: 4));
      return;
   }else{
   Map<String, dynamic> d;
    dataSnapshot.docs.forEach((element) { 
      var mappedData= element.data();
      var maarg=mappedData[fieldmarg];
       listofMarg.add(maarg); 
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
retrieveTodayRoutesFromnewFirestoreRoute()async{
 
   bool hasInterent= await hasInsternet(); 
 if(!hasInterent){
   return ;
  }
  print(DateTime.now().millisecondsSinceEpoch.toString()+"/////////////////////");
  agentList.value=[];
 
  int x=1;
  var listofQuerySnapshot;
  try{
  DisplayLoading.show(text: "Retrieving....", display: true);
   var snapshot=     FirebaseFirestore.instance.collection("dayroute") ;
     final allList = await snapshot.get();

   if(_selectedVehicleId.value!="None" && _selectedMarga.value=="") {
    final x= allList.docs.where((doc) => 
    doc[fieldvehicleId] ==_selectedVehicleId.value
    &&  doc[fieldtodayDate] >=  _dt1Epoch && doc[fieldtodayDate] <=  _dt2Epoch );
    listofQuerySnapshot= x.toList();
    }

   if(_selectedVehicleId.value=="None" && _selectedMarga.value!="") {
      print(_selectedMarga.toString()+'/'+_dt1Epoch.toString()+'/'+_dt2Epoch.toString());
      final x= allList.docs.where((doc) =>
      doc[fieldmarg] ==_selectedMarga.value
       &&  doc[fieldtodayDate] >=  _dt1Epoch && doc[fieldtodayDate] <=  _dt2Epoch );
      listofQuerySnapshot= x.toList();
    }

   if(_selectedVehicleId.value=="None" && _selectedMarga.value=="") {
      final x= allList.docs.where((doc) =>
      doc[fieldtodayDate] >=  _dt1Epoch && doc[fieldtodayDate] <=  _dt2Epoch );
      listofQuerySnapshot= x.toList();
    }

     if(_selectedVehicleId.value!="None" && _selectedMarga.value!="") {
             print(_selectedVehicleId.toString() +_selectedMarga.toString()+'/'+_dt1Epoch.toString()+'/'+_dt2Epoch.toString());

       print("Control is here in not null all condition");
      final x= allList.docs.where((doc) =>
        doc[fieldvehicleId]==_selectedVehicleId.value && doc[fieldmarg] ==_selectedMarga.value && 
      doc[fieldtodayDate] >=  _dt1Epoch && doc[fieldtodayDate] <=  _dt2Epoch );
      listofQuerySnapshot= x.toList();
    }

 //its the nex ttrick for firestore
  //final snap=snapshot.snapshots().map((event) => event.docs.
 // where((element)=> element[fieldvehicleId]=='GA-1-TA-1289' && element['date']>=1));

 //BotToast.showText(text:  (await snap.first).toList().toString());


   
   if(listofQuerySnapshot.length<1){
   BotToast.showText(text: "No Data found");
  }else{
    //   print(snapshot.docs[0].data().toString());
   listofQuerySnapshot.forEach((element) {
  var MappedData=element.data();
     agentList.add(trackTodayRouteModal.fromMap(MappedData));
     });
   }
  }
  catch(error){
    BotToast.showText(text: error.toString());

  }
  finally{
            DisplayLoading.show(text: "Retrieving....", display: false);
            print(listofsearchModalItemp.length.toString());

  }
}

 
 }