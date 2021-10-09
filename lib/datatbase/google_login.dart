import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waste/datatbase/firebase.dart';
import 'package:waste/datatbase/preferences.dart';
import 'package:waste/modal/Users.dart';

class  googleSignInProvider extends ChangeNotifier{
  WasteUser wasteUser;

FirebaseDatabase firebaseDatabase= new FirebaseDatabase();
final googleSignIn= GoogleSignIn();


bool _isSignIn; //this will notify the user through provider

googleSignInProvider(){
  _isSignIn=false;
}

bool get isSignIn=>_isSignIn; //getter 

set isSignIn(bool isSignIn){ //setter
  _isSignIn=isSignIn;
  notifyListeners();
}

Future Login() async{
  isSignIn=true;
  final user= await googleSignIn.signIn();
  if(user==null){
  //login fails
    return;
  }else{
    final googleAuth= await  user.authentication;

    final credential= GoogleAuthProvider.credential(
      accessToken: googleAuth.idToken,
      idToken: googleAuth.idToken

    );

    await FirebaseAuth.instance.signInWithCredential(credential);
   String google_email= FirebaseAuth.instance.currentUser.email;
   String google_name= FirebaseAuth.instance.currentUser.displayName;


    //destroy cache

LocalData.setUserDetail(user_id: "", is_blocked: "", is_verified: "", role: "",  user_email: "", user_name: "");  

//set catche

 

//print('///////////////////////////////////////////////');
WasteUser w1= await firebaseDatabase.db_getUserInfo_fromEmail_demo(email:  google_email, onfailure: (failure){});
 try{


   if(w1!=null){
 //since user has as email on the firestore so... 
 //lets store cache according firestore data
 

   }else{
   
   //he is a new user for firestore lets store the data into the firestore 
   //set sharedpreferences 
 //##################################  ADD NEW USER ONLY in new ###########################################
      await firebaseDatabase.addUserToDB(
                                userId: DateTime.now().millisecondsSinceEpoch.toString(),
                                userName: google_name,
                                email: google_email,
                                joinedDate: DateTime.now().toString(),
                                facebook: "default",
                                google: google_email,
                                role: "user",
                                blocked: "no",
                                isVerified: "yes",
                                phone: "default"
                        
                                );

    
    
   }
 await firebaseDatabase.set_shared_preferences(
      email: google_email,
      rememberMe: true,
      onfailure: (value){print("Error"+value.toString());}
      
    );
  LocalData.setLoginStyle('google');

   isSignIn=false;
  
    
 }catch(Ex){
   print("Error"+Ex.toString());
 }
//check that email gmail exists on the firestore



// and set the login type to gmail
  //update gmail on the firestore

    
  }

}

void logout() async {
await googleSignIn.disconnect();
FirebaseAuth.instance.signOut();
LocalData.setLoginStyle('');
}

}