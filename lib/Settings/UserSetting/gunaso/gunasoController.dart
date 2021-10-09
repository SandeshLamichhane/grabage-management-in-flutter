 import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:waste/Home/Notification/notificationModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';

class GunasoController extends GetxController{
 RxBool _show=false.obs;
 bool get showHide=>_show.value;

 RxString _currentprashn="".obs;
 String get currentPrashn=>_currentprashn.value;

 RxBool _isLoading=false.obs;
 bool get isLaoding=>_isLoading.value;
 changeisLaoding(bool value){
   _isLoading.value=value;
 }

 RxString _currentgunasoid="".obs;
 String get currentgunasoid=>_currentgunasoid.value;

 final box=GetStorage();

 GunasoModel gunasoModel=GunasoModel();
RxString _dropDownValue="Pending".obs;


List<String> items=["Pending", "All", "Order" ];
 String get dropDownValue=>_dropDownValue.value;


 RxList<GunasoModel> _listofgunasoModel=RxList<GunasoModel>();
 List<GunasoModel> get listofgunasoModel=>_listofgunasoModel.toList();
 

 changeDropdowValue(String value){
   _dropDownValue.value=value;
   loadAllpendinggunasoofUser();
 }


int index=-1;
 changeShow(int indexx,{String prashn, String gunasoId, bool val }){
   _show.value=  val;
   _currentprashn.value=prashn;
   _currentgunasoid.value=gunasoId;
   _show.value=val;
   index=indexx;

 } 


   TextEditingController replyTextFieldController= TextEditingController();

  validateDescription(){
 if(replyTextFieldController.text.trim()==null ||replyTextFieldController.text.trim().length<10)
   return "Somthing wrong !";
   return null;
  }

 

 

  void sendGunaso() async {
    
    bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Something went wrong");
   
  }else{
   gunasoModel.gunasotitle=//titleTextFieldController.text.toString().trim();
   gunasoModel.gunasodescription= //descriptionTextFieldControl ler.text.toString().trim();
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
  print(gunasoModel.gunasodescription);
   try{
  DisplayLoading.show(text: "Saving....", display: true);
  await  FirebaseFirestore.instance.collection("gunaso").doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
    gunasoModel.toMap(gunasoModel)
   ).catchError((er){
     BotToast.showText(text: er.toString());
   }).whenComplete(() {
    BotToast.showText(text: "Successfully Saved");
 
    replyTextFieldController.clear();
   });


   }catch(err){
     BotToast.showText(text: err.toString());
   }
   finally{
             DisplayLoading.show(text: "Save....", display: false);

   }

 
  }
  }
// &&&&&&&&&&&&&&&&&&&&&&&& LOAD ALL THE DATA FROM SERVER %%%%%%%%%%%%%%%%%%%%%%%%%
loadAllpendinggunasoofUser()async{
  _isLoading.value=true;
  try{
     bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Something went wrong");
   return;
  }
    _listofgunasoModel.value=[];
  update();
  //three logic
    var snapshot;
    snapshot= await FirebaseFirestore.instance.collection('gunaso').get();
  
  if(_dropDownValue.value=="Pending"){
    snapshot= await FirebaseFirestore.instance.collection('gunaso'). where(fieldgunasopending, isEqualTo: "yes").get();
  }
 
  if(_dropDownValue.value=="All"){
    snapshot= await FirebaseFirestore.instance.collection('gunaso').limit(2000).get();
    print("Controll is hrer");
  }

  if(_dropDownValue.value=="Order"){
    snapshot= await FirebaseFirestore.instance.collection('gunaso').orderBy(fieldgunasoId, descending: true).get();

  }
     if(snapshot.docs.length<1){
      BotToast.showText(text: "No  pending on the server");
      
     _listofgunasoModel.value=[];
     update();
    }else{
     
     _listofgunasoModel.value=[];

     snapshot.docs.forEach((element) {
       print(element.data());
       var mappedData=element.data();
       _listofgunasoModel.add(GunasoModel.fromMap(mappedData));
       update();
     });
    }
 
  }catch(error){
  BotToast.showText(text: error.toString());
  }
  finally{
    _isLoading.value=false;
  }

}

  void delete({String gunashoId}) async {
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Something went wrong");
   return;
  }

  try{
          DisplayLoading.show(text:"Please wait...", display: true );

   await FirebaseFirestore.instance.collection("gunaso").doc(gunashoId).delete().catchError((e){
     BotToast.showText(text: e.toString());
   }).whenComplete(() {
  BotToast.showText(text: "Successfully deleted");
   loadAllpendinggunasoofUser();
   });
  }catch(err){
    BotToast.showText(text: err.toString());
  }finally{
          DisplayLoading.show(text:"Please wait...", display: false );

  }

 }

////////////////////REPLY THE GUNASO #################################################



  void ReplyaGunaso() async {
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Something went wrong");
   return;
  }
    try{
      if(index<0){
        BotToast.showText(text: "Out of range");
        return;
      }
      DisplayLoading.show(text:"Please wait...", display: true );
listofgunasoModel[index].gunasoreplytext=replyTextFieldController.text.trim();
listofgunasoModel[index].gunasorequestpending="no";
listofgunasoModel[index].gunasomoderatorName=box.read(boxuserName);
listofgunasoModel[index].gunasomoderatorrole=box.read(boxuserRole);

listofgunasoModel[index].gunasoreplyDate=DateFormat("dd-MMMM yy").format(DateTime.now());
//after this set the 

var x=await FirebaseFirestore.instance.collection("gunaso").doc(_currentgunasoid.value).
set(GunasoModel().toMap(listofgunasoModel[index])).whenComplete(() 
{
  BotToast.showText(text: "Successfully replied");
  replyTextFieldController.clear();
});

    }
    catch(error){
      BotToast.showText(text: error.toString());
    }
    finally{
            DisplayLoading.show(text:"Please wait...", display: false );

    }
  }
  
  }