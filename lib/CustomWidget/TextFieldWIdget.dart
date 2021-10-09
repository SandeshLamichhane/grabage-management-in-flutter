import 'package:flutter/material.dart';
import 'package:waste/confi/color.dart';
 

Widget build_text_field({
  IconData iconsData,
  String hintText,
  String fieldType, // email, phone,password,
  TextEditingController custom_controller,
  VoidCallback onTapped,
  Function(String) onChnageField,
  Function(String) onValidator,
  double mq_height,
 
}) {
  return  
      TextFormField(
        controller: custom_controller,
        onTap: () => onTapped(),
        onChanged: (value) {
          onChnageField(value);
        },
        validator: (value) {
          if (fieldType == "email") {
            return value.trim()=="" ? 
                   "Email required" :
                    value.isValidEmail
                     ? null
                    : "Invalid Email Address"; //chech email is correct or not //return null else we get error
          }

          if (fieldType == "phone") {
            return value.isValidPhone ? null : "Invalid Phone Number";
          }

          if (fieldType == "password") {
            return value.isValidPassword ? null : "Minimum 6 character Password";
          }
          if (fieldType == "name") {
            return value.isValidEmail ? null : "Invalid Name";
          }
          if (fieldType == "description") {
            // return  value.isValidEmail ? null :"Invalid Email" ;

          }

          return null;
        },
        obscureText: fieldType == "password" ? true : false,
        keyboardType: fieldType == "phone"
            ? TextInputType.number
            : fieldType == "email"
                ? TextInputType.emailAddress
                : fieldType == "name"
                    ? TextInputType.text
                    : TextInputType.text,
        maxLines: 1,
        decoration: InputDecoration(
            prefixIcon: Icon(iconsData, color: MyColor.textColor1),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColor.textColor1),
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.all( 10.0),
            labelText: hintText,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColor.textColor1),
                borderRadius: BorderRadius.circular(35.0)),
            labelStyle:
                TextStyle(fontSize: mq_height / 50, color: MyColor.textColor1)),
      );
}

extension extString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = new RegExp(
        // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
        r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$');

    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}

////////////////////////######################  THIS IS MAINLY FOR THE BUTTON ######################

class BuildButtonWithContainer extends StatelessWidget {

    final String text;
    final VoidCallback onClicked;
    Color color;
    Color cx= Colors.blue[900];
    BuildButtonWithContainer({
      Key key,
      this.text="Submit", 
      this.onClicked,
      this.color=MyColor.blueColor
    }): super(key: key);

    @override
    Widget build(BuildContext context) {

      return  Card(
      color: color,
       child: InkWell(
       onTap: (){}, // handle your onTap here
       child: InkWell(
         onTap: onClicked, //void call back
         child: Container(height: 50, 
         decoration: BoxDecoration(
         boxShadow: [
             BoxShadow(
             color:  color.withOpacity(0.1),
             spreadRadius: 5,
             blurRadius: 1,
           )
         ],
          borderRadius: BorderRadius.circular(15.0),
         ),
     child: Center(child: Text(text, style: TextStyle(color:  MyColor.whiteColor, fontSize: 19, 
                                      fontFamily: "Brand Bold",)),
          )
      ),
       ),
    ),
  );
    }
  }
//#########################################################################################
  class BuildCustomButton extends StatelessWidget{
    final String text;
    final VoidCallback onClicked;

    BuildCustomButton({
      Key key,
      this.text="Submit", this.onClicked
    }): super(key: key);

    @override
    
    Widget build(BuildContext context) {
      return   TextButton(
                  style: TextButton.styleFrom(
                     
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                            color: Color.fromRGBO(0, 160, 227, 1),
                          )
                          ),
                      padding: EdgeInsets.all(8.0),
                      primary: Colors.white,
      backgroundColor: Colors.teal,
      onSurface: Colors.grey,),
                  onPressed: onClicked,
              
                  child: InkWell(
                    onTap: (){},
                    child: Container(
                      
                      child: Text( 
                        
                        text, style: TextStyle(color: MyColor.whiteColor,
                       fontFamily: "Brand Bold", fontSize: 20.0),),
                    ),
                  ));
               
        
    }

  }


