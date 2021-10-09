import 'package:cloud_firestore/cloud_firestore.dart';

class WasteUser{
  String userName;
  String email;
  String facebook;
  String google;
  String blocked;
  String phone;
  String joinedDate;
   String role;
  String userId;
  String isVerified;
  //String firebase_phone_id;
  //String firebase_google_id;
  //String firebase_facebook_id;
 
   get getEmail{
  return   this.email;

}

  
  WasteUser({
    this.userName,
  this.email,
  this.facebook,
  this.google,
  this.blocked,
  this.phone,
  this.joinedDate,
   this.role,
  this.userId,
  this.isVerified
  
});

 static var sandesh= "sandesh";
 
  WasteUser.fromMap(Map <String, dynamic> mapData){

   this.userId = mapData["w_userId"];
     this.userName =mapData["w_userName"];
      
     this.email= mapData["w_email"];
     this.role = mapData["w_role"];
     this.phone =mapData["w_phone"];
      this.isVerified = mapData["w_verified"];
     this.google=mapData['w_google'];
      this.facebook=mapData['w_facebook'];
    this.joinedDate=mapData['w_joinedDate'];
    this.blocked=mapData['w_isBlocked'];
}

Map toMap( WasteUser wasteUser){

   var mapData = Map<String, dynamic>();
    mapData["w_userId"]= wasteUser.userId;
  mapData["w_userName"]= wasteUser.userName;
   mapData["w_email"]=wasteUser.email;
   mapData["w_role"]=wasteUser.role;
    mapData["w_phone"]=wasteUser.phone;
  mapData["w_verified"]=wasteUser.isVerified;
   mapData['w_google']=wasteUser.google;
     mapData['w_facebook']=wasteUser.facebook;
     mapData['w_joinedDate']=wasteUser.joinedDate;

     mapData['w_isBlocked']=wasteUser.blocked;

     return mapData;
  
  


}

/*WasteUser.fromJson(Map<String, dynamic> parsed)
: userName=parsed[""],
  email=parsed[""],
  role=parsed[""],
  mode=parsed[""],
  isVerified=parsed[""],
 userId=parsed[""]
  ;
  */


/*

  final int temp;
  final String wax;
  final String line ;
  final String timeStamp;

  Report({this.temp, this.line, this.wax, this.timeStamp});

  Report.fromJson(Map<String, dynamic> parsedjason)
  : temp= parsedjason['temp'],
   wax=parsedjason['wax'],
   timeStamp=parsedjason['timestamp'],
   line=parsedjason['line'];


*/
//this is the waste user id  
}


class UserModel {
  String email;
  String uid;
  String username;
  DateTime timestamp;
  
  UserModel({this.email, this.uid, this.username, this.timestamp});
  
  Map toMap(UserModel user) {
    var data = Map<String, dynamic>();
  
    data["uid"] = user.uid;
    data["username"] = user.username;
    data["email"] = user.email;
    data["timestamp"] = user.timestamp;
  
    return data;
  }
  
  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.username = mapData["username"];
    this.email = mapData["email"];
  }
}

