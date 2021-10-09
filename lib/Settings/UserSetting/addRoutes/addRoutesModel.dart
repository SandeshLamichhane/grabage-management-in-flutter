import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste/Root/constant.dart';

class RouteModel{
final String routeId;
final String oda;
final String marga;
final String baar;
final String interval;
final String truckNo;
final GeoPoint chowkLocation;
final List<String>  searchKeyword;

RouteModel({
  
  this.routeId, this.oda, this.marga, this.baar, this.interval, 
  this.truckNo, this.chowkLocation, this.searchKeyword});


Map<String, dynamic>toMap(RouteModel routeModel){
Map<String, dynamic> mapData= new Map();
mapData[fieldrouteId]=routeModel.routeId;
mapData[fieldoda]=routeModel.oda;
mapData[fieldmarg]=routeModel.marga;
mapData[fieldbaar]=routeModel.baar;
mapData[fieldtimeInterval]=routeModel.interval;
mapData[fieldvehicleId]= routeModel.truckNo;
mapData[fieldchowkLatLng]=routeModel.chowkLocation;
mapData[fieldsearchKeyword]= routeModel.searchKeyword;
return mapData;

}


}

