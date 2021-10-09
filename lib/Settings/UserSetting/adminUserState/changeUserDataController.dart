import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';

class ChangeUserDataController extends GetxController{
 final box= GetStorage();
 void ChangeUserData({
   @required String userFrom,
   @required String userId, @required String userRole, @required String  blockState})async{
     
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "No Internet Connection");
   return;
  }

   if(box.read(boxUserId)==userId){
     BotToast.showText(text: "You Have No Permission to update own role");
     return;
   }
   if(box.read(boxuserRole)!='admin'){
     BotToast.showText(text: "Only Admin has a permission to update role");
     return;
   }
   if(userId==null|| userRole==null|| blockState==null){
     return;
   }
   if(userFrom!='Guest' && userRole!="user"){
     BotToast.showText(text: "Only Guest can be  modified to driver / moderator / admin");
     return;
   }
   //if user is driver and  active  you cannot block it
   //check user in vehicle table
     DisplayLoading.show(text: 'Loading...', display: true)  ; 
  var querySnapshot= await FirebaseFirestore.instance.collection("vehicle").where(fieldDriverid, arrayContainsAny: [userId]).get().catchError((error){
   BotToast.showText(text: error.toString());
   });
  
 if(querySnapshot.docs.length>=1){
     DisplayLoading.show(text: 'Loading...', display: false)  ; 
       BotToast.showText(text: "Unable to save changes. UserID is associated with truck. Remove truck from server and insert truck with new Driver.",    duration: Duration(seconds: 6), contentColor: Colors.orange
       );
          
     return;
   }
   
   
   await FirebaseFirestore.instance.collection("users").doc(userId).update({
    'userBlockState' : blockState,
    'userRole' :userRole

    }).catchError((e){
          DisplayLoading.show(text: 'Loading...', display: false)  ;
      BotToast.showText(text: e.toString());
    }).then((value) {
      DisplayLoading.show(text: 'Loading...', display: false)  ;
      BotToast.showText(text: "Succefully updated");
    });

 
   
      
  
  

 }
  
}