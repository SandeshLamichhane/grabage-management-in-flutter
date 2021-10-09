import 'package:waste/Root/constant.dart';

class verifyAddressModel {
  String userId;
  String userName;
  String oda;
  String maarg;
  String gharNo;
  bool isonPending;
  String datetime;
  String hospitalName;
  verifyAddressModel({
    this.userId,
    this.userName,
    this.oda="",
    this.maarg="",
    this.gharNo="",
    this.isonPending=true,
    this.datetime="",
    this.hospitalName=""
  });

  Map<String, dynamic> toMap(verifyAddressModel verifyUserAdd){
    Map<String, dynamic> map=new Map();
    map[fieldoda]=verifyUserAdd.oda;
    map[fieldmarg]=verifyUserAdd.maarg;
    map[fieldHomeId]=verifyUserAdd.gharNo;
    map[fielddatetime]=verifyUserAdd.datetime;
    map[fielduserName]=verifyUserAdd.userName;
    map[fieldUserId]=verifyUserAdd.userId;
    map[fieldpending]=verifyUserAdd.isonPending;
    map[fieldhospitalName]=verifyUserAdd.hospitalName;
    return map;
  }

     verifyAddressModel.fromMap(Map<String, dynamic> map)  {
    Map<String, dynamic> map=new Map();
   oda= map[fieldoda] ;
    maarg=map[fieldmarg];
   gharNo= map[fieldHomeId];
   datetime= map[fielddatetime] ;
   userName= map[fielduserName] ;
    isonPending=map[fieldpending]  ;
    userId=map[fieldUserId] ;
   isonPending= map[fieldpending] ;
   hospitalName= map[fieldhospitalName] ;
  }
}