import 'package:bot_toast/bot_toast.dart';
import 'package:waste/Root/constant.dart';

class GunasoModel{
  String gunasotitle;
  String gunasodescription;
  String gunasoquestionDate;
  String gunasouserName;
  String gunasouserAddress;
  String gunasomoderatorName;
  String gunasomoderatorrole;
  String gunasoreplytext;
  String gunasoreplyDate;
  String gunasorequestpending;
  String gunasouserFrom;
  String gunasouserId;
  int gunasoId;

  GunasoModel({
  this.gunasotitle,
  this.gunasodescription,
  this.gunasoquestionDate,
  this.gunasouserName,
  this.gunasouserAddress,
  this.gunasomoderatorName,
  this.gunasouserFrom,
  this.gunasoreplytext,
  this.gunasoreplyDate,
  this.gunasorequestpending,
  this.gunasouserId,
  this.gunasoId,
  
  });

   Map<String, dynamic> toMap(GunasoModel gm){
    Map <String, dynamic> mappedData =new Map();
         print("+knskansk"+gunasotitle.toString());
    mappedData[fieldgunasotitle]= gm.gunasotitle;
   mappedData[fieldgunasoId]=gm.gunasoId;
    mappedData[fieldgunasodescription]=gm.gunasodescription;
    mappedData[fieldgunasouser]=gm.gunasouserName;
    mappedData[fieldgunasoquestionDate]=gm.gunasoquestionDate;
    mappedData[fieldgunasouserAddress]=gm.gunasouserAddress;
    mappedData[fieldgunasouserfrom]=gm.gunasouserFrom;

    mappedData[fieldgunasomoderatorName]=gm.gunasomoderatorName;
    mappedData[fieldgunasoreplyDate]=gm.gunasoreplyDate;
    mappedData[fieldgunasoreplytext]=gm.gunasoreplytext;
   mappedData[fieldgunasopending]=gm.gunasorequestpending;
   mappedData[fieldgunasouserId]=gm.gunasouserId;
   mappedData[fieldgunasomoderatorRole]=gm.gunasomoderatorrole;
   return mappedData;
     
  }

  
  GunasoModel.fromMap(   Map<String, dynamic> mappedData){
 var data= mappedData[fieldgunasoId] ;
   this.gunasoId=data as int;
   this.gunasouserId=mappedData[fieldgunasouserId];
    this.gunasotitle=  mappedData[fieldgunasotitle];
   this.gunasodescription= mappedData[fieldgunasodescription];
   this.gunasouserName= mappedData[fieldgunasouser];
   this.gunasoquestionDate= mappedData[fieldgunasoquestionDate];
  this.gunasouserAddress = mappedData[fieldgunasouserAddress];
   this.gunasouserFrom= mappedData[fieldgunasouserfrom];

    this.gunasomoderatorName=mappedData[fieldgunasomoderatorName];
    this.gunasoreplyDate=mappedData[fieldgunasoreplyDate];
   this.gunasoreplytext= mappedData[fieldgunasoreplytext];
    this.gunasorequestpending=  mappedData[fieldgunasopending];
  }
}
