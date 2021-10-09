import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
 import 'package:waste/InitialPage/FirstPage/infoPage.dart';
import 'package:waste/InitialPage/userModel.dart';
import 'package:waste/Login/login_controller.dart';
 import 'package:waste/Root/constant.dart';
  
  
 
 
 
 

 class Root extends  StatelessWidget {
    // Root({ Key? key }) : super(key: key);
 var box= new GetStorage();

   @override
   Widget build(BuildContext context)  {


      LoginController controller= Get.put<LoginController>(LoginController());
      
      
      box.writeIfNull('email', 'null');
        box.read('email') =='null'? controller.setLogedin(false): controller.setLogedin(true);
        writeIfNullBoxValue();

        //first write if null the value
     
 //  return Obx(()=>controller.isLoggedin==true? UserHomePage():LoginView());
   return InitialPage();
     
      /*GetBuilder(
       init: controller,
       builder:(controller){
         print( controller.isLoading.toString()+"Satati/////////////////00");
           return MyHomePage();
       }*/

  
     
     
       
      
       
   
   }
   UserModel

    writeIfNullBoxValue(){
        box.writeIfNull(boxUserId, "null");
         box.writeIfNull(boxuserName,  "null");
         box.writeIfNull(boxuserPhoneNumber,  "null");
         box.writeIfNull(boxuserRole,  "null");
         box.writeIfNull(boxblockState,  "null");
         box.writeIfNull(boxverifiedState,  "null");
         box.writeIfNull(boxuserType,  "null");
         box.writeIfNull(boxUserPassword, "null");
         box.writeIfNull(boxuserMarg, "null");
         box.writeIfNull(boxuserLat,  "null");
         box.writeIfNull(boxuserLong,'null');
         box.writeIfNull(boxuserHospitalName, 'null');
         box.writeIfNull(boxuserfrom, 'null');
        box.writeIfNull( boxtodayroute, '00-00-0000-000');
        box.writeIfNull( boxuserjoined, 'null');
     box.writeIfNull(boxusergeopoint, "null");
    box.writeIfNull(boxuserOda, "null");
     box.writeIfNull(boxuserdistrict,  "null");
   box.writeIfNull(boxuserHospitalName,  "null");
   box.writeIfNull(boxUserHomeId,  "null");
   box.writeIfNull(boxhospitalId, "null");
        }
 }

 ////////////////################ CREATE BINDING ###############
 
 class SetBoxData{
  
  SetBoxData(){}
  final box= GetStorage();
    var  marg, lat,long, userId, userName, userPhone, userRole, userFrom, hospitalName,
     verifiedstate, blockState, password;
  
   SetBoxData.mapuser(UserModel n){
    UserModel nn=UserModel();
     box.write(boxuserName, n.userName);
    box.write(boxuserPhoneNumber, n.userPhoneNumber);
    box.write(boxblockState, n.userBlockState);
    box.write( boxuserjoined, n.userJoinedDate);
    box.write(boxuserRole, n.userRole);
    box.write(boxUserId, n.userId);
    box.write(boxverifiedState, n.userVerifyState);
    box.write( boxuserfrom, n.userFrom);
    box.write(boxusergeopoint, n.geoPoint.toString());
    box.write(boxuserOda, n.oda);
    box.write( boxuserMarg, n.maarga);
    box.write(boxuserdistrict, n.district);
   box.write(boxuserHospitalName, n.hospitalName);
  }


  SetBoxData.store({
    this.marg, 
    this.lat,
    this.long,

    this.userId,
    this.userPhone,
    this.userRole,
    this.userName,
    this.userFrom,
    this.hospitalName,

    this.verifiedstate,
    this.blockState,
    this.password

  
   }){
    this.marg!=null   ? box.write(boxuserMarg, this.marg) : print("Marg not updated");
      this.lat!=null   ? box.write(boxuserLat, this.lat) : print("lat not updated");
          this.long!=null   ? box.write(boxuserLong, this.long) : print("long not updatet");

          this.userId!=null   ? box.write(boxUserId, this.userId) : print("User id not updated");
           this.userName!=null ? box.write(boxuserName, this.userName) : print(" User name not updated");
          this.userPhone!=null   ? box.write(boxuserPhoneNumber, this.userPhone) : print("Phone no updatet");
          this.userRole!=null   ? box.write(boxuserRole, this.userRole) : print(" User Role updatet");
          this.userFrom!=null   ? box.write(boxuserType, this.userFrom) : print(" User type Role updatet");
          this.hospitalName!=null ? box.write(boxuserHospitalName,  this.hospitalName): print("Hospital Name Not updated");
         
           this.verifiedstate!=null   ? box.write(boxverifiedState, this.verifiedstate) : print("  verified state not updatet");
          this.blockState!=null   ? box.write(boxblockState, this.blockState) : print("  bloack state updatet");
          this.password!=null ? box.write(boxUserPassword,  this.hospitalName): print("password Not updated");

  } 

   Future setAllBoxValueNull() async{
          box.write(boxUserId, "null");
         box.write(boxuserName,  "null");
         box.write(boxuserPhoneNumber,  "null");
         box.write(boxuserRole,  "null");
         box.write(boxblockState,  "null");
         box.write(boxverifiedState,  "null");
         box.write(boxuserType,  "null");
         box.write(boxUserPassword, "null");
         box.write(boxuserMarg, "null");
         box.write(boxuserLat,  "null");
         box.write(boxuserLong,'null');
         box.write(boxuserHospitalName, 'null');

  }




}