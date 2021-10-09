import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/createbillModel.dart';

class createBillController extends GetxController {
  

  List<String> listofHomeId=[];
  List<createMonthyluBillModel> listofMonthlybillrate=[];

  RxBool _isLoading=false.obs;
  bool get isLoading=>_isLoading.value;

  RxString _selectedHomeId="".obs;
  String get selectedIdHome  =>_selectedHomeId.value;


 changeVehicleId(String value){
_selectedHomeId.value=value;
 loadDataAccordingtoHomeId();
 }
 //////////////////////Get all Home Id $$$$$$$$$$$$$$$$$$$$
  getAllHomeId()async{
  bool hasInterent= await hasInsternet();

  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  DisplayLoading.show(text: "Please wait...", display: true);
 listofMonthlybillrate=[];
 update();
  try{
     var snapshot= await FirebaseFirestore.instance.collection("homebill").get().catchError((e){
      BotToast.showText(text: e.toString());
     });

       snapshot.docs.forEach((element) {
      listofHomeId.add(element.data()[fieldHomeId]);
     update();


     
      
      });
  }catch(err){
    BotToast.showText(text: err.toString());
  }
  finally{
  DisplayLoading.show(text: "Please wait...", display: false);
  }

  //load vehicle iid from
 
}

 loadDataAccordingtoHomeId() async{
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
 _isLoading.value=true;
 update();
 print("Cntrol is here");
  
  try{
    if(_selectedHomeId.value!=""){
     var snapshot= await FirebaseFirestore.instance.collection("homemonthlybill").
     doc(_selectedHomeId.value).collection("bill"). 
     get().catchError((e){
      BotToast.showText(text: e.toString());
     });
    snapshot.docs.forEach((element) {
      listofMonthlybillrate.add(createMonthyluBillModel.fromMap(element.data()));
     update();
      
      });
    }

  }catch(err){
    BotToast.showText(text: err.toString());
  }
  finally{
 _isLoading.value=false;  
 update();
  }

    
  }


}