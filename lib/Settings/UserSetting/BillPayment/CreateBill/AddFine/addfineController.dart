import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/weekday/week.dart';

class addfineController extends GetxController {
   

confirmPayment({String HomeId, String upto, String Amount, VoidCallback onSuccess})async{
 try{
bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
String StringMonthName= upto.substring(5,upto.length );
  var intmonth=Week().nepaliMonthNametoint(StringMonthName);
   String stringMonth=intmonth.toString();
  if(intmonth.toString().length==1){
   stringMonth='0'+stringMonth;
  }
 
  String docId=upto.substring(0, 5)+stringMonth.toString()+'-'+HomeId;

  DisplayLoading.show(text: "Please wait...", display: true);
   

  print(docId);print(HomeId)  ;
  await FirebaseFirestore.instance.collection("homemonthlybill").
  doc(HomeId).collection('bill').doc(docId).update({
    fieldoverallTotal:'0',
    fieldPaidAmount:
    Amount, fieldpaidDate:DateTime.now().millisecondsSinceEpoch} 
    
    ).whenComplete(() {

BotToast.showText(text: "Data updated successfully");
onSuccess() ;

 
  });
    
 
 }catch(er){
   BotToast.showText(text: er.toString());
 }
 finally{
  DisplayLoading.show(text: "Please wait...", display: false);
 }

  
}
}