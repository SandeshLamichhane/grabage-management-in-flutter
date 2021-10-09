import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/createbillModel.dart';
import 'package:waste/Settings/UserSetting/BillPayment/billPaymentModel.dart';

class billPaymentController extends GetxController{
RxString _HospOrHome="Home".obs;

String get hospOrHome =>_HospOrHome.value;
RxBool _isLoading=false.obs;
bool get isLoading=>_isLoading.value;

TextEditingController homeIdController=TextEditingController();
TextEditingController rateIdController=TextEditingController();
TextEditingController confirmDeleteController= TextEditingController();
TextEditingController remainingAmountController= TextEditingController();
TextEditingController  ownerNameAmountController= TextEditingController();


HomeBillRate  _billRateModel=HomeBillRate();
HospitalBillRate _hospitalBillRate=HospitalBillRate();

List<HomeBillRate>listofHomeBillRate=[];
List<HospitalBillRate>listofHospitalRate=[];


@override
void dispose() { 
  homeIdController.dispose();
  rateIdController.dispose();
  confirmDeleteController.dispose();
  remainingAmountController.dispose();
  ownerNameAmountController.dispose();
  super.dispose();
}
chnageHospHome(String value){
  _HospOrHome.value=value;
}

validateHomeId() async {
 if( homeIdController.text.trim()==""){
  return "required";
 } 
return await doesHomeIdAlreadyExists() ;
}

validateRateId() {
  if(rateIdController.text.trim()==""){
   return "required";
 }
 return null;
}
//////////////// DELETE DATA FROM SERVER #################
 validateRemaingAmount() {
     if(remainingAmountController.text.trim()==""){
   return "required";
 }
 return null;
}

//////////////// DELETE DATA FROM SERVER #################
 validateOwnerName() {
     if(ownerNameAmountController.text.trim()==""){
   return "required";
 }
 return null;
}
   

  void AddNewData(Null Function() param0)async {
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  DisplayLoading.show(text: "Please wait...", display: true);

  try{
  if(_HospOrHome.value=="Home"){
 NepaliDateTime nepaliDateTime= DateTime.now().toNepaliDateTime();
 var myFormat=NepaliDateFormat('yyyy-MM');
  var customDate=myFormat.format(nepaliDateTime);
   

_billRateModel.homeId=homeIdController.text.trim();
_billRateModel.rate=rateIdController.text.trim();
_billRateModel.datetime=DateTime.now().millisecondsSinceEpoch;
_billRateModel.remainingamount=remainingAmountController.text.trim();
_billRateModel.ownerName=ownerNameAmountController.text.trim();
  //String docId=customDate+"-"+_billRateModel.homeId;
  
  String docId= "2076-02-"+_billRateModel.homeId;
 _billRateModel.startyearMonth=customDate;

var data= await FirebaseFirestore.instance.collection("homebill").
doc(docId).set(
  _billRateModel.toMap(_billRateModel)
   ).whenComplete(() {
 BotToast.showText(text: "Successfully Saved.");

 storeIntoMonthlyBill(_billRateModel, docId);

clearAll();
///////////// Now add into the 

   });

  }
  //////////hospital
  if(_HospOrHome.value=="Hospital"){
  _hospitalBillRate.hospitalName=homeIdController.text.trim();
    _hospitalBillRate.rate=rateIdController.text.trim();
      _hospitalBillRate.datetime  =DateTime.now().millisecondsSinceEpoch;


   var data= await  FirebaseFirestore.instance.collection("hospbillRoute").doc(_hospitalBillRate.datetime.toString()).
   set(_hospitalBillRate.toMap(_hospitalBillRate)).whenComplete(() {
     BotToast.showText(text: "Saved.");
      homeIdController.clear();
     rateIdController.clear();
     remainingAmountController.clear();
     ownerNameAmountController.clear();
   });

  }
    
  }catch(err){
    BotToast.showText(text: err.toString());
  }finally{
  DisplayLoading.show(text: "Retrieving....", display: false);

  }

  }

////////////////////////////
  loadHomeBillRate() async{
      bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
   _isLoading.value=true;
     update();
       listofHomeBillRate=[];
      
  try{
   var data= await FirebaseFirestore.instance.collection("homebill"). get();
   if(data.docs.length>=1){
     data.docs.forEach((element) {
       listofHomeBillRate.add(HomeBillRate.fromMap(element.data()));
       update();
     });

   }else{
     listofHomeBillRate=[];
     update();
   }

  }
  catch(err){
    BotToast.showText(text: err.toString());
  }
  finally{
    _isLoading.value=false;
    update();
  }
  }
////////////////////////////Load the hospital bill rate
  loadHospitalBillRate() async{
      bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
   _isLoading.value=true;
     update();
       listofHospitalRate=[];
      
  try{
   var data= await FirebaseFirestore.instance.collection("hospbillRoute"). get();
   if(data.docs.length>=1){
     data.docs.forEach((element) {
       listofHospitalRate.add( HospitalBillRate.fromMap(element.data()));
       update();
     });

   }else{
     listofHomeBillRate=[];
     update();
   }

  }
  catch(err){
    BotToast.showText(text: err.toString());
  }
  finally{
    _isLoading.value=false;
    update();
  }
  }
/////////////////////////////////////////////////////////////////////////////////////////
  void deleteFromFirestore(String docId, VoidCallback callback)async {
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
   DisplayLoading.show(text: "Please wait...", display: true);

  try{
  if(_HospOrHome.value=="Home"){
    print(docId);
var data= await FirebaseFirestore.instance.collection("homebill").
doc(docId).delete();
deleteSameDatFromMonthlyBill(docId);
 loadHomeBillRate();
 BotToast.showText(text: "Successfully deleted");
  }
  //////////hospital
  if(_HospOrHome.value=="Hospital"){
   var data= await  FirebaseFirestore.instance.collection("hospbillRoute").
   doc(docId).
    delete().whenComplete(() {
     BotToast.showText(text: "Successfully deleted.");
     loadHospitalBillRate();
   });

  }
    
  }catch(err){
    BotToast.showText(text: err.toString());
  }finally{
  DisplayLoading.show(text: "Retrieving....", display: false);
  }

  }

 Future<String>   doesHomeIdAlreadyExists() async {
       bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return "Oops";
  }
   DisplayLoading.show(text: "Please wait...", display: true);
   try{
 var snapshot=   await  FirebaseFirestore.instance.collection("homebill").
     where(fieldHomeId, isEqualTo: homeIdController.text.trim()).get();
  if(snapshot.docs.length<1){
    return null;
  }else{
    return "Already exists";
  }


   }catch(error){
     BotToast.showText(text: error.toString());
     return error.toString();
   }
   finally{
   DisplayLoading.show(text: "Please wait...", display: false);
    
   }
    }

  void clearAll() {
     homeIdController.clear();
 rateIdController.clear();
 remainingAmountController.clear();
 ownerNameAmountController.clear();
  }
final box=GetStorage();

  void storeIntoMonthlyBill(HomeBillRate  model, String docId) async {

  createMonthyluBillModel cd = new createMonthyluBillModel();

  cd.serialDateTime=DateTime.now().subtract(Duration(days: 5)).millisecondsSinceEpoch;
   
  cd.currentyearMonth=model.startyearMonth;
  cd.currentMonthcharge=model.rate;
  cd.remainingAmount=model.remainingamount;
  cd.fine="00.00";
  cd.totalAmount=(double.parse(cd.currentMonthcharge)+
                       double.parse(cd.remainingAmount)+double.parse(cd.fine)).toString();
  cd.paidAmount="0.0";
  cd.paidDate="0000-00-00";
  cd.overalltotalAmount=cd.totalAmount;
  cd.moderatorName=box.read(boxuserName);


 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
   DisplayLoading.show(text: "Creating bill...", display: true);

  
try{
await FirebaseFirestore.instance.collection("homemonthlybill").
  doc(model.homeId).collection('bill').doc(docId).set(cd.toMap(cd)).whenComplete(() {
    BotToast.showText(text: "Monthly bill created.");
  });
}catch(error){
  BotToast.showText(text: error.toString());
}
finally{
     DisplayLoading.show(text: "Please wait...", display: false);

}

  }

  void deleteSameDatFromMonthlyBill(String docId) async {
bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
   DisplayLoading.show(text: "Please wait...", display: true);
String homeId= docId.substring(8,docId.length);
print(homeId);
try{
   String homeId= docId.substring(8,docId.length);
                               await FirebaseFirestore.instance.collection('homemonthlybill').doc(homeId).
                   collection('bill').get().then((value) {
                     for(DocumentSnapshot ds in value.docs){
                       ds.reference.delete();
                     }
                   }).whenComplete((){
                     BotToast.showText(text: "No Longer data Available");
                   });
                        
}catch(error){
  BotToast.showText(text: error.toString());
}
finally{
     DisplayLoading.show(text: "Please wait...", display: false);

}

  }

 


}