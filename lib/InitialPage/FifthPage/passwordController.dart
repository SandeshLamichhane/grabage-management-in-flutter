import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/InitialPage/SecondPage/SecondPage.dart';
 import 'package:waste/InitialPage/sixth/latLong.dart';
 
 import 'package:waste/InitialPage/userModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Root/root.dart';

class PasswordController extends GetxController{

UserModel _userModel ;

var  _isCreatingPassoword= false.obs;

bool get isCreatingPassword=>_isCreatingPassoword.value;

CollectionReference reference= FirebaseFirestore.instance.collection("users");

var _box= GetStorage();

  
 
String userName="";

String HomeId="";

List<String> listofhomeId=[];
List<String> listofHosptalName=[];
  @override
  void dispose() { 
      super.dispose();
  }
///////////////////////////////////////ALl the Home Id /////////////////////////////////
getAllHomeId()async{
 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

  try{
    DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: true);
   
   var snapshot= await FirebaseFirestore.instance.collection("homebill").get();

    if(snapshot.docs.length<1){
     listofhomeId=[];
     update();
    }else{
      listofhomeId=[];
      snapshot.docs.forEach((element) {
        listofhomeId.add(element.data()[fieldHomeId]);
        update();
      });
   
    }


  }catch(e){
  BotToast.showText(text: e.toString());
  }
  finally{
    DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);

  }
}
/////////////////////////////////////////////////////////////
getAllHospitalId()async{
 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  try{
    DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: true);
    var snapshot= await FirebaseFirestore.instance.collection("hospitalBill").get();
    if(snapshot.docs.length<1){
     listofHosptalName=[];
     update();
    }else{
       listofHosptalName=[];
      snapshot.docs.forEach((element) {
        listofHosptalName.add(element.data()[fieldhospitalName]);
        update();
      });
    }
  }catch(e){
  BotToast.showText(text: e.toString());
  }
  finally{
    DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);
  }
}

///////////////////////ITS Home Id and Name
saveHomeIdAndName({String HomeId, String nmae }) async{
  String userId=   _box.read(boxUserId);
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  try{
   DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: true);
  await  reference.doc(userId).update({
    fielduserName: nmae.trim(),
    fieldHomeId:HomeId.trim()
  }).catchError((e){
    BotToast.showText(text: e.toString());
  }).then((value) {
    
    _box.write(boxuserName, nmae.trim());
    UserModel.instance.userName=nmae.trim();
    UserModel.instance.homeId=HomeId.trim();
    _box.write(boxUserHomeId, HomeId.trim());

    BotToast.showText(text: """
सफलतापुर्वक नाम परिवर्तन भयो""");
   DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);
   Get.to(LATLONG());


  }); 

  }catch(error){
  BotToast.showText(text: error);
  }finally{
        DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);


  }


}
//save Hospital Name and password
saveHospitalNameAndName({String hospitalName, String writtenname}) async{
  String userId=_box.read(boxUserId);
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  try{
   DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: true);


 await reference.doc(userId).update({
    fielduserName:writtenname,
    fieldhospitalName:hospitalName
  }).catchError((e){
    BotToast.showText(text: e.toString());
  }).then((value) {
    BotToast.showText(text: """
सफलतापुर्वक परिवर्तन भयो""");
   DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);

  Get.to(LATLONG());

  }); 

  }catch(error){
  BotToast.showText(text: error);
  }finally{
        DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);

  }


}

 


 

  void saveGuestName(String writtenName) async {
 String userId=_box.read(boxUserId);
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  try{
   DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: true);


 await reference.doc(userId).update({
    fielduserName:writtenName,
     
  }).catchError((e){
    BotToast.showText(text: e.toString());
  }).then((value) {
    BotToast.showText(text: """
सफलतापुर्वक परिवर्तन भयो""");
   DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);

Get.to(LATLONG());
  }); 

  }catch(error){
  BotToast.showText(text: error);
  }finally{
        DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);

  }

  }

   
}