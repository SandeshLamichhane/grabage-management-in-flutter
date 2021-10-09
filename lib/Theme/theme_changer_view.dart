import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/Theme/theme_controller.dart';

class select_theme_mode extends StatefulWidget {
  
//  const select_theme_mode({ Key? key }) : super(key: key);

  @override
  _select_theme_modeState createState() => _select_theme_modeState();
}

class _select_theme_modeState extends State<select_theme_mode> {
  ThemeMode _themeMode  ;
  
  @override
  Widget build(BuildContext context) {
      _themeMode = ThemeController
        .to.themeMode; //
    return  Column(
              mainAxisSize:  MainAxisSize.min,
              children: [

                RadioListTile(
              title: Text('system', ),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() {
                //  _themeMode = value;
                //  Get.changeThemeMode(_themeMode); //STEP 3 - change themes
                _themeMode = value;
                   ThemeController.to
                      .setThemeMode(_themeMode);
                });
              },
          ),
           
            RadioListTile(
            title: Text('dark'),
            value: ThemeMode.dark,
            groupValue: _themeMode,
            onChanged: (value) {
              setState(() {
                _themeMode = value;
                 ThemeController.to
                    .setThemeMode(_themeMode); //STEP 8 - change this line
               
               // _themeMode = value;
                //print(value.toString());
                //Get.changeThemeMode(_themeMode);
              });
            },
          ),
            RadioListTile(
            title: Text('light', style: TextStyle()),
            value: ThemeMode.light,
            groupValue: _themeMode,
            onChanged: (value) {
              setState(() {
                _themeMode = value;
                 ThemeController.to
                    .setThemeMode(_themeMode);
             //   _themeMode = value;
               // Get.changeThemeMode(_themeMode);
              }); } 
             ),]
      );
  }
}