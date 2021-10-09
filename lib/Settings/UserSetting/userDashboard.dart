import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:waste/Home/Home_view.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/TrackRoutes/trackTodayroute.dart';
import 'package:waste/Settings/UserSetting/addHospital/addHospital.dart';
import 'package:waste/Settings/UserSetting/addHospitalRoute/addHospitalRoute.dart';
 import 'package:waste/Settings/UserSetting/addRoutes/addRoutes.dart';
import 'package:waste/Settings/UserSetting/adminUserState/changeUserData.dart';
import 'package:waste/Settings/UserSetting/alltodayRoutesDetail/alltodayRoutesDetail.dart';
import 'package:waste/Settings/UserSetting/displayUser/displayUser.dart';
import 'package:waste/Settings/UserSetting/displaytrackHospitalRoute/displayHospitalRoutes.dart';
import 'package:waste/Settings/UserSetting/trackHospitalRoutes/trackHospitalRoutes.dart';

import 'StreamMyDevice/StreamDevice.dart';
import 'addVehicle/addVehicle.dart';
 class UserDashboard extends StatefulWidget {
   const UserDashboard({ Key key }) : super(key: key);
 
   @override
   _UserDashboardState createState() => _UserDashboardState();
 }
 
 class _UserDashboardState extends State<UserDashboard> {
  final box= GetStorage();
 
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  TextEditingController searchBoxController= TextEditingController();

  final _controller= Get.put(userDashBoardController());
 
  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;
  int selectedRow=-1;
  @override
  void initState() {
     searchBoxController.clear();
    users.retrieveData();
    //lets store data on the model
    super.initState();
  }
  
    String searchName="";
  bool diplay_clearButton=false;
  

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children:<Widget>[
              SizedBox(height: 20,),
              CircleAvatar(radius: 30,backgroundColor: Colors.green, child: Text("A", style:TextStyle(fontSize: 20, fontWeight:FontWeight.w900))),
              SizedBox(height: 20,),
              Divider(height: 1,),
             ListTile(title: Text( "All Vehicle Info"),onTap: (){Get.to(AddTruck());}),
             if(box.read(boxuserRole)=='driver' || box.read(boxuserRole)=='admin' )
             ListTile(title: Text( "Stream"),onTap: (){Get.to(StreamDriverDevice());}),
           
            
             ListTile(title: Text( "Add Hosiptal"),onTap: (){Get.to(AddHospital());},),
             ListTile(title: Text( "Add Routes"),onTap: (){Get.to(AddRoutes());}),

            //this is mainly for the driver and the today routes//
            ListTile(title: Text( "Track Routes"),onTap: (){Get.to(TodayRoutes() );}),
               ListTile(title: Text( "View Route History"),onTap: (){Get.to(AllRoutes());}),

            ListTile(title: Text( "Add Hospital Routes"),onTap: (){Get.to(AddHospitalRoutes());}),
          ListTile(title: Text( "Track Hospital Routes"),onTap: (){Get.to(TrackHospitalRoutes());}),
         ListTile(title: Text(  "Track-Hosp History"),onTap: (){Get.to(displayHospitalRoutes());}),

            ListTile(title: Text( "Refresh"),onTap: (){  users.retrieveData();}),
             ListTile(title: Text( "Go Back"),onTap: (){Get.off(UserHomePage());}),

            ]
          ),
        ),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left:0.0),
            child: Container(
            
                  child:Row(children: <Widget>[
                  
                  Obx(()=>(
                    _controller.displaySearchBoxClear?
                    IconButton(onPressed: (){
                    searchBoxController.clear();
                    _controller. displaySearchBoxclear(false);
                  }, icon: Icon(CupertinoIcons.xmark_circle)): Container()),),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller:searchBoxController,
                   
                   keyboardType:   TextInputType.phone,
                    onTap:(){
                      print("sandesh");

                    },
                    onChanged: (val) async{
                  
                      if(val.trim().length>=1){
                        //search the data from flutter 
                        _controller. displaySearchBoxclear(true);
 
                      }else{
                         _controller. displaySearchBoxclear(false);
                      }
                    },
                    style: TextStyle(color: Colors.white),
                    
                        
                 inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                 onEditingComplete: ()async{
                      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

                    if(searchBoxController.text.trim().length>1){
                          users.searchByPhone(searchBoxController.text.trim());
 
                    } 
 
                 },
                    decoration: InputDecoration(
 
                      labelText: "Search Phone",
                      labelStyle: TextStyle(color: Colors.white60),
                      
                      
                        
                    ),
                  )),
                Expanded(
                  flex:0,
                  child:  IconButton(onPressed: () async{
                    if(searchBoxController.text.length>=10){
                   users.searchByPhone(searchBoxController.text.trim());
                    }
                  
                  }, icon: Icon(Icons.search)))
                  ],)
                  ),
          ),
      
         
        ),
        body: _getBodyWidget(),
      ),
    );
  }

  Widget _getBodyWidget() {
    return 
    Obx(()=>
      users.snapshotLngth==0?Container(height:20 , child:Text("if no user is showing, Click refresh")):
      
      Container(
    
        child: HorizontalDataTable(
          leftHandSideColumnWidth: 100,
          rightHandSideColumnWidth: 700,
          isFixedHeader: true,
          headerWidgets: _getTitleWidget(),
          leftSideItemBuilder: _generateFirstColumnRow,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount:  users.userdetail.length,
          rowSeparatorWidget: const Divider(
            color: Colors.black54,
            height: 1.0,
            thickness: 0.0,
          ),
          leftHandSideColBackgroundColor: Color(0x02020200),
           rightHandSideColBackgroundColor:  Color(0x00551020),
          verticalScrollbarStyle: const ScrollbarStyle(
            thumbColor: Colors.yellow,
            isAlwaysShown: true,
            thickness: 4.0,
            radius: Radius.circular(5.0),
          ),
          horizontalScrollbarStyle: const ScrollbarStyle(
            thumbColor: Colors.red,
            isAlwaysShown: true,
            thickness: 4.0,
            radius: Radius.circular(5.0),
          ),
          enablePullToRefresh: true,
          refreshIndicator: const WaterDropHeader(),
          refreshIndicatorHeight: 60,
          onRefresh: () async {
            //Do sth
            users.retrieveData();
            _hdtRefreshController.refreshCompleted();
          },
          htdRefreshController: _hdtRefreshController,
        ),
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: _getTitleItemWidget(
            'Name' + (sortType == sortName ? (isAscending ? '↓' : '↑') : ''),
            150),
        onPressed: () {
          
        
          setState(() {});
        },
      ),
      
       
      _getTitleItemWidget('Phone', 200),
      _getTitleItemWidget('UserFrom', 100),
      _getTitleItemWidget('Role', 100),
      _getTitleItemWidget('Blocked Sate', 100),
      _getTitleItemWidget('JoinedDate', 200),
     ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold,)),
      width: width,
      height: 56,
      decoration:BoxDecoration(
        color:  Color(0xFF3333FAFF),

      ),
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        // BotToast.showText(text: users.userdetail[index].userPhone );
            setState(() {
              selectedRow=index;
               
            });
            Get.bottomSheet(Container(
              color: Colors.brown,
              height: 80,
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                   ElevatedButton(onPressed: (){
                     Get.to(DisplayuserFromId(userId: users.userdetail[index].userId.toString()));
                   },
                    child: Text("View")),
                   ElevatedButton(onPressed: (){
                     Get.back();
                     Get.to(ChangeUserData(
                       name: users.userdetail[index].userName.toString(),
                       phoneNumber: users.userdetail[index].userPhone.toString(),
                       userId: users.userdetail[index].userId.toString(), 
                       userRole: users.userdetail[index].userRole.toString(),
                        userblockState: users.userdetail[index].blockState.toString(),
                         userFrom: users.userdetail[index].userFrom.toString()));
                   }, child: Text("Edit")),
                ],
              )
            ));
      },
      child: Container(
         color:  selectedRow==index?Colors.blueGrey: Colors.transparent,
        child: Text(  users.userdetail[index].userName),
        width: 100,
        height: 52,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        print(index.toString()+'/'+selectedRow.toString());
        setState(() {
          selectedRow=index;
          
        });
      },


      child: Container(
        color:  selectedRow==index?Colors.blueGrey : Colors.transparent,
        child: Row(
          
          children: <Widget>[
          
    
            InkWell(
              onTap:(){
                Get.bottomSheet(Text("Edit"+"View"));
                 GetAddressFromPhone(users.userdetail[index].userId.toString());
              },
              child: Container(
                child: Text(users.userdetail[index].userPhone.substring(4)),
                width: 200,
                height: 52,
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
              ),
            ),
    
            Container(
              child: users.userdetail[index].userFrom=='Guest'? 
                        Icon(Icons.person, color: Colors.green,):
                    users.userdetail[index].userFrom=='Hospital' ?  
                    Icon(Icons.local_hospital, color: Colors.red):
                 Icon(Icons.home, color: Colors.red),
    
                       
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(users.userdetail[index].userRole),
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child:  users.userdetail[index].blockState!="no"? 
             Icon( Icons.notifications_off, color: Colors.red,):
                    Icon(    Icons.notifications_active, color: Colors.green),
              width: 100,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            ),
              Container(
              child: Text(users.userdetail[index].userJoinedDate),
              width:200,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
            )
            
          ],
        ),
      ),
    );
  }

  void GetAddressFromPhone(String userId) async {
    try{
      var doc= await FirebaseFirestore.instance.collection("users").doc(userId).collection('address').doc(userId).get().catchError((err){
        BotToast.showText(text: err.toString());
      });
      if(doc.data()==null){
        BotToast.showText(text: "Address of current user not availabe", duration: Duration(seconds: 5));
        return;
      }
      else{
        var data= doc.data() ;


      }

     


    }catch(error){
      BotToast.showText(text: error.toString());
    }
  }
}

Users users= new Users();
 
 
class Users extends GetxController{
 List<UserDetail> userdetail;
    RxInt hasUserLenght=0.obs;
    int get snapshotLngth => hasUserLenght.value;
  

  void retrieveData()async{
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "No Internet Connection");
   return;
  }
userdetail=[];
 DisplayLoading.show(text: "Retrieving....", display: true);
  var querySnapshot=await  FirebaseFirestore.instance.collection("users").get().catchError((e){
     DisplayLoading.show(text: "Retrieving....", display: false);
    BotToast.showText(text:e.toString() );
  });

  
  DisplayLoading.show(text: "Retrieving....", display: false);
    if(querySnapshot.docs.length<1){
      BotToast.showText(text: "No user record", duration:Duration(seconds: 4));
      return;
    }else{
     querySnapshot.docs.forEach((element) { 
          var data=   element.data();
          userdetail.add(UserDetail.fromJson(data));

     });

   hasUserLenght.value = querySnapshot.docs.length;
   
    }
  }
// ############################################## SEARCH BY PHONE #########################
     searchByPhone(String phone)async{
      userdetail=[];
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "No Internet Connection");
   return;
  }

 DisplayLoading.show(text: "Searching....", display: true);


  var x=  await FirebaseFirestore.instance
               .collection('users')
                .where("userPhone",   isEqualTo: '+977'+ phone.trim())
                .get().            
               catchError((e){
     DisplayLoading.show(text: " ....", display: false);
    BotToast.showText(text:e.toString() );
  });

  
  DisplayLoading.show(text: " ....", display: false);
    if(x.docs.length<1){
      BotToast.showText(text: "No user record", duration:Duration(seconds: 2));
      return;
    }else{
     x.docs.forEach((element) { 
          var data=   element.data();
          userdetail.add(UserDetail.fromJson(data));

     });

   hasUserLenght.value = x.docs.length;
   
    }
  }
 
}

class UserDetail{
    String userFrom;
    String userId;
    String userJoinedDate;
   String userName;
    String userPhone;
   String userVerified;
   String userRole;
   String blockState;

 UserDetail({this.userFrom, this.blockState, this.userId, this.userJoinedDate, this.userName, this.userPhone,this.userVerified, this.userRole});
   
  UserDetail.fromJson(Map json){
    this.userFrom=json['userFrom']; print(this.userFrom);
    this.userId=json['userId'];
    this.userName=json['userName'];
    this.userVerified=json['userVerified'];
    this.userPhone=json['userPhone'];
    this.userJoinedDate=json['userJoinedDate'];
    this.userRole=json['userRole'];
    this.userRole=json['userRole'];
    this.blockState=json['userBlockState'];
    print(json);
  }

}

class userDashBoardController extends GetxController{
RxBool _displaySearchBoxClear= false.obs;
bool get displaySearchBoxClear=>_displaySearchBoxClear.value;

 displaySearchBoxclear(bool value){
_displaySearchBoxClear.value=value;
}


}