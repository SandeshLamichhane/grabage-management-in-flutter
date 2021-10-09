import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Settings/UserSetting/addHospital/addHospitalController.dart';

class  TrackHospitalRouteModal{
   
 String HospitalName;
 String maarga;
 String districtName;
 String LatLang;
 
 String vehicleId;

 String destined; 
 List<String> coveredTime;
 List<String> covered;
 String driverId;
 String driverName;
 List<String> weekBaar;

  String todayRouteId;
  Timestamp saturdayEpoch;
  String firestoreUpdloadtime;
  int todayDate;
  String nextTime;

TrackHospitalRouteModal({
  this.todayRouteId,
  this.HospitalName,
  this.maarga,
  this.districtName,
  this.LatLang,
  this.vehicleId,
 
  this.destined,
  this.covered,
  this.coveredTime,
  this.firestoreUpdloadtime,
  this.driverId,
  this.driverName,
  this.todayDate,
  this.weekBaar,
  this.nextTime
});

Map<String, dynamic>toMap(TrackHospitalRouteModal todayrouteModel){
Map<String, dynamic> mapData= new Map();
mapData[fieldtodayrouteId]=todayrouteModel.todayRouteId;
mapData[fieldtodayDate]= todayrouteModel.todayDate;
mapData[fieldbaar]=todayrouteModel.weekBaar;
mapData[fieldhospitalName]=todayrouteModel.HospitalName;
mapData[fieldmarg]=todayrouteModel.maarga;

mapData[fieldvehicleId]=todayrouteModel.vehicleId;
mapData[fielddestinedtime]= todayrouteModel.destined;
mapData[fieldcoveredtime]=todayrouteModel.coveredTime;
mapData[fieldcovered]=todayrouteModel.covered;

mapData[fieldfirestoreuploadtime]= todayrouteModel.firestoreUpdloadtime;
mapData[fieldDriverid]=todayrouteModel.driverId;
mapData[fieldDriverName]=todayrouteModel.driverName;
mapData[fieldnextTime]=todayrouteModel.nextTime;
return mapData;
}


TrackHospitalRouteModal.fromMap(Map<String, dynamic> mapData){
 
   
  this.todayRouteId=mapData[fieldtodayrouteId];
 todayDate= mapData[fieldtodayDate];

  HospitalName=mapData[fieldhospitalName];
 maarga=mapData[fieldmarg];

 vehicleId=mapData[fieldvehicleId];
 destined=mapData[fielddestinedtime];
 
 
   List z=mapData[fieldbaar];
 weekBaar=z.map((e) => e as String ).toList();

   List y=mapData[fieldcoveredtime];
 coveredTime=y.map((e) => e as String ).toList();

  List x=mapData[fieldcovered];
 covered=x.map((e) => e as String ).toList();

 firestoreUpdloadtime=mapData[fieldfirestoreuploadtime].toString();
 driverId=mapData[fieldDriverid];
 driverName=mapData[fieldDriverName];
  
 
}

 
}