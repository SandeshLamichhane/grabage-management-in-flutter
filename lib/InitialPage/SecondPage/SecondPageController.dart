import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Home/Home_view.dart';
import 'package:waste/InitialPage/FifthPage/CreatePassword.dart';
import 'package:waste/InitialPage/ThirdPage/SelectService.dart';
import 'package:waste/InitialPage/sixth/latLong.dart';
import 'package:waste/InitialPage/userModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
 
class secondPageController extends GetxController{
  final box=GetStorage();


  void movetoNextPage()async{
  DisplayLoading.show(text: "कृपया पर्खनुहोस....", display: true);
  try{
   
   
  if( box.read(boxuserPhoneNumber)=="null"){
   // move to select service
   Get.to(SelectService());
   return;
 }
  if( box.read(boxuserName)=="null"){
   // move to select service  // for this 
    DisplayLoading.show(text: "कृपया पर्खनुहोस....", display: false);
   Get.to(CreatePassword());
   return;
 }
 

   if( box.read(boxusergeopoint)=="null" || double.parse(box.read(boxusergeopoint).toString().split(",")[0])==0.0 ){
   // move to select service  // for this 
        DisplayLoading.show(text: "कृपया पर्खनुहोस....", display: false);

   Get.to(LATLONG());
   return;
 }

  //send to next page
  if(box.read(boxuserPhoneNumber)!="null" && 
  (box.read(boxuserName)!="null" && 
  (box.read(boxusergeopoint)!="null")))
  Get.offAll(UserHomePage());
    



  }catch(e){
  BotToast.showText(text: e.toString());
   }
   finally{
    DisplayLoading.show(text: "कृपया पर्खनुहोस.......", display: false);

   }

  }

  //get all userInfo from the firebase firestore
  getUserInfoFromFirestore()async{
    String userId= await box.read(boxUserId);
 
 
    try{
          DisplayLoading.show(text: "कृपया पर्खनुहोस.......", display: true);

   var Mydata=   await FirebaseFirestore.instance.collection("users").doc(userId).get().catchError((e){
        BotToast.showText(text: e.toString());
      });
      if(Mydata.data()==null){
      Get.to(SelectService());
      }else{
        UserModel md=UserModel();
        var mx=   md.fromMap(Mydata.data());
          UserModel.set(mx);
      }
    }catch(e){

    }
    finally{
    DisplayLoading.show(text: "कृपया पर्खनुहोस.......", display: false);

    }
  }


}