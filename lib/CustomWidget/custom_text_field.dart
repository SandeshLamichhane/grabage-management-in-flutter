import 'package:flutter/material.dart';
import 'package:waste/CustomWidget/TextFieldWIdget.dart';
import 'package:waste/confi/color.dart';

class CustomTextFormField extends StatelessWidget {
  IconData iconData;
  String hintText;
  String fieldType; // email, phone,password,
  TextEditingController customController;
  Function(String) onChnageField;
  Function(String) onValidator;

  CustomTextFormField({
    this.iconData = Icons.info_outline_rounded,
    this.fieldType = "name",
    this.hintText,
    this.customController,
    this.onChnageField,
    this.onValidator,
  });

  Widget build(BuildContext context) {
    return TextFormField(
      controller: customController,

      keyboardType: TextInputType.name,
      //  maxLength: 6,
      validator: (value) {
        if (fieldType == "email") {
          return value.trim() == ""
              ? "Email require"
              : value.isValidEmail
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
          return value.isValidName ? null : "Invalid Name";
        }
        if (fieldType == "description") {
          // return  value.isValidEmail ? null :"Invalid Email" ;

        }

        return null;
      },
      obscureText: false, // _obscuretext,
      onChanged: (value) {
        onChnageField(value);
      },
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
          prefixIcon: Icon(iconData, color: MyColor.textColor2),
          //  suffixIcon: GestureDetector(
          //  onTap: () {
          //setState(() {
          // _obscuretext= !_obscuretext;
          //    });
          //   },
          //  child: _obscuretext
          //   ? Icon(Icons.remove_red_eye)
          //     : Icon(Icons.lock_open_outlined)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.green),
          ),
          contentPadding:
              const EdgeInsets.only(left: 25.0, bottom: 18.0, top: 15.0),
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
              color: MyColor.textColor2,
              fontFamily: "RobotoMono",
              fontSize: 18.0)),
    );
  }
}

class CustomPassordFormField extends StatefulWidget {
  IconData iconData;
  String hintText;
  String fieldType; // email, phone,password,
  TextEditingController customController;
  Function(String) onChnageField;
  Function(String) onValidator;
  bool obscuretext;

  CustomPassordFormField({
    this.iconData = Icons.info_outline_rounded,
    this.fieldType = "password",
    this.hintText,
    this.customController,
    this.onChnageField,
    this.onValidator,
    this.obscuretext=true
  });

  @override
  _CustomPassordFormFieldState createState() => _CustomPassordFormFieldState();
}

class _CustomPassordFormFieldState extends State<CustomPassordFormField> {
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
                 if(hasFocus) {}
                                       },
      child: TextFormField(
         onEditingComplete:(){
            print("Done has been clicked");
        FocusScope.of(context).unfocus();
         validatePassword(widget.customController.text);
        },
        
        controller: widget.customController,
        keyboardType: TextInputType.text,
        validator: ((value) =>validatePassword(widget.customController.text)),
   
        obscureText: widget.obscuretext, // _obscuretext,
        onChanged: (value) {
                    widget.onChnageField(value);  //store value
                                                       },
        decoration: InputDecoration(
             errorText: validatePassword(widget.customController.text),
            errorStyle: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            prefixIcon: Icon(widget.iconData, color: MyColor.textColor2),
             suffixIcon: GestureDetector(
              onTap: () {
                 setState(() {
                       widget.obscuretext= !widget.obscuretext;
               });
               },
              child:    widget.obscuretext
           ? Icon(Icons.remove_red_eye)
                 : Icon(Icons.lock_open_outlined)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.green, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(width: 1.5, color: Colors.green),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(width: 1.5, color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(width: 1.5, color: Colors.green),
            ),
            contentPadding:
                const EdgeInsets.only(left: 25.0, bottom: 18.0, top: 15.0),
            filled: true,
            fillColor: Colors.green.withOpacity(0.1),
            labelText: widget.hintText,
            labelStyle: TextStyle(
                color: MyColor.textColor2,
                fontFamily: "RobotoMono",
                fontSize: 18.0)),
      ),
    );
  }
  
String validatePassword(String value) {
  if(value.isEmpty){
    print("value is empty");
    return "min 6 character password required.";
  }
  else if (
    
    (value.trim().length < 6) ) {
    return "Incorrect Password";
  }
  return null;
}
}