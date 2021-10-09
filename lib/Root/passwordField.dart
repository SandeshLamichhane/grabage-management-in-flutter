
import 'package:flutter/material.dart';

class CustomPassordForm extends StatefulWidget {
  IconData iconData;
  String hintText;
  String fieldType; // email, phone,password,
  TextEditingController customController;
  Function(String) onChnageField;
  Function(String) onValidator;
  bool obscuretext;

  CustomPassordForm ({
    this.iconData = Icons.info_outline_rounded,
    this.fieldType = "password",
    this.hintText,
    this.customController,
    this.onChnageField,
    this.onValidator,
    this.obscuretext=true
  });

  @override
  _CustomPassordFormState createState() => _CustomPassordFormState();
}

class _CustomPassordFormState extends State<CustomPassordForm> {
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {    },
      child: TextFormField(
         onEditingComplete:(){
            print("/////////,,,,////////////"+widget.customController.text.toString());

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
            prefixIcon: Icon(widget.iconData),
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
                  color:  Theme.of(context).backgroundColor,
                fontFamily: "RobotoMono",
                fontSize: 18.0)),
      ),
    );
  }
  
String validatePassword(String value) {
  if(value.isEmpty){
    print("6 chars password required.");
    return "";
  }
  else {
     

         //var rx = new RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
        var rx = new RegExp(  r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$');

      if(rx.hasMatch(value)){
        return null;
      }else{
        return "password must contain one number or digit";
      }
  }
  
}
}