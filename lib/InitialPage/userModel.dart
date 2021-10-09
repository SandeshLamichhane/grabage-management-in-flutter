 
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/root.dart';

class UserModel{
  String userName;
  String userPhoneNumber;
  String userJoinedDate;
  String userVerifyState;
  String userRole;
  String userId;
  String userBlockState;
  String userFrom;
  GeoPoint geoPoint;
  String oda;
  String maarga;
  String district;
  String hospitalName;
  String homeId;
  String hospitalId;

final box=GetStorage();

    UserModel._private();

  static final UserModel _instance =
      UserModel._private();

   static UserModel get instance => _instance;




  UserModel.set(UserModel model){
    try{
    print("[][]["+model.userName);  
   _instance.userName=model.userName; 
   
   _instance.userPhoneNumber=model.userPhoneNumber;
   _instance.userBlockState=model.userBlockState;
   _instance.userJoinedDate=model.userJoinedDate;
   _instance.userRole=model.userRole;
   _instance.userId=model.userId;
    _instance.userVerifyState=model.userVerifyState;
   _instance.userFrom=model.userFrom;
    _instance.geoPoint=model.geoPoint ;
   _instance.oda=model.oda;
    _instance.maarga=model.maarga;
   _instance.district=model.district;
   _instance.hospitalName=model.hospitalName;
   _instance.homeId=model.homeId;
   _instance.hospitalId=model.hospitalId
   ; 

   storeDatatoBox(model);
    }
    catch(e){
      BotToast.showText(text: e.toString());
      
    }
  }



   
  UserModel({
  
    this.userName, 
    this.userPhoneNumber,
    this.userBlockState,
    this.userJoinedDate,
    this.userRole,
    this.userId,
    this.userVerifyState,
    this.userFrom,
    this.geoPoint,
    this.oda,
    this.maarga,
    this.district,
    this.hospitalName,
    this.homeId,
    this.hospitalId
  });

  Map toMap( UserModel wasteUser){

   var mapData = Map<String, dynamic>();
  mapData["userId"]= wasteUser.userId;
  mapData["userName"]= wasteUser.userName;
  mapData["userRole"]=wasteUser.userRole;
  mapData["userPhone"]=wasteUser.userPhoneNumber;
  mapData["userVerified"]=wasteUser.userVerifyState;
  mapData['userJoinedDate']=wasteUser.userJoinedDate;
  mapData['userBlockState']=wasteUser.userBlockState;
  mapData['userFrom']=wasteUser.userFrom;
 mapData[fieldhospitalName]=wasteUser.hospitalName;
 mapData[fielddistrictName]=wasteUser.district;
 mapData[fieldmarg]=wasteUser.maarga;
 mapData[fieldGeopoint]=wasteUser.geoPoint;
 mapData[fieldoda] =wasteUser.oda;
 mapData[fieldHomeId] =wasteUser.homeId;
 mapData[fieldHospId]=wasteUser.hospitalId;
  return mapData;
}

UserModel.fromJson(Map<String, dynamic> mapData){
     var mapData = Map<String, dynamic>();
  userId=mapData["userId"] ;
 userName= mapData["userName"] ;
  userRole=mapData["userRole"];
 userPhoneNumber= mapData["userPhone"];
  userVerifyState=mapData["userVerified"];
  userJoinedDate=mapData['userJoinedDate'];
 userBlockState= mapData['userBlockState'] ;
 userFrom= mapData['userFrom'];
 hospitalName=mapData[fieldhospitalName] ;
 district=mapData[fielddistrictName] ;
 maarga=mapData[fieldmarg] ;
 geoPoint=mapData[fieldGeopoint] as GeoPoint ;
 oda=mapData[fieldoda] ;
  homeId=mapData[fieldHomeId]   ;
 hospitalId=mapData[fieldHospId] ;
 
}

UserModel fromMap(Map<String, dynamic> mapData){
   UserModel md= new UserModel(); try{
     
  md.userId=mapData["userId"] ;
 
 md.userName= mapData["userName"] ;
  md.userRole=mapData["userRole"];
 md.userPhoneNumber= mapData["userPhone"];
  md.userVerifyState=mapData["userVerified"];
  md.userJoinedDate=mapData['userJoinedDate'];
 md.userBlockState= mapData['userBlockState'] ;
 md.userFrom= mapData['userFrom'];
 md.hospitalName=mapData[fieldhospitalName] ;
 md.district=mapData[fielddistrictName] ;
 md.maarga=mapData[fieldmarg] ;
 var a=mapData[fieldGeopoint] as GeoPoint ;
 md.geoPoint =GeoPoint(a.latitude, a.longitude);

 md.oda=mapData[fieldoda] ;
  md.homeId=mapData[fieldHomeId]   ;
 md.hospitalId=mapData[fieldHospId] ;
 return md;
   }catch(e){
     BotToast.showText(text: e.toString());
   }
}

  void storeDatatoBox(UserModel model) {

     box.write(boxuserName, model.userName);
    box.write(boxuserPhoneNumber, model.userPhoneNumber);
    box.write(boxblockState, model.userBlockState);
    box.write( boxuserjoined, model.userJoinedDate);
    box.write(boxuserRole, model.userRole);
    box.write(boxUserId, model.userId);
    box.write(boxverifiedState, model.userVerifyState);
    box.write( boxuserfrom, model.userFrom);
    box.write(boxusergeopoint, model.geoPoint.latitude.toString()+','+model.geoPoint.longitude.toString());
    box.write(boxuserOda, model.oda);
    box.write( boxuserMarg, model.maarga);
    box.write(boxuserdistrict, model.district);
   box.write(boxuserHospitalName, model.hospitalName);
   box.write(boxUserHomeId, model.homeId);
   box.write(boxhospitalId, model.hospitalId);
  }

  loadBoxValuetoUserModel(){
     try{
     box.read(boxuserName); 
   _instance.userName=  box.read(boxuserName); 
   _instance.userPhoneNumber=  box.read(boxuserPhoneNumber);  
   _instance.userBlockState=  box.read(boxblockState);  
   _instance.userJoinedDate=  box.read(boxuserjoined);  
   _instance.userRole=  box.read(boxuserRole);  
   _instance.userId=  box.read(boxUserId); 
    _instance.userVerifyState=  box.read(boxverifiedState);  
   _instance.userFrom=  box.read(boxuserfrom);  
    _instance.geoPoint= GeoPoint(double.parse(box.read(boxusergeopoint).toString().split(",")[0]), 
                            double.parse(box.read(boxusergeopoint).toString().split(",")[1])) ; 
   _instance.oda=  box.read(boxuserOda);  
    _instance.maarga=  box.read(boxuserMarg); 
   _instance.district=  box.read(boxuserdistrict);  
   _instance.hospitalName=  box.read(boxuserHospitalName); 
   _instance.homeId=box.read(boxUserHomeId); 
   _instance.hospitalId=box.read(boxUserHomeId); 
   ; 
 
    }
    catch(e){
      BotToast.showText(text: e.toString());
      
    }
  }

}