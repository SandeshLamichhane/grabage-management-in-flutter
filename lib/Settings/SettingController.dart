
import 'dart:async';
import 'dart:io';
 
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/root.dart';

class  FirestoreService extends GetxController{
  final box= GetStorage();
 var _isAdminModerator=false.obs;

  
get isAdmin=>_isAdminModerator.value;
void set setisAdmin(bool isAdminModerator){
 this._isAdminModerator.value=isAdminModerator;
}
 StreamSubscription sucr;

   @override
 void dispose() { 
   sucr.cancel();
   super.dispose();
 }

 
UserListener()async {
  try{

 if(box.read(boxUserId)=='null'){

   return;
 }
 sucr=  FirebaseFirestore.instance.collection("users").doc(box.read(boxUserId)).snapshots().listen((event) { 
    
     var x=event.data();
     if(x['userId']==box.read(boxUserId)){


      SetBoxData.store(userRole: x['userRole']);
        if(x['userRole']=='admin'|| x['userRole']=='moderator'){
          _isAdminModerator.value=true;
                 
        }else{
            _isAdminModerator.value=false;

        }
         if(x['userBlockState']=='yes'){
        SetBoxData.store(blockState:x['userBlockState'] );
                 Get.offAll(BlockedPage());
      }
        
     }
    });
  
  
}catch(error){
  BotToast.showText(text: error.toString());

}

}
}
class BlockedPage extends StatefulWidget {
 
  @override
  _BlockedPageState createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Center(
                child: Text("Your id has been locked. Conctact Pokhara waste Services for it.", 
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25.0),),
              ),
            ),
            ElevatedButton(onPressed: (){
               if(Platform.isAndroid){
       SystemChannels.platform.invokeMethod('SystemNavigator.pop');            
   }else{
       //MinimizeApp.minimizeApp();
   }
            }, child: Text("Exit"))
          ],
        ),
      ),
      
    );
  }
}