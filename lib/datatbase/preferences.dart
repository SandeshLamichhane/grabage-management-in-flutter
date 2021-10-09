import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste/datatbase/connectivity.dart';
import 'package:waste/datatbase/user_store.dart';


class LocalData extends GetxService{

  static SharedPreferences _preferences;
  static Future init() async=> _preferences= await SharedPreferences.getInstance();

  static const _keyUsername='user_name';
  static const _KeyUserid= 'user_id';
  static const _Keyemail='user_email';
  static const _keyverified ='isVerified';
  static const _keyRememberMe="remember";
  static const _keyUserRole="role";
  static const _keyBlocked="blocked";
    static const _KeyLoginStyle="loginstyle";
    static const _KeyImageUrl="imageurl";


  //set the userDetail
  static Future setUserDetail({
    
      String user_id,
       String user_name,
        String user_email, 
        String is_verified,  
        String is_blocked,
    String role,
 }) async {

    _preferences.setString(_KeyUserid, user_id);
    _preferences.setString(_keyUsername, user_name);
    _preferences.setString(_Keyemail, user_email);
     _preferences.setString(_keyverified, is_verified);
     _preferences.setString(_keyUserRole,role );
     _preferences.setString(_keyBlocked, is_blocked);

  }


  static Future updateVerifiedState(String is_verified) async {
 _preferences.setString(_keyverified, is_verified);
   }

  // FOR SETTING REMEMBER ME VALUE
  static Future setRememberMe(String value) async =>_preferences.setString(_keyRememberMe, value);

/////////////////////////////////////////////////////////////////////////////////
static  RxString deviceUser="".obs;
  static Future setUserName(String userName) { _preferences.setString(_keyUsername, userName).obs;// lets make it observabe
    print("i am inside");
        deviceUser= _preferences.getString(_keyUsername).obs ?? "".obs;
   }

//////////////////////////////////////////////////SETTER ///////////////////////////////
 static Future setLoginStyle(String logstyle)=> _preferences.setString(_KeyUserid, logstyle);
 static Future setUserId(String userdId)=> _preferences.setString(_KeyUserid, userdId); //user id;

 static Future setEmail(String userEmail)=> _preferences.setString(_Keyemail, userEmail);
 static Future setVericationState(String isVerified)=>  _preferences.setString(_keyverified, isVerified);
  static Future setRole(String role)=> _preferences.setString(_keyUserRole,role );
 static Future setBlocked(String blocked)=>  _preferences.setString(_keyBlocked, blocked);
  static Future setUserImageUrl(String url)=>  _preferences.setString(_KeyImageUrl, url);


  ///////////////////////////////////////////////////GETTER /////////////////////////////

   static String getUserId()=> _preferences.getString(_KeyUserid) ?? "";
   static RxString getUserName()=> _preferences.getString(_keyUsername).obs ?? "";
   static String getUserEmail()=> _preferences.getString(_Keyemail) ?? "";
   static String getUserVerifiedState()=> _preferences.getString(_keyverified) ?? "";
  static String getUserRememberLogin()=> _preferences.getString(_keyRememberMe) ?? "";
     static String getUserrole()=> _preferences.getString(_keyUserRole) ?? "";
  static String getUserBlockedStatus()=> _preferences.getString(_keyBlocked) ?? "";
  static String getLoginStyle()=> _preferences.getString(_KeyLoginStyle) ?? "";
  static String getUserImageUrl()=> _preferences.getString(_KeyImageUrl) ?? "";

 
 synchronize_local_data_to_firestore() async{

   //check user is not null
   if(getUserId()!=""){

     //chck the internet
     bool hasInternet= await My_Wifi().Check();
  

    if(hasInternet){
    //lets synchronize the data for this user from firestore to local data
    
     Map data=   await  UserDatabase().user_info_from_id(getUserId());

     //after synchronization check error
     if(data['error']==''){
       print("error occured on getting user id from firestore");
       return ;
     }
      print("Success full synchronization of the local data with the firestpre");
     /* setUserDetail(
       data['user_id'], 
      data['user_name'], 
      data['user_email'], 
      data['user_verified'],
      data['user_blocked'],
       data['user_role']  );*/
    }
   
   }
 }




}