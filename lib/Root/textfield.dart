import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waste/Root/regx.dart';
import 'package:waste/Settings/UserSetting/addVehicle/addVehicleController.dart';


class phoneTextField extends StatelessWidget {
  
IconData iconData;
  String hintText;
  String fieldType; // email, phone,password,
  TextEditingController customController;
  Function(String) onChnageField;
  Function(String) onValidator;

  String CurrentOnchangeValue="";

  phoneTextField({
    this.iconData = Icons.info_outline_rounded,
    this.fieldType = "phone",
    this.hintText,
    this.customController,
    this.onChnageField,
    this.onValidator,
  });

  Widget build(BuildContext context) {
    return TextFormField(
      controller: customController,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
      keyboardType:   TextInputType.phone,
      
      //  maxLength: 6,
      validator: (value) {
     return  isValidPhoneNumber(value);
     },
      obscureText: false, // _obscuretext,
      onChanged: (value) {
        onChnageField(value);
        CurrentOnchangeValue=value;
        

      },
       onEditingComplete:(){
                  FocusScope.of(context).unfocus();
                  isValidPhoneNumber(CurrentOnchangeValue.trim().toString());
                  //lets direclty verify the number
   
         } ,
      decoration: InputDecoration(
         errorText:   isValidPhoneNumber(CurrentOnchangeValue.toString()),
         errorStyle: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
          prefixIcon: Icon(iconData, color:  Theme.of(context).shadowColor),
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
            borderSide: BorderSide(width: 1.5, color: Colors.blue),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.green),
          ),
          contentPadding:
              const EdgeInsets.only(left: 25.0, bottom: 18.0, top: 19.0),
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
              color:  Theme.of(context).primaryColor,
              fontFamily: "RobotoMono",
              fontSize: 18.0)),
    );
  }
}

class simpleTextField extends StatelessWidget {
  
IconData iconData;
  String hintText;
  String fieldType; // email, phone,password,
  TextEditingController customController;
  Function(String) onChnageField;
  Function(String) onValidator;

  String CurrentOnchangeValue="";

  simpleTextField({
    this.iconData ,
    this.fieldType = "simple",
    this.hintText,
    this.customController,
    this.onChnageField,
    this.onValidator,
  });

  Widget build(BuildContext context) {
    return TextFormField(
       style: TextStyle(color: Colors.white),
      controller: customController,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9A-Z -]'))],
      keyboardType:   TextInputType.streetAddress,
      
      //  maxLength: 6,
      validator:  onValidator ,
      obscureText: false, // _obscuretext,
      onChanged: (value) {
        onChnageField(value);
        CurrentOnchangeValue=value;
        

      },
       onEditingComplete:(){
                    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
 
                  //lets direclty verify the number
   
         } ,
      decoration: InputDecoration(
     
         errorStyle: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
          prefixIcon: iconData==null ? null : Icon(iconData, color:  Theme.of(context).backgroundColor),
        
           focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide( width: 1, color: Colors.blueGrey)
          ),
         
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5,color: Colors.blueGrey),
          ),
         
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
         
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1,color: Colors.blueGrey),
          ),
         
          contentPadding:
              const EdgeInsets.only(left: 17.0, bottom: 18.0, top: 19.0),
          filled: true,
          
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
              color:  Theme.of(context).backgroundColor,
              fontFamily: "RobotoMono",
              fontSize: 18.0)),
    );
  }
 final _addVehicleController= Get.put(AddVehicleController());
 

}

class nametextField extends StatelessWidget {
  IconData iconData;
  String hintText;
  String fieldType; // email, phone,password,
  TextEditingController nameController;
  Function(String) onChnageField;
  Function(String) onValidator;

  String CurrentOnchangeValue="";

  nametextField({
    this.iconData = Icons.info_outline_rounded,
    this.fieldType = "name",
    this.hintText,
    this.nameController,
    this.onChnageField,
    this.onValidator,
  });

  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
    style:TextStyle(color:Theme.of(context).shadowColor),
      keyboardType:TextInputType.name,
      //  maxLength: 6,
      validator: (value) {
         if (fieldType == "name") {
         return isValidName(value);
        }
         return null;
      },
      obscureText: false, // _obscuretext,
      onChanged: (value) {
        onChnageField(value);
        CurrentOnchangeValue=value;
      },
       onEditingComplete:(){
            print("////////////////////////"+CurrentOnchangeValue);
            FocusScope.of(context).unfocus();
           isValidName(nameController.text.trim().toString());
          } ,
      decoration: InputDecoration(
         errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
           
          errorStyle: TextStyle(color: Colors.red, ),
          prefixIcon: Icon(iconData, color:  Theme.of(context).shadowColor),
         
             focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Theme.of(context).shadowColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5,  ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5,   color: Theme.of(context).shadowColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5,  ),
          ),
          contentPadding:
              const EdgeInsets.only(left: 25.0, bottom: 18.0, top: 19.0),
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
              color:  Theme.of(context).primaryColor,
              fontFamily: "RobotoMono",
              fontSize: 18.0)),
    );
  }
}

























class CustomTextFormField extends StatelessWidget {
  IconData iconData;
  String hintText;
  String fieldType; // email, phone,password,
  TextEditingController customController;
  Function(String) onChnageField;
  Function(String) onValidator;

  String CurrentOnchangeValue="";

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

      keyboardType: fieldType=="email" ? TextInputType.emailAddress: TextInputType.name,
      //  maxLength: 6,
      validator: (value) {
        if (fieldType == "email") {
          return  isValidEmailAddress(value);
        }
 
        if (fieldType == "password") {
          return value.isValidPassword ? null : "Minimum 6 character Password";
        }
        if (fieldType == "name") {
         return isValidName(value);
        }
        if (fieldType == "description") {
          // return  value.isValidEmail ? null :"Invalid Email" ;

        }

        return null;
      },
      obscureText: false, // _obscuretext,
      onChanged: (value) {
        onChnageField(value);
        CurrentOnchangeValue=value;
      },
       onEditingComplete:(){
            print("Done has been clicked");
            FocusScope.of(context).unfocus();
            fieldType=="phone"? 
           isValidPhoneNumber(CurrentOnchangeValue.trim().toString()):
           fieldType=="email"?
            isValidEmailAddress(CurrentOnchangeValue.trim().toString()):
             fieldType=="name"?
            isValidName(CurrentOnchangeValue.trim().toString()):  Get.snackbar("title", "message");
      
         } ,
      decoration: InputDecoration(
         errorText: fieldType=="phone" && CurrentOnchangeValue.isNotEmpty? 
         isValidPhoneNumber(CurrentOnchangeValue.toString()):
         fieldType=="email"?
          isValidEmailAddress(CurrentOnchangeValue.trim().toString()):
          fieldType=="name"?
          isValidPhoneNumber(CurrentOnchangeValue.trim().toString())
      :
         null,
           
          errorStyle: TextStyle(color: Colors.red),
          prefixIcon: Icon(iconData, color:  Theme.of(context).backgroundColor),
         
             focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Theme.of(context).shadowColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Theme.of(context).shadowColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.green),
          ),
          contentPadding:
              const EdgeInsets.only(left: 25.0, bottom: 18.0, top: 19.0),
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
              color:  Theme.of(context).backgroundColor,
              fontFamily: "RobotoMono",
              fontSize: 18.0)),
    );
  }
}


class DeleteTextField extends StatelessWidget {
  IconData iconData;
  String hintText;
 // email, phone,password,
  TextEditingController nameController;
  Function(String) onChnageField;
  Function(String) onValidator;

  String CurrentOnchangeValue="";

  DeleteTextField({
    this.iconData = Icons.info_outline_rounded,
     this.hintText="Delete Box",
    this.nameController,
    this.onChnageField,
    this.onValidator,
  });

  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,

      keyboardType:TextInputType.text,
      //  maxLength: 6,
      validator: (value) {
       if(value==null ||value.trim()=="")    {
         return "required" ;
      } 
         return  null ;
      },
      obscureText: false, // _obscuretext,
      onChanged: onChnageField,

      inputFormatters: [
      //  FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]'))
         
      ],
       onEditingComplete:(){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    } ,

      style:TextStyle(color: Colors.black),
      decoration: InputDecoration(
      //   errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
           
          errorStyle: TextStyle(color: Colors.red),
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
              const EdgeInsets.only(left: 25.0, bottom: 18.0, top: 19.0),
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
           //   color:  Theme.of(context).backgroundColor,
           //   fontFamily: "RobotoMono",
           color: Colors.grey,
              fontSize: 18.0)),
    );
  }
}

 

 
class MargTextField extends StatelessWidget {
 final IconData iconData;
   final String hintText;
 // email, phone,password,
 final  TextEditingController nameController;
 final Function(String) onChnageField;
 final  Function(String) onValidator;
 

  MargTextField({
    this.iconData ,
    this.hintText="Add your Marg",
    this.nameController,
    this.onChnageField,
    this.onValidator,
  });

  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,

      keyboardType:TextInputType.streetAddress,
      //  maxLength: 6,
      validator:  this.onValidator,
      
      obscureText: false, // _obscuretext,
      onChanged: onChnageField,

      inputFormatters: [
      //  FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]'))
         
      ],
       onEditingComplete:(){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    } ,

     // style:TextStyle(color: Colors.orange),
      decoration: InputDecoration(
      //   errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
            prefixIcon: iconData==null? null: Icon(iconData),
          errorStyle: TextStyle(color: Colors.red, ),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          contentPadding:
              const EdgeInsets.only(left: 17.0, bottom: 18.0, top: 19.0),
          filled: false,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
           //   color:  Theme.of(context).backgroundColor,
           //   fontFamily: "RobotoMono",
           color: Colors.grey,
              fontSize: 18.0)),
    );
  }
}


////////////////////////////////TIME INTERVAL ####################
 
class TimeInterValTextField extends StatelessWidget {
 final IconData iconData;
   final String hintText;
 // email, phone,password,
 final  TextEditingController nameController;
 final Function(String) onChnageField;
 final  Function(String) onValidator;
 

  TimeInterValTextField({
    this.iconData ,
    this.hintText="kun Samay Awadhima gadi pugchh",
    this.nameController,
    this.onChnageField,
    this.onValidator,
  });

  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,

      keyboardType:TextInputType.streetAddress,
      //  maxLength: 6,
      validator:  
      onValidator ,
 
      obscureText: false, // _obscuretext,
      onChanged: onChnageField,

 
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9A-Z./-]'))],
         
     
       onEditingComplete:(){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    } ,

     // style:TextStyle(color: Colors.orange),
      decoration: InputDecoration(
      //   errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
            prefixIcon: iconData==null? null: Icon(iconData),
          errorStyle: TextStyle(color: Colors.red),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          contentPadding:
              const EdgeInsets.only(left: 15.0, bottom: 18.0, top: 19.0),
          filled: false,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
           //   color:  Theme.of(context).backgroundColor,
           //   fontFamily: "RobotoMono",
           color: Colors.grey,
              fontSize: 18.0)),
    );
  }
}
//HOSPITAL NAME TEXT FILD ##########################
 class HospitalNameTextField extends StatelessWidget {
 final IconData iconData;
   final String hintText;
 // email, phone,password,
 final  TextEditingController nameController;
 final Function(String) onChnageField;
 final  Function(String) onValidator;
 

  HospitalNameTextField({
    this.iconData ,
    this.hintText="Enter hospital name",
    this.nameController,
    this.onChnageField,
    this.onValidator,
  });

  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,

      keyboardType:TextInputType.streetAddress,
      //  maxLength: 6,
      validator:  
      onValidator ,
 
      obscureText: false, // _obscuretext,
      onChanged: onChnageField,

 
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]'))],
         
     
       onEditingComplete:(){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    } ,

     // style:TextStyle(color: Colors.orange),
      decoration: InputDecoration(
      //   errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
            prefixIcon: iconData==null? null: Icon(iconData),
          errorStyle: TextStyle(color: Colors.red),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          contentPadding:
              const EdgeInsets.only(left: 15.0, bottom: 18.0, top: 19.0),
          filled: false,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
           //   color:  Theme.of(context).backgroundColor,
           //   fontFamily: "RobotoMono",
           color: Colors.grey,
              fontSize: 18.0)),
    );
  }
}

///////////////////////////NOw the gunassor 
///
//HOSPITAL NAME TEXT FILD ##########################
 class  GunasooTextField extends StatelessWidget {
 final IconData iconData;
   final String hintText;
 // email, phone,password,
 final  TextEditingController nameController;
 final Function(String) onChnageField;
 final  Function(String) onValidator;
 final int maxline;
 final int minline;
 final int length;

  GunasooTextField({
    this.iconData ,
    this.hintText="Enter hospital name",
    this.nameController,
    this.onChnageField,
    this.onValidator,
    this.maxline=1,
    this.minline=1,
    this.length=40,
  });

  Widget build(BuildContext context) {
    return TextFormField(
      maxLines:this.maxline,
      minLines:this.minline,
      controller: nameController,
     maxLength:this.length,

      keyboardType:TextInputType.multiline,
      //  maxLength: 6,
      validator:  
      onValidator ,
 
      obscureText: false, // _obscuretext,
      onChanged: onChnageField,

 
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-z A-Z .]'))],
         
     
       onEditingComplete:(){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    } ,

     // style:TextStyle(color: Colors.orange),
      decoration: InputDecoration(
      //   errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
            prefixIcon: iconData==null? null: Icon(iconData),
          errorStyle: TextStyle(color: Colors.red),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          contentPadding:
              const EdgeInsets.only(left: 15.0, bottom: 18.0, top: 19.0),
          filled: false,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
           //   color:  Theme.of(context).backgroundColor,
           //   fontFamily: "RobotoMono",
           color: Colors.grey,
              fontSize: 18.0)),
    );
  }
}
//////////////////////////////////////////////
 class  HometextField extends StatelessWidget {
 final IconData iconData;
   final String hintText;
 // email, phone,password,
 final  TextEditingController nameController;
 final Function(String) onChnageField;
 final  Function(String) onValidator;
 final int maxline;
 final int minline;
 final int maxLength;
  HometextField({
    this.iconData ,
    this.hintText="Enter Home No",
    this.nameController,
    this.onChnageField,
    this.onValidator,
    this.maxline=1,
    this.minline=1,
    this.maxLength=10,
    
  });

  Widget build(BuildContext context) {
    return TextFormField(
      maxLines:this.maxline,
      minLines:this.minline,
      controller: nameController,
      keyboardType:TextInputType.number,
      maxLength: 20,
      validator:  
      onValidator ,
      obscureText: false, // _obscuretext,
      onChanged: onChnageField,

 
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[ 0-9 .]'))],
         
     
       onEditingComplete:(){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    } ,

     // style:TextStyle(color: Colors.orange),
      decoration: InputDecoration(
      //   errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
            prefixIcon: iconData==null? null: Icon(iconData),
          errorStyle: TextStyle(color: Colors.red),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          contentPadding:
              const EdgeInsets.only(left: 15.0, bottom: 18.0, top: 19.0),
          filled: false,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
           //   color:  Theme.of(context).backgroundColor,
           //   fontFamily: "RobotoMono",
           color: Colors.grey,
              fontSize: 18.0)),
    );
  }
}


//Now the no of kotha or tala ############################# NO OF KOTHA OR TALA #############
class  DecimaltextField extends StatelessWidget {
 final IconData iconData;
   final String hintText;
 // email, phone,password,
 final  TextEditingController nameController;
 final Function(String) onChnageField;
 final  Function(String) onValidator;
 final int maxline;
 final int minline;
 final int maxLength;
  DecimaltextField({
    this.iconData ,
    this.hintText="Enter value",
    this.nameController,
    this.onChnageField,
    this.onValidator,
    this.maxline=1,
    this.minline=1,
    this.maxLength=10
  });

  Widget build(BuildContext context) {
    return TextFormField(
      maxLines:this.maxline,
      minLines:this.minline,
      controller: nameController,
      keyboardType:TextInputType.number,
      maxLength: maxLength,
      style: TextStyle(color:Theme.of(context).shadowColor),
      validator:  

      onValidator ,
      obscureText: false, // _obscuretext,
      onChanged: onChnageField,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9 .]'))],
       onEditingComplete:(){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    } ,
       decoration: InputDecoration(
      //   errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
            prefixIcon: iconData==null? null: Icon(iconData, color:Theme.of(context).shadowColor),
          errorStyle: TextStyle(color: Colors.red),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Theme.of(context).shadowColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Colors.grey),
          ),
          contentPadding:
              const EdgeInsets.only(left: 15.0, bottom: 18.0, top: 19.0),
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          labelStyle: TextStyle(
           //   color:  Theme.of(context).backgroundColor,
           //   fontFamily: "RobotoMono",
           color:Theme.of(context).primaryColor,
              fontSize: 18.0)),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////
 class  StringtextField extends StatelessWidget {
 final IconData iconData;
   final String hintText;
 // email, phone,password,
 final  TextEditingController nameController;
 final Function(String) onChnageField;
 final  Function(String) onValidator;
 final int maxline;
 final int minline;
 
  StringtextField({
    this.iconData ,
    this.hintText="Enter hospital Name",
    this.nameController,
    this.onChnageField,
    this.onValidator,
    this.maxline=1,
    this.minline=1,
  
    
  });

  Widget build(BuildContext context) {
    return TextFormField(
      maxLines:this.maxline,
      minLines:this.minline,
      controller: nameController,
      keyboardType:TextInputType.streetAddress,
       validator:  
      onValidator ,
      obscureText: false, // _obscuretext,
      onChanged: onChnageField,

    style:  TextStyle(color:Theme.of(context).shadowColor),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[ a-z A-Z .]'))],
         
     
       onEditingComplete:(){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    } ,

     // style:TextStyle(color: Colors.orange),
      decoration: InputDecoration(
      //   errorText: fieldType=="name"? isValidName(nameController.text.trim()): null,
            prefixIcon: iconData==null? null: Icon(iconData, color:Theme.of(context).shadowColor),
          errorStyle: TextStyle(color: Colors.red),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.green, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Theme.of(context).shadowColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color:  Theme.of(context).shadowColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1.5, color: Theme.of(context).shadowColor)
          ),
          contentPadding:
              const EdgeInsets.only(left: 15.0, bottom: 18.0, top: 19.0),
          filled: true,
          fillColor: Colors.green.withOpacity(0.1),
          labelText: hintText,
          
          labelStyle: TextStyle(
            color:  Theme.of(context).primaryColor,
           
              fontSize: 18.0)),
    );
  }
}