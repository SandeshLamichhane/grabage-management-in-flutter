import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:waste/Root/constant.dart';

class VehicleModal{
final String vehicleId;
final List<String> driverID;
final List<String> driverSName;
final List<String> driverSPhone;
final bool streaming;
final  GeoPoint geoPoint; 
  bool expanded;
 

VehicleModal({ this.expanded: false, this.streaming=false, @required this.vehicleId, this.driverID, this.geoPoint, this.driverSName, this.driverSPhone});

Map<String, dynamic>toMap(VehicleModal vehicleModal){
Map<String, dynamic> mapData= new Map();
mapData[fieldDriverid]=vehicleModal.driverID;
mapData[fieldDriverName]=vehicleModal.driverSName;
mapData[fieldDriverPhone]=vehicleModal.driverSPhone;
mapData[fieldTruckLocation]=vehicleModal.geoPoint;
mapData[fieldvehicleId]=vehicleModal.vehicleId;
mapData[fieldTruckStreaming]=vehicleModal.streaming;
return mapData;

}
Map<String, dynamic>    toMaps( ){
Map<String, dynamic> mapData= new Map();
 
return mapData;
}

}