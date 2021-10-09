 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Language/langs/english.dart';

import 'langs/nepali.dart';
 
 enum languageType{
   English,
   Nepali
 }

 class LanguageController extends  GetxController implements  Translations{

    static LanguageController  get to =>Get.find();// staticc object of it

  String _currentLanguage ;

  String get currentLanguage=>_currentLanguage;

   static final locale = Locale('en', 'US');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  // Needs to be same order with locales
  static final langs = ['English','Nepali'];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
  //  Locale('npi', 'NPL)'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        
        'hi_IN':hiIN,
       // 'np_NP': nepNP,
        
         // lang/ar_AE.dart
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    print("This need to changed......................."+lang);
     final locale = getLocaleFromLanguage(lang);

     final box = GetStorage();
     box.write('lng', lang);
     _currentLanguage=lang; update();
     Get.updateLocale(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      
      if (lang== langs[i]){ 
        print(locales[i].toString());
        return locales[i];}
    }
    return Get.locale;
  }

  Locale getCurrentLocale() {
    final box = GetStorage();
    Locale defaultLocale;

    if (box.read('lng') != null) {
      final locale =
           LanguageController().getLocaleFromLanguage(box.read('lng'));

      defaultLocale = locale;
    } else {
      defaultLocale = Locale(
        'en',
        'US',
      );
    }

    return defaultLocale;
  }

    getCurrentLang() {
     final box = GetStorage();

     return box.read('lng') != null ? box.read('lng') : "English";
  }

 }