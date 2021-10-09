 

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Language/lang_controller.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/root.dart';
import 'package:waste/Settings/SettingController.dart';
import 'package:waste/Settings/UserSetting/userDashboard.dart';
import 'package:waste/Theme/theme_changer_view.dart';
import 'package:waste/Theme/theme_controller.dart';
import 'package:waste/adminDashBoard/admindashboard.dart';
import 'package:waste/confi/color.dart';

 
class UserSetting extends StatefulWidget {

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
 // ThemeMode _themeMode  ; //it s for the theme mode set up

 FirebaseAuth _auth= FirebaseAuth.instance;
 
  String lng; // its for login page.................

String currentLanguage;

final box= GetStorage();
final firestorecontroller= Get.put<FirestoreService>(FirestoreService());
  @override
  void initState() {
    super.initState();
    lng = LanguageController().getCurrentLang();
    //  _language= LanguageController().getCurrentLang();
       firestorecontroller.UserListener();
    if(box.read(boxuserRole)=='admin' || (box.read(boxuserRole))=='moderator'){
 firestorecontroller.setisAdmin=true;
    }
  }

  @override
  Widget build(BuildContext context) {
      currentLanguage = LanguageController().currentLanguage;
      final box=GetStorage();
        
   //  _themeMode = ThemeController
  //      .to.themeMode; //STEP 7 - get the theme from ThemeController
   //         print('${MediaQuery.of(context).platformBrightness}');
    print('${Theme.of(context).brightness}');
    return Scaffold(
     // backgroundColor: MyColor.backgroundColor,
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body : Container(
        margin:EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          
           children: [
         
         //  CHANGE USER PROFILE ##############################################################

        Container(
          padding: EdgeInsetsDirectional.all(5.0),
          margin: EdgeInsetsDirectional.all(8.0),
            decoration:  
              BoxDecoration(
              //  color: MyColor.whiteColor,
               boxShadow: [
                 BoxShadow(
                   color: Colors.grey.withOpacity(0.3),
                   blurRadius: 1,
                   spreadRadius: 2
                 )
               ]
 
            ),
            
              child: ListTile(
                trailing: Icon(CupertinoIcons.arrow_right_circle_fill),
                onTap: () {
               //   final box = GetStorage();
               //   box.write('userName', DateTime.now().toString());
   
        //    controller.addtoFirebase(DateTime.now().toString(), "5");
                 // controller.changeName("sandesh" + DateTime.now().toString());
                },
                title: Text("Current User"),
              ),
            ),

         // CHNAGE USER  ###################################################################

    Container(
       margin:EdgeInsets.symmetric(horizontal: 8.0),
      decoration:   BoxDecoration(
               // color: MyColor.whiteColor,
               boxShadow: [
                 BoxShadow(
                   color: Colors.grey.withOpacity(0.3),
                   blurRadius: 1,
                   spreadRadius: 2
                 )
               ]
             ),
      child: ExpansionTile(
        
  title: Text(
      "Select Theme",
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
  ),
  children: <Widget>[
      //           color:  Theme.of(context).accentColor  ) 
       select_theme_mode(),
      
  ],
),
    ),
 


////////////////////////////////////// FOR LANGUAGE ////////////////////////
     
     //Text('hello_title'.tr),

 


     Container(
      
       decoration: BoxDecoration(
        boxShadow: [
                 BoxShadow(
                   color: Colors.grey.withOpacity(0.3),
                   blurRadius: 1,
                   spreadRadius: 2
                 )
               ]),
       margin: EdgeInsets.symmetric(horizontal:8.0, vertical: 8.0),
       child:  
         
         DropdownButton<String>(
            items: LanguageController.langs.map((String value) {
         
             return new DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left:0.0),
                          child: new Text (value),
                        ),
                      );
                    }).toList(),
                    value: this.lng,
                    underline: Container(color: Colors.transparent),
                    isExpanded: false,
                    onChanged: (newVal) {
                      print(newVal+",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
                      setState(() {
                        this.lng = newVal;
                        LanguageController().changeLocale(newVal);
                      });
                    }),
       ),



ElevatedButton(onPressed: (){Get.to(adminDashboard());},child:Text("Dashboard")),

   ElevatedButton(
     
     onPressed: (){
       firestorecontroller.UserListener();
      
   }, child: Text("user Listener")),

   /// ##########33############################### USER LISTENER ######################
  Obx(()=>(
     firestorecontroller.isAdmin?
    ClipRRect(
    child: SizedBox(
      height: 50,
      child: ElevatedButton(onPressed: (){
        Get.to(UserDashboard());
  
      }, child: Text("User Panel"+box.read(boxuserRole)+firestorecontroller.isAdmin.toString()))
    ),
  
    ): SizedBox(height: 0.5,))),
  SizedBox(height: 10,),
   ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
               
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    //logout from firebase;
                   _auth.signOut();
                   
                       
                    //log out from box storage
                   writeNullBoxValue();
                      
                    //go to login page

                    Get.offAll(Root());
                  },
                  child: Text("Log Out"),
                  style: ElevatedButton.styleFrom(
                                        
                  ),

                ))),
     
                ],

        ),
      )
      
    );
  }
   writeNullBoxValue(){
      final box= GetStorage();
        box.write(boxUserId, "null");
         box.write(boxuserName,  "null");
         box.write(boxuserPhoneNumber,  "null");
         box.write(boxuserRole,  "null");
         box.write(boxblockState,  "null");
         box.write(boxverifiedState,  "null");
         box.write(boxuserType,  "null");
         box.write(boxUserPassword, "null");
         box.write(boxuserMarg, "null");
         box.write(boxuserLat,  "null");
         box.write(boxuserLong,'null');
        }
}