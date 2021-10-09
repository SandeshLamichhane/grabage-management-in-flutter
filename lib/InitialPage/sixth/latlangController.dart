import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Home/Home_view.dart';
import 'package:waste/InitialPage/userModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';

class latlongController  extends GetxController{

var  _isLoading= false.obs;

bool get isLoading=> _isLoading.value;


CollectionReference ref= FirebaseFirestore.instance.collection("users");
final box= GetStorage();

 void updateLatLong(String lat, String long) async {
  _isLoading.value= true;
  try{
    var has=  await hasInsternet();
      if(!has){
         BotToast.showText(text: "Oops...");
        return;
      } 

      String uid=box.read(boxUserId);
      if(uid==null || uid=="null"){
        BotToast.showText(text: "error");
        return;
      }

      DisplayLoading.show(text: "कृपया पर्खनुहोस... ", display: true);
     await FirebaseFirestore.instance.collection("users").doc(uid).update({
             fieldGeopoint: GeoPoint(double.parse(lat), double.parse(long))
      }).then((value) {
//lat,long form string
  box.write(boxusergeopoint,   double.parse(lat).toString()+','+ double.parse(long).toString());

  UserModel.instance.geoPoint=  GeoPoint(double.parse(lat), double.parse(long));

   DisplayLoading.show(text: "कृपया पर्खनुहोस... ", display: false);
   BotToast.showText(text: "सफलतापूर्व कार्य सम्पन्न भयो");
 
   Get.offAll(UserHomePage());
   }).catchError((e){
  BotToast.showText(text: e.toString());
   });
 
  }catch(e){
  BotToast.showText(text: e.toString());
  }
  finally{
   DisplayLoading.show(text: "कृपया पर्खनुहोस... ", display: false);

  }

 }
}

