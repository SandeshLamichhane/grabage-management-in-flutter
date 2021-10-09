import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/Binding/binding.dart';
import 'package:waste/Language/lang_controller.dart';
import 'package:waste/Theme/theme_controller.dart';
import 'package:waste/confi/color.dart';
import 'package:waste/datatbase/preferences.dart';
 
import 'Root/root.dart';
import 'datatbase/connectivity.dart';
import 'datatbase/preferences.dart';
import 'package:get_storage/get_storage.dart';
 
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}

 /// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future <void> main() async{
   WidgetsFlutterBinding.ensureInitialized();// flutter initialization
   await Firebase.initializeApp();
  // back ground message handler
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

   
  
   await GetStorage.init();
// call all the storage for the app
 Get.lazyPut<ThemeController>(()=>ThemeController());

await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  
   

 //initialization of preferences
// await  LocalData.init(); 
 // initialization of shared preferences
// await  LocalData().synchronize_local_data_to_firestore(); 
   
  



  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)   {
    ThemeController.to.getThemeModeFromStorage();//get saved theme at start up



  // if(LocalData.getUserRememberLogin()=='no'){
     // user has set to no remember me on this device
   //   LocalData.setUserDetail("", "", "", "", "", "");
  //  }

   // if(LocalData.getUserrole()=='admin'){
      //####################### IF SOMEONE IS ADMIN  THEN ITS NECESSARY TO LOGIN EVERY TIME IN APP 
      // ################ DESTRYOY THE ADMIN LOCAL DATA IF PRESENCE
      // LocalData.setUserDetail("", "", "", "", "", "");
   // }
   return GetMaterialApp(
     initialBinding: NetworkBinding(),
      title: 'Theme change using Get',
      theme: ThemeData.light().copyWith( 
                brightness: Brightness.light,  
                   primaryColor:Colors.green[900],// Colors.blue[900],
                  shadowColor: Colors.grey[900],
                  errorColor: Color(0xFFF25E04) ,
              
              backgroundColor: const Color(0xFFE6F1FC),
              accentColor: Color(0xFF000000),
             //// accentIconTheme: IconThemeData(color: Colors.white),
              //  dividerColor: Colors.white54,

            
                  
                    
  //  // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
   // textTheme: TextTheme(
    //  headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.red),
  //  headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
     // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind',  ),
    // ),
  ),
      darkTheme: ThemeData.dark().copyWith(
                  brightness: Brightness.dark,  
                   primaryColor:Colors.green[900],// Colors.blue[900],
                  shadowColor: Colors.grey[900],
                  errorColor: Color(0xFFF25E04) ,
              
                backgroundColor: const Color(0xFFE6F1FC),
              
         accentColor: Colors.white),
      // NOTE: Optional - use themeMode to specify the startup theme
      themeMode: ThemeMode.system,
/////////////////////////////////////////////LANGUAGE ////////////////////////
      translations: LanguageController(), // your translations
      locale: LanguageController().getCurrentLocale(), // translations will be displayed in that locale
      fallbackLocale: Locale(
        'en','US',
      ), 
       builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()], // specify the fallback locale in case an invalid locale is selected.
      home: Root(),
    );
    
 
  }
} 
 