 
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:waste/datatbase/preferences.dart';
import 'package:waste/modal/Users.dart';

class FirebaseDatabase {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel userModel = UserModel();
  User user = FirebaseAuth.instance.currentUser;
  final userRef = FirebaseFirestore.instance.collection("waste_users");
  WasteUser wasteUser = new WasteUser();

  // managing the user state via stream.
  // stream provides an immediate event of
  // the user's current authentication state,
  // and then provides subsequent events whenever
  // the authentication state changes.
  Stream<User> get authStateChanges => _auth.authStateChanges();

  User firebaseUser;
  LocalData localData;
//lets create a future for sign in

  /////////////////////////////////////////CREATE ACOOUNT WITH EMAIL AND PASSWORD RETURN USER CREDENTIAL IF SUCCESS
  login_with_emailpassword(
      {String email,
      String password,
      bool rememberMe,
      Function(String) onfailure,
      Function(String) onSuccess}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        onSuccess("Successfull Registration");

        firebaseUser = value.user; //set login status to firebase to
        //set data to shared preferences
      
        return;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onfailure('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        onfailure('Wrong password provided.');
      }
    } catch (e) {
      onfailure(e.toString());
    }
  }

/////////////////////////////////////////////////LOG OUT //////////////////////////////////////////////////
 Future<void> signOut() async {
  await  FirebaseAuth.instance.signOut();
}
  Future<Map<String, dynamic>> get_user_info_from_userId(String userid) async {}

  /////////////////////////////////////////CREATE ACOOUNT WITH EMAIL AND PASSWORD RETURN USER CREDENTIAL IF SUCCESS
  create_new_user_withemail_firebase(
      {String email,
      String password,
      Function(String) onfailure,
      Function(String) onSuccess}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        firebaseUser =
            value.user; //  assign user credential user to firebsae user
        await value.user.sendEmailVerification();
        onSuccess("Success"); //calback function on success
        return;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onfailure(" The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        onfailure('The account already exists for that email.');
      } else {
        onfailure("Something Went Wrong.");
      }
    } catch (e) {
      onfailure(e.toString());
    }
  }

  //reset the password
  send_email_to_rest_password(email) async {
    String FB_error = 'success';

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (error) {
      print(error.code);
      FB_error = error.code;
    }

    return FB_error;
  }
  //create the datamap  that returnm

  //################################# VERIFY THE EMAIL ADDRESS ####################################
  send_email_verification(
      {Function(String) onfailure, Function(String) onSuccess}) async {
    try {
      //await user.reload();
      if (user != null) {
        await user.sendEmailVerification();
        onSuccess("success");
      } else {
        onfailure("Restart your Login process, something went wrong.");
      }
    } on FirebaseException catch (e) {
      onfailure(e.toString());
    } catch (error) {
      onfailure(onfailure.toString());
    }
  }

  ////////////////////////////ADD USER TO FIRESTORE########################################################
 
  Future<void> addUserToDB(
      {
      String userName, String email, String facebook,
     String google, String blocked, String  phone,  String  joinedDate,
    String  role, String userId, String  isVerified
       
      }) async {
    try {
      wasteUser = WasteUser(
              userId: userId,
              userName: userName,
              email: email,
              facebook: facebook,
              google: google,
              blocked:  blocked,
              phone:  phone,
              joinedDate: joinedDate,
              role: role,
              isVerified:  isVerified
        
        );

      await userRef.doc(userId).set(wasteUser.toMap(wasteUser));// wasteUser.toMap(wasteUser) return map so set 
    } on FirebaseFirestore catch (Error) {
      print(Error.toString());
    } catch (Error) {
      print(Error.toString());
    }
  }
  //################################################## RETRIEVE USER FROM EMAIL ########################

  Future<WasteUser> db_getUserInfo_fromEmail({String email, Function(String) onfailure }) async {
    try {
      await userRef.where('w_email', isEqualTo: email).get().then((value) {
        if (value.docs.isEmpty) {
          //lets create fiestore database
          return null;
        } else {
          //value.docs.single.data()['w_email']);
          wasteUser = WasteUser.fromMap(value.docs.single.data());
          return wasteUser; //return waste User object

        }
      });
    } on FirebaseFirestore catch (Exc) {
      onfailure("Error"+Exc.toString());
    } catch (ex) {
      onfailure("Error"+ex.toString());
    }

    
  }

    set_shared_preferences({String email, bool rememberMe, Function(String) onfailure}) async {
    

    //since waste user object contain the user info so set it to shared preferences
    print(email+"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\/////////// ");
 
    try{
      await db_getUserInfo_fromEmail(email:email , onfailure: (value){onfailure(value);});
       
        
   if(wasteUser.userId!=null){

           LocalData.setUserDetail(
               user_id: wasteUser.userId,
               user_email: wasteUser.email.isEmpty?"guest email" :wasteUser.email,
               user_name: wasteUser.userName.isEmpty ? "dafault name": wasteUser.userName ,
               is_verified : wasteUser.isVerified.isEmpty ? "no" :wasteUser.isVerified,
              is_blocked : wasteUser.blocked.isEmpty ?"no" : wasteUser.blocked,
              role : wasteUser.role.isEmpty? "user": wasteUser.role,


        );

        //lets handle remember me
        LocalData.setRememberMe(rememberMe==false ? "no": "yes");
    } 

    }
    catch(Error){
     onfailure(Error);
    }
  }

  //LocalData.setEmail(user.email==null ?"" :user.uid);
  //LocalData.setEmail(user.email==null ?"" :user.uid);

  //load
  //set user id;

  //set the  email id

  //set verified state

  //4
  Future<UserModel> getUserFromDB({String uid}) async {
    //final DocumentSnapshot doc = await userRef.document(uid).get();

    //print(doc.data());

    //return UserModel.fromMap(doc.data());
  }


  
 
Future<void>  update_verified_state(String email, Function(String) onFailure) async {
  //since we need doc id which is user id, so retrive first


  try{

   await db_getUserInfo_fromEmail(email:email , onfailure: (value){onFailure(value);});

   if(wasteUser.userId!=null){
     userRef.doc(wasteUser.userId)
     .update({'w_verified': 'yes'})
    .then((value) => print("User Updated"))

    .catchError((error) =>  onFailure("Failed to update user: $error"));

     }else{
       onFailure("something went wrong");
     }

  } on FirebaseFirestore catch(Error){
   onFailure(Error.toString());
  }
  
  catch(error){

    onFailure(error);
  }

}


 Future<WasteUser> db_getUserInfo_fromEmail_demo({String email, Function(String) onfailure }) async {
   WasteUser wasteUserx;

    print("Im inside the ////////////////////");
    try {
     
        await userRef.where('w_email', isEqualTo: email).get().catchError( (value){
          print(value);
        }).then((value) =>  (
       
    
          //value.docs.single.data()['w_email']);
            wasteUserx=   WasteUser.fromMap(value.docs.single.data())));
           
   
    } on FirebaseFirestore catch (Exc) {
      print("Error"+Exc.toString());
    } catch (ex) {
      print("Error"+ex.toString());
    }
    return wasteUserx;
  }
/////////////////////////////////STOR IMAGE TO FIREBASE STORAGE

 
uploadToStorage(String userId, File imageFile ) async{
String getImageUrl="";                 
String imageFileName= userId;
print("nnnnnnnnnnnnnnnnnnnnnnnnnnnnn"+imageFile.toString());
 
 //reference for storage
  Reference storageref=  await  FirebaseStorage.instance.ref().child('UsersImage/'+userId);
  
 // dep *StorageUploadTask
 UploadTask uploadTask= storageref.putFile(imageFile);
 
 //on complete
 String url;
 uploadTask.whenComplete(() async {
      String url =   await  storageref.getDownloadURL();
      LocalData.setUserImageUrl(url);

   }).catchError((onError) {
    print(onError);
    });
 

 //give the unique name to image file
 

//lets chechk it...............................
 
}

updateUserName(String usernName, String userId) async{
 
 try{
 userRef.doc(userId).update({'w_userName' : usernName}).
     
               then((value) { 

                 LocalData.setUserName(usernName);
                 //update alos in the  shared preferences
               })
               .catchError((error) => print("Failed to update user: $error"));
 
 } on FirebaseFirestore catch (ex){
   print(ex.toString());

 }
}

Future updateUserEmail(String email, String userId) async{
 
 try{
  await userRef.doc(userId).update({'w_email' : email}).
     
               then((value) { 

                 LocalData.setEmail(email);
                 //update alos in the  shared preferences
               })
               .catchError((error) => print("Failed to update user: $error"));
 
 } on FirebaseFirestore catch (ex){
   print(ex.toString());

 }
}

  }
 