import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Root/root.dart';

class LoginController extends GetxController{
bool _isAwaitOperation= false;
var _isLoggedIn=false.obs;

GetStorage storage;
FirebaseAuth _auth= FirebaseAuth.instance;

bool get isLoading=> _isAwaitOperation;

bool get isLoggedin=> _isLoggedIn.value;

setLogedin(bool value) {
  _isLoggedIn.value=value;
}

Rx<User> _firebaseUser;
String get deviceUser=>_firebaseUser.value==null? null: _firebaseUser.value.email;  //if it is null return null
 
 bool get isSignedIn => _auth.currentUser != null;

 Stream<User> authStateChange() => _auth.authStateChanges();
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ LOGOUT AND SET THE LOGIN STATUS FALSE ##########3
  firebase_logout() async{
    try{
     _auth.signOut();  
     _isLoggedIn.value=false;
     storage.write('email', 'null');
      Get.snackbar("Note", "No info will be saved on this device");

    } on FirebaseAuthException catch(error){
      Get.snackbar("Server Error", error.message, snackPosition: SnackPosition.BOTTOM);
    }finally{
    
    }
   
   
   
  }

  firebase_login_with_eamil( 
   
      {String email,
      String password,
      bool rememberMe,
      Function(String) onfailure,
      Function(String) onSuccess}) async {
    try {
    _isAwaitOperation= true; update(); // update the listener

    UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        onSuccess("Successfull Registration");
        _isLoggedIn.value=true;
         setUser(email);// here the user set into local storge
    Get.snackbar("Succes","Success", snackPosition: SnackPosition.BOTTOM);
        //n firebaseUser = value.user; //set login status to firebase to
        //set data to shared preferences
       _isAwaitOperation=false; update();
       //Get.offAll(Root());
     
        return;
      });
    } on FirebaseAuthException catch (e) {
       _isAwaitOperation= false; update();
      Get.snackbar("Server Error",e.message, snackPosition: SnackPosition.BOTTOM);
      
    } catch (e) {
       _isAwaitOperation= false; update();
        Get.snackbar("Other Error","$e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future <void> setUser(String email) async{
   // Get.changeThemeMode(themeMode); //it check user input and chnage theme
   //_themeMode =themeMode;
  // update(); //it notify the listener
   storage= await GetStorage();
    await storage.write('isLogged',true);
    await storage.write('email', email);
   //await storage.write('theme', themeMode.toString().split('.')[1]); //it split Themode.dark // Thememode.light and store onlu dark and light 


  }  



   getUserFromStorage() async{
 
  storage= await GetStorage();
  //now  retriave theme text
  String themeText= storage.read('isLogged')??'no'; //if null then make it system theme
  print("After reading themetext the value is..................................................."+themeText);
  try{
  //themeMode= ThemeMode.values.firstWhere((element) => describeEnum(element)==themeText);
  //print(themeMode.toString());
  //firstwhere return  first element of matching element
  //describe enum return
  }catch(e){
  //  themeMode=ThemeMode.system; //if mistake assign theme return thememode.system

  }finally{
 //setThemeMode(themeMode);
  }

  }
}