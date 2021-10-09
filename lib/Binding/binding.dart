 

import 'package:get/get.dart';
import 'package:waste/Login/login_controller.dart';
import 'package:waste/Network/Network_controller.dart';
import 'package:waste/Theme/theme_controller.dart';

class NetworkBinding  extends   Bindings{
  @override
   void dependencies(){
  
     Get.lazyPut<NetWorkController>(()=>NetWorkController());
     Get.lazyPut<LoginController>(()=>LoginController());

   }
}