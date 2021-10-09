 import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:waste/Home/Notification/notificationModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';

class NotificationController extends GetxController{
 RxBool _showHide=false.obs;
 bool get showHide=>_showHide.value;
 final box=GetStorage();

 GunasoModel gunasoModel=GunasoModel();
 changeShowHide(){
   _showHide.value=  !_showHide.value;
 } 
  TextEditingController titleTextFieldController= TextEditingController();
  TextEditingController descriptionTextFieldController= TextEditingController();
StreamSubscription<QuerySnapshot> stream;


  @override
  void dispose() { 
    titleTextFieldController.dispose();
    descriptionTextFieldController.dispose();
    if(stream !=null){stream.cancel();}
    super.dispose();
  }

  validateTitle(){
     if(titleTextFieldController.text.trim()==null ||titleTextFieldController.text.trim().length<10)
   return "Somthing wrong !";
   return null;

  }
  validateDescription(){
 if(descriptionTextFieldController.text.trim()==null ||descriptionTextFieldController.text.trim().length<10)
   return "Somthing wrong !";
   return null;
  }
 

 

  void sendGunaso(VoidCallback oncallback) async {
    
    bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Something went wrong");
   
  }else{
    String gunasoId=DateTime.now().millisecondsSinceEpoch.toString();
   gunasoModel.gunasotitle=titleTextFieldController.text.toString().trim();
   gunasoModel.gunasodescription=descriptionTextFieldController.text.toString().trim();
   gunasoModel.gunasoquestionDate=DateFormat("dd-MMMM yy").format(DateTime.now());
   gunasoModel.gunasorequestpending="yes";
   gunasoModel.gunasouserName=box.read(boxuserName);
   gunasoModel.gunasouserFrom=box.read(boxuserType);
   gunasoModel.gunasouserAddress=box.read(boxuserMarg);
   gunasoModel.gunasoreplyDate="";
   gunasoModel.gunasomoderatorName="";
   gunasoModel.gunasomoderatorrole="";
   gunasoModel.gunasoreplytext="";
  gunasoModel.gunasouserId=box.read(boxUserId);
  gunasoModel.gunasoId=int.parse(gunasoId);
  print(gunasoModel.gunasodescription);
   try{
             DisplayLoading.show(text: "Sending....", display: true);

  await  FirebaseFirestore.instance.collection("gunaso").doc(gunasoModel.gunasoId.toString()).set(
    gunasoModel.toMap(gunasoModel)
   ).catchError((er){
     BotToast.showText(text: er.toString());
   }).whenComplete(() {
    BotToast.showText(text: "You will be noified after, response by authority.");
    oncallback();
    titleTextFieldController.clear();
    descriptionTextFieldController.clear();
    loadAllgunasoofUser();
   });


   }catch(err){
     BotToast.showText(text: err.toString());
   }
   finally{
             DisplayLoading.show(text: "Save....", display: false);

   }

 
  }
  }
List<GunasoModel> listofgunasoModel=[];
// &&&&&&&&&&&&&&&&&&&&&&&& LOAD ALL THE DATA FROM SERVER %%%%%%%%%%%%%%%%%%%%%%%%%
loadAllgunasoofUser()async{
  try{
     bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Something went wrong");
   return;
  }
    listofgunasoModel=[];
  var snapshot= await FirebaseFirestore.instance.collection('gunaso').where(fieldgunasouserId, isEqualTo:box.read(boxUserId)).get();
    if(snapshot.docs.length<1){
      BotToast.showText(text: "No Data on the server");
    }else{
 var data=    snapshot.docs.where((doc) =>
                doc[fieldgunasoId] == ""
      );
     listofgunasoModel=[];

     snapshot.docs.forEach((element) {
       print(element.data());
       var mappedData=element.data();
       listofgunasoModel.add(GunasoModel.fromMap(mappedData));
       update();
     });
    }
 
  }catch(error){
  BotToast.showText(text: error.toString());
  }

}

///////////////////////////////////////////////////////listening to changes on firestore
// &&&&&&&&&&&&&&&&&&&&&&&& LOAD ALL THE DATA FROM SERVER %%%%%%%%%%%%%%%%%%%%%%%%%
listeningtoFirestore()async{
  try{
     bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Something went wrong");
   return;
  }
    print("Listening");
    
  var snapshot= await FirebaseFirestore.instance.collection('gunaso').
  where(fieldgunasouserId, isEqualTo:box.read(boxUserId)).snapshots();
   stream= snapshot.listen((event) { 
       if(event.docs.length>=1){
             listofgunasoModel=[];
          event.docs.forEach((element) {
        var mappedData=element.data();
       listofgunasoModel.add(GunasoModel.fromMap(mappedData));
       update();
         });
       }else{
         listofgunasoModel=[];
              update();
       }
    });
     
  }catch(error){
  BotToast.showText(text: error.toString());
  }

}
  
  }