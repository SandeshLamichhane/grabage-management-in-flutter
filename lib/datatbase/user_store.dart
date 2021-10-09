import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waste/modal/Users.dart';



class UserDatabase{


      CollectionReference coll = FirebaseFirestore.instance.collection("waste_users");

Future <Map>user_info_from_email(String email) async{
/*coll.where('w_email', isEqualTo: email ).get().then((snapshot) {
                         snapshot.docs.forEach((element) {
                          _user_id=element["w_userId"];
                         }); 
                        }).catchError((error){ print(error); });*/
   
   print("i am here");
  final dataMap=   Map<String, dynamic> ();
  await  coll.where('w_email', isEqualTo: email ).get().then((snapshot) { //heere query snapshot. obeject oject of collection
                          snapshot.docs.forEach((element) {
                          //print(element['w_userId']);
                           //print(element['w_email']);
                          
                          dataMap['user_id']=element['w_userId'];
                          dataMap['user_name']=element['w_userName'];
                          dataMap['user_verified']=element['w_verified'];
                          dataMap['user_email']=element['w_email'];
                          dataMap['user_role']=element['w_role'];
                          dataMap['user_blocked']=element['w_isBlocked'];

                          });
                        }). catchError((error){  return "error" ; });
              print("in data map"+dataMap.toString());
                        return dataMap;

  }

  Future <Map>user_info_from_id(String userId) async{
/*coll.where('w_email', isEqualTo: email ).get().then((snapshot) {
                         snapshot.docs.forEach((element) {
                          _user_id=element["w_userId"];
                         }); 
                        }).catchError((error){ print(error); });*/
   
   print("i am here");
  final dataMap=   Map<String, dynamic> ();
  dataMap['error']="";
  await  coll.where('w_userId', isEqualTo: userId ).get().then((snapshot) { //heere query snapshot. obeject oject of collection
                          snapshot.docs.forEach((element) {
                          //print(element['w_userId']);
                           //print(element['w_email']);
                          
                          dataMap['user_id']=element['w_userId'];
                          dataMap['user_name']=element['w_userName'];
                          dataMap['user_verified']=element['w_verified'];
                          dataMap['user_email']=element['w_email'];
                          dataMap['user_role']=element['w_role'];
                          dataMap['user_blocked']=element['w_isBlocked'];
                          dataMap['error']="";

                          });
                        }). catchError((error){  return dataMap['error']=error ; });
              print("in data map"+dataMap.toString());
                        return dataMap;

  }

}