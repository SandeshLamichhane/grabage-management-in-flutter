import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waste/Home/Home_view.dart';
import 'package:waste/InitialPage/FifthPage/CreatePassword.dart';
import 'package:waste/InitialPage/FifthPage/custom/Hospital/addHospital.dart';
import 'package:waste/InitialPage/FourthPage/PhoneNumber.dart';
 import 'package:waste/InitialPage/SecondPage/SecondPageController.dart';
import 'package:waste/InitialPage/ThirdPage/SelectService.dart';
import 'package:waste/InitialPage/sixth/latLong.dart';
import 'package:waste/InitialPage/userModel.dart';
   import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Root/root.dart';
import 'package:waste/Root/root.dart';
 
class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final box = GetStorage();
   final _controller= Get.put(  secondPageController());

  @override
  void initState() {
    super.initState();
    box.read(boxuserHospitalName);
    box.read(boxuserName);
    box.read(boxverifiedState);
    if (box.read(boxUserId) != 'null') {
   //   loadUserDataFromFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: globalFunction().customLinearGradient,
          ),
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/logo.png'))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AutoSizeText(
                      'Waste Service',
                      style:
                          TextStyle(fontSize: 24,color: Theme.of(context).shadowColor, fontWeight: FontWeight.w800),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 80,
              ),
              AutoSizeText(
                "फोहोर महिला व्यवस्थापनमा यहाँलाई स्वागत छ ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: Theme.of(context).shadowColor, fontWeight: FontWeight.w800),
              ),
              AutoSizeText(
                "अब आफ्नो गुनासो पनि यहि मोवाइलबाट पोख्नुहोस",
                style: TextStyle(fontSize: 14, color: Theme.of(context).shadowColor, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height:( MediaQuery.of(context).size.height)/3,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    child: Text(
                      'अगाडि बढ्नुहोस',
                      style: TextStyle(fontSize: 15),
                    ),
                       onPressed: () async {
                  /// First of all read the data from     box;
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: """
कृपया इन्टरनेटसंग जोडिनुहोस""");
   return;
  }
  //check user is null or not
 
 print(box.read(boxuserPhoneNumber));
 print(box.read(boxusergeopoint));
 
if(box.read(boxuserPhoneNumber)=="null" ){
  //if phone number is null 
  Get.to(SelectService());
}else{
  //map the box store data to singleton instance
  try{
 
 
  }catch(e){
    BotToast.showText(text: e.toString());
  }
  UserModel().loadBoxValuetoUserModel();
  await _controller.getUserInfoFromFirestore();
      _controller.movetoNextPage();
}
 

 

 //


             
                   return;

                      int value = 1;

                      if (value == 1) {
                                          
     

                       // scondPageController.movetoNextPage();
                     //   Get.to(UserHomePage());
                        return;
                      } else {}

                      BotToast.showText(text: box.read(boxuserType));
                      print(box.read(boxuserType));
                      String phn = box.read(boxuserPhoneNumber).toString();

                      String verifiedstate = box.read(boxverifiedState);

                      String password = box.read(boxUserPassword);

                      String marg = box.read(boxuserMarg);

                      String usertype = box.read(boxuserType);
                      String lat = box.read(boxuserLat);
                      String hospitalName = box.read(boxuserHospitalName);

                      //select service is null
                      if (usertype == 'null') {
                        Get.to(SelectService());
                        return;
                        
                      }

                      if (usertype == 'Hospital') {
                        DriveHospitalUsertoNextPage();
                        return;
                      }
// DRIVE GUEST TO NEXT PAGE  /////////////////
                      if (usertype == "Guest") {
                        print(usertype);
                        driveGuestUsertoNextPage();

                        return;
                      }
                      // if nothing is not null
                      if (usertype != 'null' &&
                          phn != 'null' &&
                          verifiedstate == "yes" &&
                          password != "null" &&
                          marg != "null" &&
                          lat != 'null') {
                        Get.to(UserHomePage());
                        return;
                      }

                      //if user has phone number but not password
                      if (phn != "null" &&
                          verifiedstate == "yes" &&
                          password == "null") {
                        Get.to(CreatePassword());
                        return;
                      } else if (phn != "null" &&
                          verifiedstate == "yes" &&
                          password != "null" &&
                          marg != "null") {
                    //    Get.to(LATLONG());
                      } else if (phn != "null" &&
                          verifiedstate == "yes" &&
                          password != "null") {
                       // Get.to(UserAddress());
                      } else {
                        Get.to(() => PhoneNumberVerification());
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            
            ],
          ),
        ),
      ),
    );
  }

  void DriveHospitalUsertoNextPage() {
    String hospitalName = box.read(boxuserHospitalName);
    String phn = box.read(boxuserPhoneNumber).toString();
    String verifiedstate = box.read(boxverifiedState);
    String password = box.read(boxUserPassword);
    String marg = box.read(boxuserMarg);
    String usertype = box.read(boxuserType);
    String lat = box.read(boxuserLat);

//  if every thing is alright
//

    if (usertype != 'null' &&
        phn != 'null' &&
        verifiedstate == "yes" &&
        password != "null" &&
        hospitalName != 'null' &&
        lat != 'null') {
      Get.to(UserHomePage());
      return;
    }
    // GET PHONE NUMber
    if (verifiedstate == "no" || verifiedstate == "null") {
      Get.to(PhoneNumberVerification());
      return;
    }
    //GET PASSWORD
    if (phn != "null" && verifiedstate == "yes" && password == "null") {
      print(phn + verifiedstate + password);
      //   Get.to(CreatePassword());
      return;
    }
////Get Hospital Name
    if (hospitalName == 'null' || lat == 'null') {
     // Get.to(SelectHospital());
      return;
    }
    
  }

  void driveGuestUsertoNextPage() {
    String hospitalName = box.read(boxuserHospitalName);
    String phn = box.read(boxuserPhoneNumber).toString();
    String verifiedstate = box.read(boxverifiedState);
    String password = box.read(boxUserPassword);
    String marg = box.read(boxuserMarg);
    String usertype = box.read(boxuserType);
    String lat = box.read(boxuserLat);

    if (usertype != 'null' &&
        phn != 'null' &&
        verifiedstate == "yes" &&
        password != "null" &&
        lat != 'null') {
      Get.offAll(UserHomePage());
      return;
    }

    // GET PHONE NUMber
    if (verifiedstate == "no" || verifiedstate == "null") {
      Get.to(PhoneNumberVerification());
      return;
    }
    //GET PASSWORD
    if (phn != "null" && verifiedstate == "yes" && password == "null") {
      Get.to(CreatePassword());
      return;
    }
    // IF
    if (verifiedstate == "yes" && password != 'null' && lat == 'null') {
     // Get.to(LATLONG());
      return;
    }
  }

  void loadUserDataFromFirestore() async {
    try {
      bool hasInternet = await hasInsternet();
      if (hasInternet) {
        var snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(box.read(boxUserId))
            .get();
        print(snapshot);
        if (snapshot.data() != null) {
          var data = snapshot.data();

          SetBoxData.store(userFrom: data['userFrom']);
          SetBoxData.store(userId: data['userId']);
          SetBoxData.store(userRole: data['userRole']);
          SetBoxData.store(userName: data['userName']);
          SetBoxData.store(verifiedstate: data['userVerified']);
          SetBoxData.store(password: data['userPassword']);
          SetBoxData.store(userPhone: data['userPhone']);
        }

        var firestoreData = await FirebaseFirestore.instance
            .collection('users')
            .doc(box.read(boxUserId))
            .collection('address')
            .get()
            .catchError((error) {
          BotToast.showText(text: error.toString());
        });
        var datax = firestoreData.docs[0].data();

        if (datax != null) {
          if (box.read(boxuserType) == 'Hospital') {
            SetBoxData.store(hospitalName: datax['hospitalName']);
            SetBoxData.store(lat: datax['lat']);
            SetBoxData.store(long: datax['long']);
          }
          if (box.read(boxuserType) == 'Home') {}
          if (box.read(boxuserType) == 'Guest') {
            SetBoxData.store(lat: datax['lat']);
            SetBoxData.store(long: datax['long']);
          }
        }
      }
    } catch (Error) {
      BotToast.showText(text: Error.toString());
    }
  }
}
