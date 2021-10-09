import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Settings/UserSetting/adminUserState/changeUserDataController.dart';

class ChangeUserData extends StatefulWidget {
  String userId;
  String userRole;
  String userFrom;
  String userblockState;
  String phoneNumber;
  String name;
  
    ChangeUserData({ Key key,
    @required this.userId, 
    @required this. userRole, 
    @required this.userblockState, 
    @required  this.userFrom,
    @required this.phoneNumber,
    @required this.name
    }) : super(key: key);

  @override
  _ChangeUserDataState createState() => _ChangeUserDataState();
}


class _ChangeUserDataState extends State<ChangeUserData> {

  final changeUserDataController=Get.put( ChangeUserDataController());
  UserType userRole;
   Block b;
  @override
  void initState() {  
    super.initState();
       b=widget.userblockState=="yes"? Block.yes: Block.no;
     
      
      userRole= UserType.values.firstWhere((element) => describeEnum(element)==widget.userRole);
  
  }
  void x(){
    
  }
  
  @override
  Widget build(BuildContext context) {
  String radiogroupValue=widget.userblockState;
 
 


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.name.toString()),),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
            AutoSizeText.rich(
           TextSpan(
             text: "Edit user profile",
             style: TextStyle(fontWeight:  FontWeight.w900, fontSize:25 ),
             children: [
                
             ]

           )
              ),
              Divider(height: 2, color: Colors.blueGrey,),
               SizedBox(height: 10,),
                 AutoSizeText.rich(
           TextSpan(
             text: "Phone : ",
             style: TextStyle(fontWeight:  FontWeight.w900, fontSize:17 ),
             children: [
                TextSpan(
                  text: widget.phoneNumber,
                  style: TextStyle(fontWeight:FontWeight.w400)
                )
             ]

           )
              ),
    Divider(height:1),
  
     AutoSizeText.rich(
           TextSpan(
             text: "User Type : ",
             style: TextStyle(fontWeight:  FontWeight.w900, fontSize:17 ),
             children: [
                TextSpan(
                  text: widget.userFrom,
                  style: TextStyle(fontWeight:FontWeight.w400)
                )
             ]

           )
              ),
              SizedBox(height: 10,),
         AutoSizeText.rich(
           TextSpan(
             text: "User Current status : ",
             style: TextStyle(fontWeight:  FontWeight.w900, fontSize:17 ),
            

           )
              ),  
        RadioListTile(
           title:Text("Block"),
          value:  Block.yes,
       
          groupValue:    b, onChanged: (val){  b=val;
              setState(() {});}),
          RadioListTile(
             title:Text("Not Blocked"),
            value:    Block.no, groupValue: b, onChanged: (val){
               
              setState(() {
                b=val;
              });
              //set its value to 
              print(val);
              print(b);}),                

    //UPDATE THE USER ROLE ON THE TABLE &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& 
    //
     
     userRole= UserType.values.firstWhere((element) => describeEnum(element)==widget.userRole);
      AutoSizeText(   "User Role : ",
             style: TextStyle(fontWeight:  FontWeight.w900, fontSize:17 ),),
         RadioListTile(
        title: Text("admin"),

        value: UserType.admin, groupValue:  userRole, onChanged: (value){
          setState(() { userRole=value;}); 
        }),
      RadioListTile( title: Text("moderator"),
        value:  UserType.moderator, groupValue: userRole, onChanged: (value){
                    setState(() { userRole=value;}); 

        }),
      RadioListTile(title: Text("driver"),
        value:  UserType.driver, groupValue:  userRole, onChanged: (value){
                    setState(() { userRole=value;}); 

        }),
      RadioListTile(title: Text("user"),
        value: UserType.user, groupValue:  userRole, onChanged: (value){
                    setState(() { userRole=value;}); 

        }),
SizedBox(height: 20,),
  ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    child:
     Container(
     width: double.maxFinite,
       height:50,
       child: ElevatedButton(
         onPressed: (){
        
         String x= b.toString().split('.')[1];
      
         String y=userRole.toString().split('.')[1];
    
          changeUserDataController.ChangeUserData(
            userFrom: widget.userFrom,
            userId:  widget.userId,
            userRole: y, blockState: x);
             
           
         },
         child: Text("Save"))),
  ),
     Text(widget.userId),                  
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}

