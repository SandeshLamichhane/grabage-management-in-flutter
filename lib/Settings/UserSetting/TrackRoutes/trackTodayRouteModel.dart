import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste/Root/constant.dart';

class trackTodayRouteModal{
  int todayDate;
  String todayRouteId;
  String baar;
  String oda;
  String marga;
  String vehicleId;
  String destined;
  bool covered;
  String coveredTimed;
  String firestoreUpdloadtime;
  String driverID;
  String driverName;
  String offline;

trackTodayRouteModal({
  this.todayRouteId,
  this.todayDate,
  this.baar,
  this.marga,
  this.oda,
  this.vehicleId,
  this.destined,
  this.covered,
  this.coveredTimed,
  this.firestoreUpdloadtime,
  this.driverID,
  this.driverName,
  this.offline

});


Map<String, dynamic>toMap(trackTodayRouteModal todayrouteModel){
Map<String, dynamic> mapData= new Map();
mapData[fieldtodayrouteId]=todayrouteModel.todayRouteId;
mapData[fieldtodayDate]= todayrouteModel.todayDate;
mapData[fieldbaar]=todayrouteModel.baar;
mapData[fieldoda]=todayrouteModel.oda;
mapData[fieldmarg]=todayrouteModel.marga;

mapData[fieldvehicleId]=todayrouteModel.vehicleId;
mapData[fielddestinedtime]= todayrouteModel.destined;
mapData[fieldcoveredtime]=todayrouteModel.coveredTimed;
mapData[fieldcovered]=todayrouteModel.covered;

mapData[fieldfirestoreuploadtime]= todayrouteModel.firestoreUpdloadtime;
mapData[fieldDriverid]=todayrouteModel.driverID;
mapData[fieldDriverName]=todayrouteModel.driverName;
mapData[fieldoffline]=todayrouteModel.offline;
return mapData;
}


trackTodayRouteModal.fromMap(Map<String, dynamic> mapData){
 
   
  this.todayRouteId=mapData[fieldtodayrouteId];
 todayDate= mapData[fieldtodayDate];
 baar=mapData[fieldbaar];
  oda=mapData[fieldoda];
 marga=mapData[fieldmarg];

 vehicleId=mapData[fieldvehicleId];
 destined=mapData[fielddestinedtime];
 coveredTimed=mapData[fieldcoveredtime];
 covered=mapData[fieldcovered];

 firestoreUpdloadtime=mapData[fieldfirestoreuploadtime].toString();
 driverID=mapData[fieldDriverid];
 driverName=mapData[fieldDriverName];
 offline=mapData[fieldoffline];
 
}

 
}