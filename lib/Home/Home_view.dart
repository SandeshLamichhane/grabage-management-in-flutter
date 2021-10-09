import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Home/Billing/Billing_page.dart';
import 'package:waste/Home/Vehicle/VehicleInfo.dart';
import 'package:waste/Home/Home_controller.dart';
import 'package:waste/Home/Notification/notification_view.dart';
import 'package:waste/Login/login_controller.dart';
import 'package:waste/Network/Network_controller.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/root.dart';
import 'package:waste/Settings/Setting_view.dart';
  

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final box= GetStorage();

StreamSubscription<ConnectivityResult> subscription ;
StreamSubscription<DocumentSnapshot> streamSubscription ;
 var subs;
@override
void initState() { 
  super.initState();
    final Connectivity _connectivity = new Connectivity();
    //listent to current user change //
try{
 /*
   streamSubscription=  FirebaseFirestore.instance.collection("users").doc(box.read(boxUserId)).snapshots().listen((event) { 
      var data= event.data()  ;
      print(data); 
      BotToast.showText(text: data.toString());
      if(data['userBlockState']=='yes'){
        SetBoxData.store(blockState:data['userBlockState'] );
         print("//Get.off(Alll to Blocked page");
         
      }
      
    }); /.;'
 */

}
catch(error){
  BotToast.showText(text: error.toString());
}
}

void dispose() { 
   super.dispose();
  
  streamSubscription.cancel();
}


  @override
  Widget build(BuildContext context) {
     LoginController controller = new LoginController();


final LoginController _loginController= Get.put(LoginController());

    return GetBuilder<HomeControler>(
      init: HomeControler(),
      builder: (xcontroler){

        return 
   
  Scaffold(
     // appBar: AppBar(),
      body: SafeArea(
      child: IndexedStack(
        index: xcontroler.tabIndex,
      children: [
        VehicleInfo (),
        BillingPage(),
        MyNotification(),
        UserSetting()
        
        //Obx(()=>Text("Wifie"+_netcontroller.connectionstatus.value.toString() )),
       //
       //Obx(()=>Text("My count value: "+_netcontroller.Mycount.value.toString() )),
       //Obx(()=>Text("My count value from box"+ GetStorage().read('quote'))),
       /* GetX(
        init: _netcontroller,
        builder: (controler)=>Text(controler.count.toString())),*/
    
       /*   Text("Login status:"+ _loginController.isLoggedin.toString()),
        TextButton(onPressed: (){
       
       _loginController.firebase_logout(); */
    
    
       //box.write("sande", "value");
       //    print("Current user is "+FirebaseAuth.instance.currentUser.email);
       //   print("Bro"+FirebaseAuth.instance.currentUser.email.toString());
        
    
    
      ],
      ),),
    
      bottomNavigationBar:  BottomNavigationBar(
      unselectedItemColor: Colors.blue,
      selectedItemColor: Colors.redAccent,
      onTap: (value) { xcontroler.changeTabIndex(value); },
      currentIndex: xcontroler.tabIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type:BottomNavigationBarType.shifting,
       
      items: [
        _bottomNavigationBarItem( iconData: CupertinoIcons.home,label:"Home"),
        _bottomNavigationBarItem( iconData: CupertinoIcons.creditcard,label:"Bill"),
        _bottomNavigationBarItem( iconData: CupertinoIcons.creditcard,label:"Gunaso"),

        _bottomNavigationBarItem( iconData: CupertinoIcons.settings,label:"Settings")
    
      ],

      )
  );
      });
      
  

// BOTTOM NAVIGATION  BAR >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>







  }

  void onConnectivityChange(ConnectivityResult event) {
   // Get.snackbar("title",event.toString());
  }

  _bottomNavigationBarItem({IconData iconData, String label}){

    return BottomNavigationBarItem(
      icon: Icon( iconData,),
    label: label,
    
    );
  }
}
