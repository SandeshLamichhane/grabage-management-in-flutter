import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class  ThemeController extends  GetxController{

  static ThemeController  get to =>Get.find();

  GetStorage storage;
  ThemeMode _themeMode;

  ThemeMode get themeMode=>_themeMode;
//########################## SET THEME ############################
  Future <void> setThemeMode(ThemeMode themeMode) async{
    Get.changeThemeMode(themeMode); //it check user input and chnage theme
   _themeMode =themeMode;
   update(); //it notify the listener
   storage= await GetStorage();
   await storage.write('theme', themeMode.toString().split('.')[1]); //it split Themode.dark // Thememode.light and store onlu dark and light 


  }
  // ####################### GET THEME #############################
  getThemeModeFromStorage() async{

  ThemeMode themeMode;

  storage= await GetStorage();
  //now  retriave theme text
  String themeText= storage.read('theme')??'system'; //if null then make it system theme
  print("After reading themetext the value is..................................................."+themeText);
  try{
  themeMode= ThemeMode.values.firstWhere((element) => describeEnum(element)==themeText);
  print(themeMode.toString());
  //firstwhere return  first element of matching element
  //describe enum return
  }catch(e){
    themeMode=ThemeMode.system; //if mistake assign theme return thememode.system

  }finally{
  setThemeMode(themeMode);
  }

  }
}