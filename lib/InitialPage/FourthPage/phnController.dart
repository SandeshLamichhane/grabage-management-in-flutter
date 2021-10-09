import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Home/Home_view.dart';
import 'package:waste/InitialPage/FifthPage/CreatePassword.dart';
import 'package:waste/InitialPage/FourthPage/verifyPhone.dart';
import 'package:waste/InitialPage/SecondPage/SecondPage.dart';
import 'package:waste/InitialPage/SecondPage/SecondPageController.dart';
import 'package:waste/InitialPage/userModel.dart';
 import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Root/root.dart';
 
class PhoneNumberController extends GetxController {

FirebaseAuth _auth= FirebaseAuth.instance;
static String _verificationCode ;
TextEditingController pinPutController = new TextEditingController() ;
   final _secondPagecontroller= Get.put(  secondPageController());


User user;

  @override
  void dispose() { 
    pinPutController.dispose();
    super.dispose();
  }

 

var _isResending=false.obs;

var _codehasbeenSend=false.obs;
 bool get codehasbeenSent=>_codehasbeenSend.value; 
 
  
final box= GetStorage();

CollectionReference ref= FirebaseFirestore.instance.collection("users");
 
 void comparePinToken( String pin) async {
    _codehasbeenSend.value=true;
   if(_verificationCode==null){
     BotToast.showText(text: "यदि तपाइले कोड नपाएको भए, पुन पठाउनुहोस्");
     return;}
  print("pin is"+pin+ "verificationcode "+_verificationCode);
    try{
 DisplayLoading.show(text:"कृपया पर्खनुहोस....", display: true);
 await FirebaseAuth.instance.signInWithCredential(
   PhoneAuthProvider.credential(
         verificationId: _verificationCode.trim(), 
         smsCode: pin.trim())).then((value) async{
           
         if(value.user.uid!=null){
           print("successfull");
           user=value.user; //set current user as firebase user
  DisplayLoading.show(text:"Please wait...", display: false);
 methodForStoringUserInfo(value.user.phoneNumber, value.user.uid);
   
 } else{
   BotToast.showText(text: "Something went wrong...");
   }
 });
 
       
 } on FirebaseAuthException catch (e){
   //  FocusScope.of(context).unfocus();
         Get.snackbar(" Invalid otpx", e.message, backgroundColor: Colors.orange[900]);
      }
      catch(error){
         Get.snackbar("Exception", error.toString(), backgroundColor: Colors.orange[900]);

      }
      finally{
    
        DisplayLoading.show(text:"Please wait...", display: false);

        //pinPutController.clear();

      }
      }
 
///////////////////////////////////////////////////////////////////////////////////////////
sendAuthenticationtoPhone(String phone) async{
  print(phone);
  _codehasbeenSend.value=false;
try{
 

box.write(boxuserPhoneNumber, phone);//set user in box storae

await FirebaseAuth.instance.verifyPhoneNumber (

phoneNumber: '$phone',
  
verificationCompleted: (PhoneAuthCredential credential) async{
    
await  _auth.signInWithCredential(credential).then((value) async{

 if(value.user!=null){
           user=value.user;
          await methodForStoringUserInfo(value.user.phoneNumber, value.user.uid);
         }
       });
    //store data to firestore and fireabase
  },
  verificationFailed: (FirebaseAuthException e) {
    Get.snackbar("Something Went Wrong", e.message.toString());
  },

  codeSent: (String verificationId, int resendToken) {
    // resend token works on andrpoid only
     DisplayLoading.show(text: "", display:false);
    Get.to(VerifyYourPhone(phoneNumber: phone));
   
     _codehasbeenSend.value=true;
    _verificationCode=verificationId;
    BotToast.showText(text: "तपाइको फोनमा कोड पठाइएको छ");
    
  },
  codeAutoRetrievalTimeout: (String verificationId) {},

// TIME OUT FOR THE  VERIFICATION EMAIL ???????????????????????????????
  timeout:  Duration(seconds: 120),//its for only  android for android resolution
);

  }
   on FirebaseException catch( Error){
     Get.snackbar("Error", Error.message.toString());
      _codehasbeenSend.value=false;
   }

}

methodForStoringUserInfo(String phoneNumber, String uid) async{
   //he user phone ....................
DisplayLoading.show(text: "कृपया पर्खनुहोस... ", display: true);
var snapshot=await ref.where('userPhone', isEqualTo:  phoneNumber).get().catchError((onError){  
   Get.snackbar("error", onError.toString());});


 
  if(snapshot.docs.length<1){
  //it means that the document is first time create
  try{
  var xyz=  UserModel(
             userName: "null",
              userPhoneNumber:  phoneNumber,
              userBlockState: "no",
              userJoinedDate: DateTime.now().toString(),
              userRole: "user",
              userId: uid,
             userVerifyState: "yes",
             userFrom: await box.read(boxuserfrom),
             geoPoint: GeoPoint(0.0, 0.0),
             oda: "null",
             maarga: "null",
             district: "null",
             hospitalName: "null",
             homeId: 'null',
             hospitalId: 'null'
   ) ;
  // UserModel.set(xyz);
 
await ref.doc(uid).set(xyz.toMap(xyz)).then((value) {
         SetBoxData.mapuser(xyz);
         pinPutController.clear();
        DisplayLoading.show(text: "", display: false);
         Get.off(CreatePassword());
         }).catchError((error) {
      Get.snackbar("Error on stofing data.", error.toString());
    });
  
  }
  catch(e){
     BotToast.showText(text: e.toString());
  }
 }else{
   //lets updae user verified state to yes

  

   try{
   snapshot.docs.forEach((element) {
 
    // SetBoxData.mapuser(UserModel.fromJson(map));
   //UserModel.set(UserModel.fromJson(element.data()));
      UserModel md=UserModel();
        var mx=      md.fromMap(element.data());
          UserModel.set(mx);
          
    _secondPagecontroller.movetoNextPage();
   });
   //2nd case
   
  
  //according to user    level drive to next page;
      DisplayLoading.show(text: "", display: false);

    
 }catch(e){
   BotToast.showText(text: e.toString());

 }finally{
         DisplayLoading.show(text: "", display: false);
 }
  
 }
   

//if the user is already registered then,,,,,,,,,,,,,,,,,,,,,
  

 
 
}

}
