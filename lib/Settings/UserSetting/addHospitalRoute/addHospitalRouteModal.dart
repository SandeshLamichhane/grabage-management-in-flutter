import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste/Root/constant.dart';

class HospitalRouteModel{
  String routeId;
  String hospitalName;
  String districtName;
  String marga;
  List<String> weekbaar;
  String interval;
  String truckNo;
  GeoPoint chowkLocation;
  List<String>  searchKeyword;

HospitalRouteModel({
  
  this.routeId, this.hospitalName, this.districtName, this.marga, this.weekbaar, this.interval, 
  this.truckNo, this.chowkLocation, this.searchKeyword});


Map<String, dynamic>toMap(HospitalRouteModel routeModel){
Map<String, dynamic> mapData= new Map();
mapData[fieldrouteId]=routeModel.routeId;
mapData[fieldhospitalName]=routeModel.hospitalName;
mapData[fielddistrictName]=routeModel.districtName;

mapData[fieldmarg]=routeModel.marga;
mapData[fieldbaar]=routeModel.weekbaar;
mapData[fieldtimeInterval]=routeModel.interval;
mapData[fieldvehicleId]= routeModel.truckNo;
mapData[fieldchowkLatLng]=routeModel.chowkLocation;
mapData[fieldsearchKeyword]= routeModel.searchKeyword;
return mapData;

}

HospitalRouteModel.fromMap(Map<String, dynamic> mapData){
 
this.routeId=mapData[fieldrouteId];
hospitalName=mapData[fieldhospitalName];
districtName=mapData[fielddistrictName];

marga=mapData[fieldmarg] ;
List<dynamic>x=mapData[fieldbaar];
weekbaar=x.map((e) => e as String).toList();
interval=mapData[fieldtimeInterval] ;
truckNo=mapData[fieldvehicleId] ;
chowkLocation=mapData[fieldchowkLatLng];
//searchKeyword=mapData[fieldsearchKeyword] ;
 List<dynamic>y=mapData[fieldsearchKeyword];
searchKeyword=y.map((e) => e as String).toList();
}
}

