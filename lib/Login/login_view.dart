import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/Login/login_controller.dart';

class LoginView extends StatefulWidget {
    //LoginView({ Key ? key }) : super(key: key);
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isloading=true;
String login_email;

String login_password;

  @override
  Widget build(BuildContext context) {
    
    LoginController controller= Get.put(LoginController());
    return Scaffold(
   body: SafeArea( 
     child: ListView(
       padding: EdgeInsets.symmetric(horizontal: 10),

       children: [
       Center(child: Text("Login"),) ,
       TextFormField(
         decoration: InputDecoration(hintText: "Email"),
         onChanged: (value){
          setState(() {
             login_email=value;
          });
         },
       ),
       TextFormField(
           decoration: InputDecoration(hintText: "Passowrd"),
         onChanged: (value){
           setState(() {
             login_password=value;
           });
         },
       ), 
   
  GetBuilder(
       init: controller,
       builder:(controller){
         
        return  controller.isLoading.toString()=="true"? Center(child: CircularProgressIndicator(),)
        :Center(child: TextButton(
         style: TextButton.styleFrom(
           primary: Theme.of(context).primaryColor,
           onSurface: Theme.of(context).accentColor,
           shape:RoundedRectangleBorder(
              
           )
         ),
         onPressed: (){
         print(login_email+login_password);
         
         //log to firestore
         controller.firebase_login_with_eamil(email:login_email, password:login_password, 
         onSuccess: (String name){}, onfailure: (String xyz){} );
       }, child: Text("save")));
       }
     ),
SizedBox(height: 10,),
       
       ],
     ),
   ) 
      
    );
  }
}