import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';

class AddHospitalController extends GetxController {
      RxInt hasUserLenght=0.obs;
    int get snapshotLngth => hasUserLenght.value;
  List<HospitalDtrictModel> listOfHosptial;

  final box= GetStorage();
  
loadAllHospital() async{
   listOfHosptial=[];
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  DisplayLoading.show(text: "Retrieving....", display: true);

  var dataSnapshot=await  FirebaseFirestore.instance.collection("adminSetup").doc('Hospital').collection("sndbasd").doc('hospital').get().catchError((e){
    DisplayLoading.show(text: "Retrieving....", display: false);
    BotToast.showText(text:e.toString() );
  });
  DisplayLoading.show(text: "Retrieving....", display: false);
  if(dataSnapshot.data()==null){
      BotToast.showText(text: "No Hospital added by admin yet.", duration:Duration(seconds: 4));
      return;
   }else{

     try{
    var doublemappedData= dataSnapshot.data() ;
    print(doublemappedData);
  
      doublemappedData.forEach((dis, val) { 
        val.forEach((hospital) {
         listOfHosptial.add(HospitalDtrictModel(district: dis,hospital: hospital.toString()));
          print(listOfHosptial);
        });
 
 });
   
 
   hasUserLenght.value =  1;
     }
     catch(err){
       BotToast.showText(text: err.toString());
     }
    }
  }
  
  AddNewHospital({String districtName, String hospitalName}) async{
  String name;
   bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

  if(box.read(boxuserRole)=='admin' || box.read(boxuserRole)=='moderator'){
  }else{
    BotToast.showText(text: "No permission to add");
    return;
  }
  DisplayLoading.show(text: "Adding....", display: true);
  List<String> xyz=[hospitalName];
await  FirebaseFirestore.instance.
  collection("adminSetup").doc('Hospital').collection("sndbasd").doc('hospital').
  update({
     districtName :FieldValue.arrayUnion(xyz)
  }).catchError((e){
    BotToast.showText(text:e.toString() );
      DisplayLoading.show(text: "Adding....", display: false);


  }).then((value) {
     DisplayLoading.show(text: "Adding....", display: false);
     BotToast.showText(text: "Successfully Added", duration: Duration(seconds: 4));
  });
 
  }

  deleteHospital(String district, String hospital) async{
    bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }


  DisplayLoading.show(text: "Deleting....", display: true);
  
   try{
     //check if user 
    if(box.read(boxUserId) !='null' && box.read(boxuserRole)=='admin'){
      List<String> val=[hospital];
 await  FirebaseFirestore.instance.collection("adminSetup").

  doc('Hospital').collection("sndbasd").doc('hospital').update(
    {
      district: FieldValue.arrayRemove(val)
    }
  ).catchError((e){
    BotToast.showText(text: e.toString());
  }).whenComplete(() {
      BotToast.showText(text: "Successfully deleted");
  });
  
    }else{
      BotToast.showText(text: "Only admin has a permission to delete it.");
      return;
    }
   }
   catch(ex)
{
  BotToast.showText(text: ex.toString());
}
finally{
    DisplayLoading.show(text: "Retrieving....", display: false);

}

}

 




}
    
 

class HospitalDtrictModel{
String district;
String hospital;
HospitalDtrictModel({this.district, this.hospital});

}