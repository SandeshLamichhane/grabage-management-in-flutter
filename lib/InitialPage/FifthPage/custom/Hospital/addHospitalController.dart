import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/InitialPage/FifthPage/custom/verifyAddressModel.dart';
import 'package:waste/InitialPage/sixth/latLong.dart';
import 'package:waste/InitialPage/userModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';

class addnewHospitalController extends GetxController{
  final box=GetStorage();
savePendingRequest({
  String  HospitalName,
  String name
  
}) async{
   
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  try{
    DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: true);

 await  FirebaseFirestore.instance.collection("users").doc( box.read(boxUserId)).update({
     fieldhospitalName: HospitalName,
     fielduserName:name
    
  }).then((value) {


 
var x= verifyAddressModel(
  userId:  box.read(boxUserId),
  userName:  name,
  oda:  "null",
  maarg:  "null",
  gharNo: "null",
  isonPending: true,
  datetime: DateTime.now().millisecondsSinceEpoch.toString(),
  hospitalName:  HospitalName
);

 FirebaseFirestore.instance.collection('verifyAddress').doc(x.userId).set(x.toMap(x)).then((value) {
//
//store into box
 DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);
 BotToast.showText(text: "सफलतापूर्वक तपाइको जानकारी सम्बन्धित कार्यलयमा पठाइएको छ");
UserModel.instance.hospitalName=HospitalName;
 
box.write(boxuserName,  name);
UserModel.instance.userName=name;
box.write(boxuserHospitalName, HospitalName);
UserModel.instance.hospitalName=HospitalName;
 
 Get.to(LATLONG());  
 });

   }).catchError((e){
     BotToast.showText(text: e.toString());
   }) ;

 

  
  }catch(e){
  BotToast.showText(text: e.toString());
  }
  finally{
    DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);
  }
}


}