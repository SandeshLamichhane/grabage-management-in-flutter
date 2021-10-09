import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/InitialPage/FifthPage/custom/verifyAddressModel.dart';
 import 'package:waste/InitialPage/sixth/latLong.dart';
import 'package:waste/InitialPage/userModel.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';

class addodaMargController extends GetxController{
  final box=GetStorage();
savePendingRequest({
  String oda,
  String maarga,
  String gharno,
  String name
  
}) async{
  String userId= await box.read(boxUserId);
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  try{
    DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: true);

 await  FirebaseFirestore.instance.collection("users").doc(userId).update({
    fieldmarg: maarga,
    fieldHomeId: gharno,
    fieldoda:oda,
    fielduserName:name,
  }) ;
 
var x= verifyAddressModel(
  userId:  box.read(boxUserId),
  userName:  name,
  oda: oda,
  maarg: maarga,
  gharNo: gharno,
  isonPending: true,
  datetime: DateTime.now().millisecondsSinceEpoch.toString(),
  hospitalName: "null"
);

 FirebaseFirestore.instance.collection('verifyAddress').doc(x.userId).set(x.toMap(x)).then((value) {
//
//store into box
 DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);
 BotToast.showText(text: "सफलतापूर्वक तपाइको जानकारी सम्बन्धित कार्यलयमा पठाइएको छ");
UserModel.instance.oda=oda;
UserModel.instance.maarga=maarga;
UserModel.instance.homeId=gharno;

box.write(boxuserOda, oda);
box.write(boxuserMarg, maarga);
box.write(boxUserHomeId, gharno);
return;
 Get.to(LATLONG());
 });

 

  
  }catch(e){
  BotToast.showText(text: e.toString());
  }
  finally{
    DisplayLoading.show(text: "कृपया पर्खनुहोस...", display: false);
  }
}


}